#!/bin/bash
# bip39_gpu_pbkdf2_hashcat.sh
# GPU PBKDF2 performance:
#   - Hashcat PBKDF2-HMAC-SHA512 benchmark (mode 12100, 999 iterations),
#     scaled to 2048 iterations (BIP-39 cost).
#
# This script ONLY benchmarks the KDF. It does NOT generate or crack mnemonics.

set -euo pipefail

# ---- Dependency checks ----
for cmd in hashcat bc; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd"
    echo "Install it, e.g.: sudo apt install hashcat bc"
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

##############################################
# 1) Hashcat GPU benchmark: 999 iterations  #
##############################################

echo "--- Hashcat PBKDF2 benchmark (GPU, mode 12100, 999 iterations) ---"
echo "Running: hashcat -b -m 12100"
echo

HC_OUTPUT=$(hashcat -b -m 12100 2>&1 || true)

# Find the first Speed.# line (usually GPU #1)
SPEED_LINE=$(echo "$HC_OUTPUT" | grep -m1 "Speed.#" || true)
if [ -z "$SPEED_LINE" ]; then
  echo "ERROR: Could not parse hashcat speed line. Full output:"
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

# R_999 = PBKDF2 evaluations per second at 999 iterations (hashcat benchmark)
R999=$(echo "$SPEED_NUM * $MULT" | bc -l)

# Scale linearly to 2048 iterations (BIP-39 cost)
R2048=$(echo "$R999 * 999 / 2048" | bc -l)

# Time per BIP-39 PBKDF2 (in ms)
MS_PER_CHECK=$(echo "1000 / $R2048" | bc -l)

echo "Hashcat GPU raw speed (999 iterations):"
printf "  R_999  ≈ %0.3f  hashes/s (%s %s)\n" "$R999" "$SPEED_NUM" "$SPEED_UNIT"
echo
echo "Scaled to BIP-39 cost (2048 iterations):"
printf "  R_2048 ≈ %0.3f  hashes/s\n" "$R2048"
printf "  T_GPU  ≈ %0.6f ms per BIP-39 check\n" "$MS_PER_CHECK"
echo

######################################
# 2) Direct, ready-to-copy summary   #
######################################

echo "=== Summary (per BIP-39 PBKDF2 evaluation, 2048 iterations) ==="
printf "Hashcat GPU kernel :  T_GPU ≈ %0.6f ms  (%.3f checks/s)\n" "$MS_PER_CHECK" "$R2048"
echo
echo "You can cite this as:"
echo "  \"On our GPU (hashcat mode 12100), we measured ≈ $R2048 PBKDF2-2048 evaluations per second"
echo "   (≈ $MS_PER_CHECK ms per BIP-39 check).\""

