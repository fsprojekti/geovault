$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent $root
$candidateBibPaths = @(
  (Join-Path $root 'references.bib'),
  (Join-Path (Join-Path $workspaceRoot 'mdpi') 'references.bib')
)

$bibPath = $candidateBibPaths |
  Where-Object { Test-Path $_ } |
  ForEach-Object { Get-Item $_ } |
  Sort-Object Length -Descending |
  Select-Object -First 1 -ExpandProperty FullName

if (-not $bibPath) {
  throw 'Cannot find any .bib file to audit.'
}

$content = Get-Content -Path $bibPath -Raw -Encoding UTF8
$pdfFiles = Get-ChildItem -Path $root -File | Where-Object { $_.Extension -ieq '.pdf' }

function Normalize([string]$s) {
  if ([string]::IsNullOrWhiteSpace($s)) { return '' }
  $t = $s.ToLowerInvariant()
  $t = [regex]::Replace($t, '\\[a-zA-Z]+\{([^}]*)\}', '$1')
  $t = [regex]::Replace($t, '[^a-z0-9]+', ' ')
  $t = [regex]::Replace($t, '\s+', ' ').Trim()
  return $t
}

$parts = [regex]::Split($content, '(?m)^@') | Where-Object { $_.Trim().Length -gt 0 }

$pdfIndex = @()
foreach ($p in $pdfFiles) {
  $pdfIndex += [pscustomobject]@{
    Name = $p.Name
    Base = $p.BaseName.ToLowerInvariant()
    Norm = Normalize $p.BaseName
  }
}

$rows = @()
foreach ($part in $parts) {
  $entry = '@' + $part

  $keyMatch = [regex]::Match($entry, '^@\w+\{\s*([^,]+),')
  if (-not $keyMatch.Success) { continue }

  $titleMatch = [regex]::Match($entry, '(?is)\btitle\s*=\s*\{(.*?)\}\s*,')
  $doiMatch = [regex]::Match($entry, '(?is)\bdoi\s*=\s*\{(.*?)\}\s*,')
  $urlMatch = [regex]::Match($entry, '(?is)\burl\s*=\s*\{(.*?)\}\s*,')
  $fileMatch = [regex]::Match($entry, '(?is)\bfile\s*=\s*\{(.*?)\}\s*,')

  $key = $keyMatch.Groups[1].Value.Trim()
  $title = if ($titleMatch.Success) { $titleMatch.Groups[1].Value.Trim() } else { '' }
  $doi = if ($doiMatch.Success) { $doiMatch.Groups[1].Value.Trim() } else { '' }
  $url = if ($urlMatch.Success) { $urlMatch.Groups[1].Value.Trim() } else { '' }
  $fileField = if ($fileMatch.Success) { $fileMatch.Groups[1].Value.Trim() } else { '' }

  $hasPdf = $false
  $matchReason = ''

  if ($fileField) {
    $fileFieldPdfNames = @([regex]::Matches($fileField, '([^:;]+\.pdf)') | ForEach-Object { [System.IO.Path]::GetFileName($_.Groups[1].Value) })
    foreach ($fn in $fileFieldPdfNames) {
      $bn = [System.IO.Path]::GetFileNameWithoutExtension($fn).ToLowerInvariant()
      $hit = $pdfIndex | Where-Object { $_.Base -eq $bn -or $_.Base -eq ($bn + '-annotated') -or $_.Base.Contains($bn) } | Select-Object -First 1
      if ($hit) {
        $hasPdf = $true
        $matchReason = "file-field: $($hit.Name)"
        break
      }
    }
  }

  if (-not $hasPdf -and $title) {
    $titleWords = (Normalize $title) -split ' ' | Where-Object { $_.Length -ge 5 } | Select-Object -First 6
    if ($titleWords.Count -ge 3) {
      foreach ($pdf in $pdfIndex) {
        $hits = 0
        foreach ($w in $titleWords) {
          if ($pdf.Norm.Contains($w)) { $hits++ }
        }
        if ($hits -ge 3) {
          $hasPdf = $true
          $matchReason = "title-match: $($pdf.Name)"
          break
        }
      }
    }
  }

  if (-not $hasPdf -and $doi) {
    $doiTail = ($doi -replace '^.*?/', '').ToLowerInvariant()
    $hit = $pdfIndex | Where-Object { $_.Base.Contains($doiTail) } | Select-Object -First 1
    if ($hit) {
      $hasPdf = $true
      $matchReason = "doi-tail: $($hit.Name)"
    }
  }

  if (-not $hasPdf) {
    $normalizedKey = Normalize $key
    if ($normalizedKey.Length -ge 5) {
      $hit = $pdfIndex | Where-Object { $_.Norm.Contains($normalizedKey) -or $normalizedKey.Contains($_.Norm) } | Select-Object -First 1
      if ($hit) {
        $hasPdf = $true
        $matchReason = "key-match: $($hit.Name)"
      }
    }
  }

  $rows += [pscustomobject]@{
    key = $key
    title = $title
    doi = $doi
    url = $url
    has_pdf = $hasPdf
    match_reason = $matchReason
  }
}

$reportPath = Join-Path $root 'pdf_audit_report.csv'
$missingPath = Join-Path $root 'pdf_missing_entries.csv'

$rows | Sort-Object key | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $reportPath
$missingRows = $rows | Where-Object { -not $_.has_pdf } | Sort-Object key
$missingRows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $missingPath

Write-Output "TOTAL_ENTRIES=$($rows.Count)"
Write-Output "TOTAL_PDFS=$($pdfFiles.Count)"
Write-Output "MISSING_COUNT=$($missingRows.Count)"
Write-Output "BIB_SOURCE=$bibPath"
if ($missingRows.Count -gt 0) {
  $missingRows | Select-Object -First 30 | ForEach-Object { Write-Output "MISSING_KEY=$($_.key)" }
}
