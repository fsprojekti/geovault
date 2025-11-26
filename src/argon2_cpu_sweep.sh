#!/bin/bash
# argon2_cpu_sweep.sh
# CPU-only Argon2id runtime sweep over memory cost 2^m KiB.
#
# Usage:
#   ./argon2_cpu_sweep.sh [m_exp_start] [m_exp_end] [runs]
#
# Defaults:
#   m_exp_start = 10   (1 MiB = 2^10 KiB)
#   m_exp_end   = 23   (~8 GiB = 2^23 KiB)
#   runs        = 20   (measurements per configuration)
#
# Outputs:
#   - Summary CSV (per m_exp):  argon2_cpu_m<mstart>_<mend>_r<runs>_summary.csv
#   - Raw CSV (per run):        argon2_cpu_m<mstart>_<mend>_r<runs>_raw.csv

set -euo pipefail

#####################
# Config / Defaults #
#####################

TIME_COST=1          # Argon2 t
PARALLELISM=1        # Argon2 p
TYPE="id"            # Argon2id

MEXP_START=${1:-10}
MEXP_END=${2:-23}
RUNS=${3:-20}

PASSWORD="example-w3w-password"
SALT="example-w3w-salt"

SUMMARY_OUT="argon2_cpu_m${MEXP_START}_${MEXP_END}_r${RUNS}_summary.csv"
RAW_OUT="argon2_cpu_m${MEXP_START}_${MEXP_END}_r${RUNS}_raw.csv"

#####################
# Dependency checks #
#####################

for cmd in argon2 bc date; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd"
    echo "Install it, e.g.: sudo apt install argon2 bc coreutils"
    exit 1
  fi
done

if (( MEXP_END < MEXP_START )); then
  echo "Error: m_exp_end ($MEXP_END) < m_exp_start ($MEXP_START)"
  exit 1
fi

echo "=== Argon2id CPU sweep ==="
echo "Summary file: ${SUMMARY_OUT}"
echo "Raw file    : ${RAW_OUT}"
echo "Memory exponents: m = ${MEXP_START} .. ${MEXP_END}  (2^m KiB)"
echo "Parameters: t=${TIME_COST}, p=${PARALLELISM}, type=${TYPE}, runs=${RUNS}"
echo

####################
# CSV headers      #
####################

if [ ! -f "$SUMMARY_OUT" ]; then
  echo "m_exp,mem_kib,mem_mib,time_cost,parallelism,type,runs,avg_ms,std_ms" > "$SUMMARY_OUT"
fi

if [ ! -f "$RAW_OUT" ]; then
  echo "m_exp,mem_kib,mem_mib,run_idx,ms" > "$RAW_OUT"
fi

####################
# Main sweep       #
####################

for MEXP in $(seq "$MEXP_START" "$MEXP_END"); do
  MEM_KIB=$((1 << MEXP))
  MEM_MIB=$((MEM_KIB / 1024))

  echo ">>> Measuring m_exp=${MEXP} (mem ≈ ${MEM_MIB} MiB, ${MEM_KIB} KiB) ..."

  TOTAL_MS=0
  TOTAL_MS2=0

  for ((i=1; i<=RUNS; i++)); do
    START_NS=$(date +%s%N)

    echo -n "${PASSWORD}" | \
      argon2 "${SALT}" \
        -t "${TIME_COST}" \
        -m "${MEXP}" \
        -p "${PARALLELISM}" \
        -"${TYPE}" \
        > /dev/null

    END_NS=$(date +%s%N)
    D_NS=$((END_NS - START_NS))

    # nanoseconds -> milliseconds (float)
    MS=$(echo "scale=6; $D_NS / 1000000" | bc -l)

    TOTAL_MS=$(echo "$TOTAL_MS + $MS" | bc -l)
    MS2=$(echo "$MS * $MS" | bc -l)
    TOTAL_MS2=$(echo "$TOTAL_MS2 + $MS2" | bc -l)

    echo "   run ${i}/${RUNS}: ${MS} ms"

    # Append raw line immediately
    printf "%d,%d,%d,%d,%.6f\n" \
      "$MEXP" "$MEM_KIB" "$MEM_MIB" "$i" "$MS" >> "$RAW_OUT"
  done

  MEAN_MS=$(echo "scale=6; $TOTAL_MS / $RUNS" | bc -l)
  MEAN_MS2=$(echo "scale=6; $TOTAL_MS2 / $RUNS" | bc -l)

  # variance = E[X^2] - (E[X])^2, clamp at 0 if negative due to rounding
  VAR_MS=$(echo "scale=10; v = $MEAN_MS2 - ($MEAN_MS * $MEAN_MS); if (v < 0) v = 0; v" | bc -l)
  STD_MS=$(echo "scale=6; sqrt($VAR_MS)" | bc -l)

  echo "   -> average: ${MEAN_MS} ms, stddev: ${STD_MS} ms for mem ≈ ${MEM_MIB} MiB"
  echo

  # Append summary line for this exponent
  printf "%d,%d,%d,%d,%d,%s,%d,%.6f,%.6f\n" \
    "$MEXP" "$MEM_KIB" "$MEM_MIB" "$TIME_COST" "$PARALLELISM" "$TYPE" "$RUNS" "$MEAN_MS" "$STD_MS" >> "$SUMMARY_OUT"
done

echo "Sweep complete."
echo "Summary written to: ${SUMMARY_OUT}"
echo "Raw data written to: ${RAW_OUT}"

