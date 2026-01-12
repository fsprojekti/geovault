#!/bin/bash
# bip39_gpu_pbkdf2_hashcat_stats.sh
# GPU PBKDF2 performance:
#   - Hashcat PBKDF2-HMAC-SHA512 benchmark (mode 12100, 999 iterations),
#     scaled to 2048 iterations (BIP-39 cost).
# Adds:
#   - raw CSV export per run
#   - mean/stddev stats (AWK)
#
# NOTE: hashcat -b is a benchmark, not a real mnemonic PBKDF2 run.
#       This script measures kernel throughput and scales linearly.

set -euo pipefail

RUNS=500
OUT_CSV="bip39_gpu_pbkdf2_raw_results.csv"

# ---- Dependency checks ----
for cmd in hashcat awk bc; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd"
    echo "Install it, e.g.: sudo apt install hashcat bc gawk"
    exit 1
  fi
done

echo "=== BIP-39 12-word – GPU PBKDF2 performance (Hashcat) ==="

# Try to print GPU model if nvidia-smi exists
if command -v nvidia-smi >/dev/null 2>&1; then
  echo "GPU(s):"
  nvidia-smi --query-gpu=index,name,memory.total --format=csv,noheader
fi
echo

echo "Saving raw data to: $OUT_CSV"
echo "Run,R999_hashes_per_s,R2048_hashes_per_s,Time_ms_per_check" > "$OUT_CSV"
echo "Measuring $RUNS benchmark runs..."
echo

# 1) Benchmark Loop
for i in $(seq 1 "$RUNS"); do
  # Run hashcat benchmark (mode 12100 = PBKDF2-HMAC-SHA512)
  # Hashcat's benchmark uses 999 iterations for this mode (as shown in output).
  HC_OUTPUT=$(hashcat -b -m 12100 2>&1 || true)

  SPEED_LINE=$(echo "$HC_OUTPUT" | grep -m1 "Speed.#" || true)
  if [ -z "$SPEED_LINE" ]; then
    echo "ERROR: Could not parse hashcat speed line on run $i. Full output:"
    echo "$HC_OUTPUT"
    exit 1
  fi

  # Example: Speed.#1.........:  1379.3 kH/s (54.04ms) @ ...
  SPEED_NUM=$(echo "$SPEED_LINE"  | awk '{print $2}')     # e.g. 1379.3
  SPEED_UNIT=$(echo "$SPEED_LINE" | awk '{print $3}')     # e.g. kH/s, MH/s

  case "$SPEED_UNIT" in
    H/s)  MULT=1 ;;
    kH/s) MULT=1000 ;;
    MH/s) MULT=1000000 ;;
    GH/s) MULT=1000000000 ;;
    *)
      echo "Unexpected hashcat unit: $SPEED_UNIT"
      echo "Full speed line: $SPEED_LINE"
      MULT=1
      ;;
  esac

  # Raw PBKDF2 evaluations per second at 999 iterations
  R999=$(echo "$SPEED_NUM * $MULT" | bc -l)

  # Scale linearly to 2048 iterations (BIP-39 cost)
  R2048=$(echo "$R999 * 999 / 2048" | bc -l)

  # Time per BIP-39 PBKDF2 (in ms)
  MS_PER_CHECK=$(echo "1000 / $R2048" | bc -l)

  # Save raw row
  printf "%s,%0.6f,%0.6f,%0.9f\n" "$i" "$R999" "$R2048" "$MS_PER_CHECK" >> "$OUT_CSV"

  # Small progress line
  printf "Run %2d: R_2048=%0.3f checks/s  T=%0.6f ms\n" "$i" "$R2048" "$MS_PER_CHECK"
done

echo

# 2) Calculate Statistics using AWK
# We compute mean/stddev for R2048 and Time_ms_per_check.
STATS=$(awk -F, '
  NR > 1 {
    r_sum += $3; r_sq += $3*$3;
    t_sum += $4; t_sq += $4*$4;
    n++;
  }
  END {
    if (n > 0) {
      r_mean = r_sum / n;
      r_std  = sqrt((r_sq / n) - (r_mean * r_mean));
      t_mean = t_sum / n;
      t_std  = sqrt((t_sq / n) - (t_mean * t_mean));
      printf "%.6f|%.6f|%.9f|%.9f", r_mean, r_std, t_mean, t_std;
    }
  }
' "$OUT_CSV")

R2048_MEAN=$(echo "$STATS" | cut -d'|' -f1)
R2048_STD=$(echo "$STATS"  | cut -d'|' -f2)
TMEAN_MS=$(echo "$STATS"   | cut -d'|' -f3)
TSTD_MS=$(echo "$STATS"    | cut -d'|' -f4)

echo "--- Results (scaled to BIP-39 cost: PBKDF2-HMAC-SHA512, 2048 iterations) ---"
printf "Average Throughput    : %12.3f checks/second\n" "$R2048_MEAN"
printf "Throughput Std Dev    : %12.3f checks/second\n" "$R2048_STD"
printf "Average Time (Mean)   : %12.6f ms\n" "$TMEAN_MS"
printf "Standard Deviation    : %12.6f ms\n" "$TSTD_MS"
echo "CSV export complete: $OUT_CSV"
echo

echo "=== Summary (per BIP-39 PBKDF2 evaluation, 2048 iterations) ==="
printf "Hashcat GPU kernel :  T_GPU ≈ %0.6f ± %0.6f ms  (%.3f ± %.3f checks/s)\n" \
  "$TMEAN_MS" "$TSTD_MS" "$R2048_MEAN" "$R2048_STD"
