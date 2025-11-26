#!/bin/bash
# bip39-cpu.sh
# CPU PBKDF2 performance:
#   1) Python PBKDF2-HMAC-SHA512, 2048 iterations (BIP-39 cost)
#   2) Optional: hashcat PBKDF2-HMAC-SHA512 benchmark in CPU-only mode (mode 12100, 999 iterations),
#      scaled to 2048 iterations.
#
# This script ONLY benchmarks the KDF. It does NOT generate or crack mnemonics.

set -euo pipefail

MNEMONIC="abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
RUNS=100

# ---- Dependency checks ----
for cmd in python3 bc; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd"
    echo "Install it, e.g.: sudo apt install python3 bc"
    exit 1
  fi
done

echo "=== BIP-39 12-word – CPU PBKDF2 performance ==="
if command -v lscpu >/dev/null 2>&1; then
  echo "CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
fi
echo

########################################
# 1) CPU baseline: Python, 2048 iters  #
########################################

echo "--- CPU baseline (Python, PBKDF2-HMAC-SHA512, 2048 iterations) ---"
echo "Measuring $RUNS runs..."

CPU_SEC_PER_RUN=$(
python3 - <<EOF
import time, hashlib

mnemonic = """$MNEMONIC"""
salt = b"mnemonic"
runs = $RUNS

start = time.perf_counter()
for _ in range(runs):
    hashlib.pbkdf2_hmac("sha512", mnemonic.encode("utf-8"), salt, 2048)
end = time.perf_counter()

avg = (end - start) / runs
print(f"{avg:.9f}")
EOF
)

AVG_MS_CPU=$(echo "$CPU_SEC_PER_RUN * 1000" | bc -l)
AVG_US_CPU=$(echo "$CPU_SEC_PER_RUN * 1000000" | bc -l)

echo "CPU average over $RUNS runs:"
printf "  T_CPU ≈ %8.3f ms  (%6.1f µs)\n" "$AVG_MS_CPU" "$AVG_US_CPU"
echo

# Derived CPU checks/sec for comparison later
CPU_CHECKS_PER_SEC=$(echo "1000 / $AVG_MS_CPU" | bc -l)

########################################################
# 2) Optional: hashcat in CPU-only mode (if available) #
########################################################

HAVE_HC=0   # will flip to 1 if hashcat CPU benchmark works

if command -v hashcat >/dev/null 2>&1; then
  echo "--- Optional: hashcat PBKDF2 benchmark in CPU-only mode (mode 12100, 999 iterations) ---"
  echo "Trying hashcat with CPU device type (-D 1); if no CPU OpenCL runtime is present, this will fall back to 'not available'."
  echo

  # -D 1 = OpenCL device type CPU; with POCL or Intel runtime this hits the CPU only
  HC_OUTPUT=$(hashcat -b -m 12100 -D 1 2>&1 || true)

  if echo "$HC_OUTPUT" | grep -qi "No devices found\|No devices suitable"; then
    echo "No CPU OpenCL device available for hashcat; install a CPU OpenCL runtime (e.g. POCL) if you want hashcat-based CPU numbers."
  else
    SPEED_LINE=$(echo "$HC_OUTPUT" | grep -m1 "Speed.#" || true)
    if [ -n "$SPEED_LINE" ]; then
      # Example: Speed.#3.........:    29804 H/s (50.80ms) @ ...
      SPEED_NUM=$(echo "$SPEED_LINE"  | awk '{print $2}')     # e.g. 29804 or 111.9
      SPEED_UNIT=$(echo "$SPEED_LINE" | awk '{print $3}')     # e.g. H/s, kH/s, MH/s

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
      MS_PER_CHECK_HC=$(echo "1000 / $R2048" | bc -l)

      echo "Hashcat CPU-only raw speed (999 iterations):"
      printf "  R_999  ≈ %0.3f  hashes/s (%s %s)\n" "$R999" "$SPEED_NUM" "$SPEED_UNIT"
      echo "Scaled to BIP-39 cost (2048 iterations):"
      printf "  R_2048 ≈ %0.3f  hashes/s\n" "$R2048"
      printf "  T_HC   ≈ %0.6f ms per BIP-39 check (CPU via hashcat)\n" "$MS_PER_CHECK_HC"

      HAVE_HC=1
    else
      echo "Could not parse hashcat CPU speed; raw output was:"
      echo "$HC_OUTPUT"
    fi
  fi
else
  echo "hashcat not installed; skipping hashcat-based CPU benchmark."
fi

echo

######################################
# 3) Direct, comparable summary      #
######################################

echo "=== Summary (per BIP-39 PBKDF2 evaluation, 2048 iterations) ==="
printf "Python (hashlib)       :  T_CPU ≈ %8.3f ms  (%.3f checks/s)\n" "$AVG_MS_CPU" "$CPU_CHECKS_PER_SEC"

if [ "$HAVE_HC" -eq 1 ]; then
  # Hashcat checks/sec is just R2048
  HC_CHECKS_PER_SEC="$R2048"
  SPEEDUP=$(echo "$AVG_MS_CPU / $MS_PER_CHECK_HC" | bc -l)

  printf "Hashcat CPU kernel     :  T_HC  ≈ %8.6f ms  (%.3f checks/s)\n" "$MS_PER_CHECK_HC" "$HC_CHECKS_PER_SEC"
  printf "Relative speedup       :  hashcat CPU ≈ %.1f× faster than Python\n" "$SPEEDUP"
else
  echo "Hashcat CPU kernel     :  not available (no CPU OpenCL runtime detected)"
fi

echo
echo "Done. Above numbers reflect **CPU-only** PBKDF2 performance."


