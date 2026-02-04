#!/bin/bash
set -euo pipefail

RUNTIME_S=30
HASH_MODE=1400

DIGITS_PER_POINT=14
MASK_1POINT='?d?d?d?d?d?d?d?d?d?d?d?d?d?d'

# Must exist
command -v mp64 >/dev/null
command -v hashcat >/dev/null
command -v openssl >/dev/null

TARGET_PLAINTEXT="NOT_IN_KEYSPACE_abcdef"
TARGET_HASH_HEX="$(printf "%s" "$TARGET_PLAINTEXT" | openssl dgst -sha256 | awk '{print $2}')"
HASHFILE="target_sha256.hash"
echo "$TARGET_HASH_HEX" > "$HASHFILE"

echo "Target hash: $TARGET_HASH_HEX"
echo "Testing mp64 output (first 3 candidates):"
mp64 "$MASK_1POINT" | head -n 3
echo

LOGFILE="hashcat_debug_1point.log"
rm -f "$LOGFILE"

echo "Running hashcat for ${RUNTIME_S}s... logging to $LOGFILE"
set +e
mp64 "$MASK_1POINT" | hashcat -m "$HASH_MODE" -a 0 -D 2 \
  --potfile-disable --restore-disable --hwmon-disable \
  --status --status-timer=1 --runtime "$RUNTIME_S" -w 4 \
  "$HASHFILE" /dev/stdin >"$LOGFILE" 2>&1
RC=$?
set -e

echo "hashcat exit code: $RC"
echo "---- last 80 log lines ----"
tail -n 80 "$LOGFILE"
echo "---------------------------"

echo "Extracted Speed lines:"
grep -E '^Speed\.#' "$LOGFILE" || echo "(none)"
