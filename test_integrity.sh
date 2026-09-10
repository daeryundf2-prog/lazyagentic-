#!/usr/bin/env bash
# test_integrity.sh — lazyagentic POSIX counterpart of test_integrity.ps1
# Usage: ./test_integrity.sh [--base <plugin-dir>] [--junction <junction-dir>]
set -euo pipefail
BASE="${HOME}/.gemini/config/plugins/lazyagentic"
JUNCTION="${HOME}/agentic"
while [ $# -gt 0 ]; do
  case "$1" in
    --base) BASE="$2"; shift 2;;
    --junction) JUNCTION="$2"; shift 2;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done
MAX_LINES=800; MAX_BYTES=46080; MAX_CHARS=12000
fail=0
echo "=== TEST 1: Junction Path Integrity ==="
echo "base=$BASE junction=$JUNCTION"
if [ -d "$JUNCTION/rules" ]; then
  echo "[PASS] Junction $JUNCTION exists"
elif [ -d "$BASE/rules" ]; then
  echo "[WARN] Junction missing — falling back to plugin path $BASE"
else
  echo "[FAIL] Neither junction nor plugin path readable"; exit 1
fi
echo ""
echo "=== TEST 2: Rule File Capacity Audit (rules/) ==="
for f in "$BASE"/rules/*.md; do
  [ -e "$f" ] || continue
  lines=$(wc -l < "$f" | tr -d ' ')
  bytes=$(wc -c < "$f" | tr -d ' ')
  chars=$(wc -m < "$f" | tr -d ' ')
  name=$(basename "$f")
  if [ "$lines" -le "$MAX_LINES" ] && [ "$bytes" -le "$MAX_BYTES" ] && [ "$chars" -le "$MAX_CHARS" ]; then
    echo "[PASS] $name ${lines}L ${bytes}B ${chars}ch"
  else
    echo "[FAIL] $name exceeds limit (${lines}L ${bytes}B ${chars}ch)"; fail=1
  fi
done
echo ""
echo "=== TEST 3: RULES.md Reference Targets ==="
grep -o '\[~/agentic/\(rules/[^]]*\)\]' "$BASE/RULES.md" | sed 's/^\[~/~/;s/\]$//' | while read -r ref; do
  rel=${ref#"~/agentic/"}
  if [ -e "$BASE/$rel" ] || [ -e "$JUNCTION/$rel" ]; then
    echo "[PASS] $rel"
  else
    echo "[FAIL] Missing target: $rel"; fail=1
  fi
done
echo ""
echo "=== TEST 3b: Title Consistency (NN- prefix vs '# NN.') ==="
for f in "$BASE"/rules/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  num=$(echo "$base" | grep -o '^[0-9]*' || true)
  first=$(head -n 1 "$f")
  case "$first" in
    "# $num."*) echo "[PASS] $base";;
    *) echo "[FAIL] Title mismatch: $base -> '$first'"; fail=1;;
  esac
done
echo ""
echo "=== TEST 4: Global GEMINI.md Entry Point Resolution ==="
GLOBAL_GEMINI="$(dirname "$(dirname "$BASE")")/GEMINI.md"
echo "global=$GLOBAL_GEMINI"
if [ -f "$GLOBAL_GEMINI" ]; then
  echo "[PASS] Global GEMINI.md exists ($GLOBAL_GEMINI)"
else
  echo "[WARN] Global GEMINI.md missing ($GLOBAL_GEMINI) — plugin path still usable"
fi
echo ""
if [ "$fail" -ne 0 ]; then echo ">>> SOME TESTS FAILED <<<"; exit 1; fi
echo ">>> ALL LAZYAGENTIC TESTS PASSED <<<"
