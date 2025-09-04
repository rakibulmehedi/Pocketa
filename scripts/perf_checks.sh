#!/usr/bin/env bash
set -euo pipefail

# -------- Config --------
DART="flutter"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Fail if any command prints "NEW WARNING" style lines you define
warn=false

echo "=== CI Guard: gen-l10n ==="
$DART gen-l10n

echo "=== CI Guard: flutter analyze ==="
# Capture baseline warnings count if you keep a snapshot; otherwise fail on any warnings.
# Example: fail on any warnings
ANALYZE_OUT=$(mktemp)
set +e
$DART analyze >"$ANALYZE_OUT"
ANALYZE_STATUS=$?
set -e
echo "$(<"$ANALYZE_OUT")"
if grep -q "warning •" "$ANALYZE_OUT"; then
  echo "❌ Analyze produced warnings."
  warn=true
fi
if [[ $ANALYZE_STATUS -ne 0 ]]; then
  echo "❌ Analyze failed."
  exit 1
fi

echo "=== CI Guard: detect hardcoded UI strings (heuristic) ==="
# Heuristic: Text("..."), AppBar(title: Text("...")), SnackBar(content: Text("..."))
# Exclude tests, generated, l10n, logs, debugging prints.
HARD_CODED=$(mktemp)
set +e
grep -RIn --include="*.dart" \
  -E 'Text\s*\(\s*"(?!\s*\))[^"]{3,80}"|Text\s*\(\s*'\''[^'\'']{3,80}'\''' \
  lib/ \
  | grep -Ev 'l10n/|generated/|\.g\.dart|_test\.dart|debugPrint|logger\.d|log\(' \
  > "$HARD_CODED"
set -e
if [[ -s "$HARD_CODED" ]]; then
  echo "❌ Hardcoded UI strings found (use S.of(context).key):"
  cat "$HARD_CODED"
  exit 1
fi

echo "=== CI Guard: ARB keys must be snake_case (no dot keys) ==="
DOT_KEYS=$(mktemp)
set +e
grep -RIn --include="*.arb" -E '"[A-Za-z0-9_.]+"\s*:' l10n/ \
  | grep -E '\."' \
  > "$DOT_KEYS"
set -e
if [[ -s "$DOT_KEYS" ]]; then
  echo "❌ Dot-notation keys detected in ARB (use snake_case):"
  cat "$DOT_KEYS"
  exit 1
fi

echo "=== CI Guard: excessive MediaQuery reads (heuristic) ==="
# Flag repeated size reads outside responsive.dart; allow viewInsets/padding exceptions.
MQ_OCC=$(mktemp)
set +e
grep -RIn --include="*.dart" -E 'MediaQuery\.of\([^)]*\)\.size\.(width|height)' lib/ \
  | grep -v 'core/responsive/responsive.dart' \
  > "$MQ_OCC"
set -e
if [[ -s "$MQ_OCC" ]]; then
  echo "❌ Direct MediaQuery size reads detected (use context.vw/vh or Responsive.of(context)):"
  cat "$MQ_OCC"
  exit 1
fi

echo "=== CI Guard: widget/golden tests at 360/800/1200 ==="
# Run your test suite (should include width assertions)
$DART test --coverage

echo "✅ CI Guard Passed."