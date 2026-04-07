$ErrorActionPreference = 'Continue'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$missingPath = Join-Path $root 'pdf_missing_entries.csv'

if (-not (Test-Path $missingPath)) {
  throw "Missing audit file: $missingPath"
}

$missingRows = Import-Csv -Path $missingPath
$results = @()

function LooksLikePdf([string]$filePath) {
  if (-not (Test-Path $filePath)) { return $false }
  try {
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    if ($bytes.Length -lt 4) { return $false }
    return ($bytes[0] -eq 0x25 -and $bytes[1] -eq 0x50 -and $bytes[2] -eq 0x44 -and $bytes[3] -eq 0x46)
  } catch {
    return $false
  }
}

function AddIfNew([System.Collections.Generic.List[string]]$list, [string]$value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return }
  if (-not $list.Contains($value)) { [void]$list.Add($value) }
}

foreach ($row in $missingRows) {
  $key = $row.key
  $doi = $row.doi
  $url = $row.url

  $candidateUrls = New-Object System.Collections.Generic.List[string]

  if (-not [string]::IsNullOrWhiteSpace($url)) {
    foreach ($token in ($url -split '\s+')) {
      if ($token -match '^https?://') {
        AddIfNew $candidateUrls $token
      }
    }
  }

  if (-not [string]::IsNullOrWhiteSpace($doi)) {
    $doiEscaped = [Uri]::EscapeDataString($doi)
    AddIfNew $candidateUrls ("https://doi.org/$doiEscaped")

    if ($doi -like '10.1007/*') {
      AddIfNew $candidateUrls ("https://link.springer.com/content/pdf/$doi.pdf")
    }

    try {
      $oaUrl = "https://api.unpaywall.org/v2/$doiEscaped?email=someone@gmail.com"
      $oaResp = Invoke-WebRequest -Uri $oaUrl -UseBasicParsing -TimeoutSec 25
      $oa = $oaResp.Content | ConvertFrom-Json
      if ($oa -and $oa.best_oa_location) {
        AddIfNew $candidateUrls $oa.best_oa_location.url_for_pdf
        AddIfNew $candidateUrls $oa.best_oa_location.url
      }
    } catch {
      # ignore unpaywall failures
    }
  }

  $savedFile = ''
  $status = 'not_found'
  $sourceUrl = ''

  foreach ($candidate in $candidateUrls) {
    $tmp = Join-Path $env:TEMP (([Guid]::NewGuid().ToString()) + '.bin')
    try {
      Invoke-WebRequest -Uri $candidate -OutFile $tmp -MaximumRedirection 8 -TimeoutSec 40 -Headers @{ 'User-Agent' = 'Mozilla/5.0' } | Out-Null
      if (LooksLikePdf $tmp) {
        $targetName = "$key-openaccess.pdf"
        $targetPath = Join-Path $root $targetName
        Move-Item -Path $tmp -Destination $targetPath -Force
        $savedFile = $targetName
        $status = 'downloaded'
        $sourceUrl = $candidate
        break
      }
    } catch {
      # continue trying next candidate
    }

    if (Test-Path $tmp) {
      Remove-Item -Path $tmp -Force -ErrorAction SilentlyContinue
    }
  }

  $results += [pscustomobject]@{
    key = $key
    doi = $doi
    status = $status
    saved_file = $savedFile
    source_url = $sourceUrl
    tried_count = $candidateUrls.Count
  }
}

$resultPath = Join-Path $root 'pdf_open_access_fetch_results.csv'
$results | Sort-Object key | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $resultPath

$downloaded = $results | Where-Object { $_.status -eq 'downloaded' }
Write-Output "ATTEMPTED=$($results.Count)"
Write-Output "DOWNLOADED=$($downloaded.Count)"
Write-Output "RESULTS_FILE=$resultPath"
if ($downloaded.Count -gt 0) {
  $downloaded | Select-Object -First 20 | ForEach-Object { Write-Output "DOWNLOADED_KEY=$($_.key) FILE=$($_.saved_file)" }
}
