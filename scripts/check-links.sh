#!/usr/bin/env bash
# check-links.sh — verify RULES.md ~/agentic/ + relative ](rules/) links (exit 0/1)
# Usage: bash scripts/check-links.sh [--base <dir>] [--junction <dir>]
set -euo pipefail
BASE="$(cd "$(dirname "$0")/.." && pwd)"
JUNCTION="$BASE"
while [ $# -gt 0 ]; do case "$1" in --base) BASE="$2"; shift 2;; --junction) JUNCTION="$2"; shift 2;; *) echo "unknown arg: $1" >&2; exit 2;; esac; done
fail=0; checked=0
for ref in $(grep -oE '\]\(~/agentic/[^)]+\)' "$BASE/RULES.md" | sed -e 's|.*~/agentic/||' -e 's|)||' || true); do
  rel=$(echo "$ref" | cut -d'#' -f1 | cut -d'?' -f1); checked=$((checked+1))
  if [ -e "$BASE/$rel" ] || [ -e "$JUNCTION/$rel" ]; then echo "[PASS] ~/$rel"; else echo "[FAIL] Missing: $rel"; fail=1; fi
done
for ref in $(grep -oE '\]\(rules/[^)]+\)' "$BASE/RULES.md" | sed -e 's|.*(||' -e 's|)||' || true); do
  rel=$(echo "$ref" | cut -d'#' -f1 | cut -d'?' -f1); checked=$((checked+1))
  if [ -e "$BASE/$rel" ] || [ -e "$JUNCTION/$rel" ]; then echo "[PASS] $rel"; else echo "[FAIL] Missing: $rel"; fail=1; fi
done
if [ "$checked" -eq 0 ]; then echo "[PASS] No ~/agentic/ or rules/ links (nothing to check)"; fi
if [ "$fail" -ne 0 ]; then echo ">>> CHECK-LINKS FAILED <<<" >&2; exit 1; fi
echo ">>> CHECK-LINKS PASSED ($checked links) <<<"
# local-only verification; no CI workflow wiring (workflow scope constraint)
