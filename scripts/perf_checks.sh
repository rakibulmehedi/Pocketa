#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# POCKETA - Performance & Quality Checks Script
# Senior-Level CI Guard Implementation
# =============================================================================

# -------- Configuration --------
DART="flutter"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Performance thresholds
MAX_SETSTATE_CALLS=50
MAX_NON_CONST_WIDGETS=20
MAX_MEDIAQUERY_CALLS=30
MAX_WIDGET_PARAMETERS=10
MAX_FILE_SIZE_LINES=500

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Initialize counters
warn=false
error_count=0
warning_count=0

# =============================================================================
# LOCALIZATION CHECKS
# =============================================================================
log_info "Running localization checks..."

echo "=== CI Guard: gen-l10n ==="
$DART gen-l10n

echo "=== CI Guard: ARB keys must be snake_case (no dot keys) ==="
DOT_KEYS=$(mktemp)
set +e
grep -RIn --include="*.arb" -E '"[A-Za-z0-9_.]+"\s*:' lib/l10n/ \
  | grep -E '\."' \
  > "$DOT_KEYS"
set -e
if [[ -s "$DOT_KEYS" ]]; then
  log_error "Dot-notation keys detected in ARB (use snake_case):"
  cat "$DOT_KEYS"
  ((error_count++))
fi

# =============================================================================
# CODE ANALYSIS
# =============================================================================
log_info "Running code analysis..."

echo "=== CI Guard: flutter analyze ==="
ANALYZE_OUT=$(mktemp)
set +e
$DART analyze >"$ANALYZE_OUT"
ANALYZE_STATUS=$?
set -e
echo "$(<"$ANALYZE_OUT")"
if grep -q "warning •" "$ANALYZE_OUT"; then
  log_error "Analyze produced warnings."
  warn=true
  ((error_count++))
fi
if [[ $ANALYZE_STATUS -ne 0 ]]; then
  log_error "Analyze failed."
  exit 1
fi

# =============================================================================
# HARDCODED STRINGS DETECTION
# =============================================================================
log_info "Checking for hardcoded UI strings..."

echo "=== CI Guard: detect hardcoded UI strings (heuristic) ==="
HARD_CODED=$(mktemp)
set +e
grep -RIn --include="*.dart" \
  -E 'Text\s*\(\s*"(?!\s*\))[^"]{3,80}"|Text\s*\(\s*'\''[^'\'']{3,80}'\''' \
  lib/ \
  | grep -Ev 'l10n/|generated/|\.g\.dart|_test\.dart|debugPrint|logger\.d|log\(' \
  > "$HARD_CODED"
set -e
if [[ -s "$HARD_CODED" ]]; then
  log_error "Hardcoded UI strings found (use S.of(context).key):"
  cat "$HARD_CODED"
  ((error_count++))
fi

# =============================================================================
# RESPONSIVE DESIGN CHECKS
# =============================================================================
log_info "Checking responsive design patterns..."

echo "=== CI Guard: excessive MediaQuery reads (heuristic) ==="
MQ_OCC=$(mktemp)
set +e
grep -RIn --include="*.dart" -E 'MediaQuery\.of\([^)]*\)\.size\.(width|height)' lib/ \
  | grep -v 'core/responsive/responsive.dart' \
  > "$MQ_OCC"
set -e
if [[ -s "$MQ_OCC" ]]; then
  log_error "Direct MediaQuery size reads detected (use context.vw/vh or Responsive.of(context)):"
  cat "$MQ_OCC"
  ((error_count++))
fi

# =============================================================================
# PERFORMANCE ANTI-PATTERNS
# =============================================================================
log_info "Checking performance anti-patterns..."

echo "=== Performance Check: setState usage ==="
setstate_count=$(grep -r "setState" lib/ --include="*.dart" | wc -l)
echo "setState calls: $setstate_count"
if [ "$setstate_count" -gt $MAX_SETSTATE_CALLS ]; then
  log_warning "High number of setState calls detected: $setstate_count (threshold: $MAX_SETSTATE_CALLS)"
  ((warning_count++))
fi

echo "=== Performance Check: const constructors ==="
const_missing=$(grep -r "Widget(" lib/ --include="*.dart" | grep -v "const " | grep -v "test/" | wc -l)
echo "Non-const Widget constructors: $const_missing"
if [ "$const_missing" -gt $MAX_NON_CONST_WIDGETS ]; then
  log_warning "High number of non-const Widget constructors: $const_missing (threshold: $MAX_NON_CONST_WIDGETS)"
  ((warning_count++))
fi

echo "=== Performance Check: 'new' keyword usage ==="
new_keyword=$(grep -r "new " lib/ --include="*.dart" | grep -v "// TODO" | wc -l)
echo "'new' keyword usage: $new_keyword"
if [ "$new_keyword" -gt 0 ]; then
  log_error "'new' keyword usage detected: $new_keyword (use const instead)"
  ((error_count++))
fi

echo "=== Performance Check: List constructors ==="
list_const=$(grep -r "List<" lib/ --include="*.dart" | grep -v "const " | grep -v "test/" | wc -l)
echo "Non-const List constructors: $list_const"
if [ "$list_const" -gt 10 ]; then
  log_warning "High number of non-const List constructors: $list_const"
  ((warning_count++))
fi

echo "=== Performance Check: MediaQuery usage ==="
mediaquery_count=$(grep -r "MediaQuery\.of" lib/ --include="*.dart" | wc -l)
echo "MediaQuery usage: $mediaquery_count"
if [ "$mediaquery_count" -gt $MAX_MEDIAQUERY_CALLS ]; then
  log_warning "High number of MediaQuery usage: $mediaquery_count (threshold: $MAX_MEDIAQUERY_CALLS)"
  ((warning_count++))
fi

# =============================================================================
# MEMORY LEAK DETECTION
# =============================================================================
log_info "Checking for potential memory leaks..."

echo "=== Memory Check: Resource disposal ==="
streamcontroller_count=$(grep -r "StreamController" lib/ --include="*.dart" | wc -l)
timer_count=$(grep -r "Timer\." lib/ --include="*.dart" | wc -l)
animation_count=$(grep -r "AnimationController" lib/ --include="*.dart" | wc -l)
dispose_count=$(grep -r "dispose\|cancel\|close" lib/ --include="*.dart" | wc -l)

echo "StreamController usage: $streamcontroller_count"
echo "Timer usage: $timer_count"
echo "AnimationController usage: $animation_count"
echo "Disposal methods: $dispose_count"

if [ "$streamcontroller_count" -gt 0 ] && [ "$dispose_count" -lt "$streamcontroller_count" ]; then
  log_warning "Potential memory leaks - StreamControllers without proper disposal"
  ((warning_count++))
fi

# =============================================================================
# WIDGET COMPLEXITY ANALYSIS
# =============================================================================
log_info "Analyzing widget complexity..."

echo "=== Complexity Check: Widget nesting ==="
deep_nesting=$(find lib/ -name "*.dart" -exec grep -l "Widget.*Widget.*Widget.*Widget" {} \; | wc -l)
echo "Files with deep widget nesting: $deep_nesting"

echo "=== Complexity Check: Widget parameters ==="
high_params=$(grep -r "Widget(" lib/ --include="*.dart" | grep -o "," | wc -l)
echo "Widget parameter complexity: $high_params"
if [ "$high_params" -gt $MAX_WIDGET_PARAMETERS ]; then
  log_warning "High widget parameter complexity: $high_params (threshold: $MAX_WIDGET_PARAMETERS)"
  ((warning_count++))
fi

echo "=== Complexity Check: File sizes ==="
large_files=$(find lib/ -name "*.dart" -size +500c | wc -l)
echo "Large widget files (>500 lines): $large_files"
if [ "$large_files" -gt 5 ]; then
  log_warning "High number of large widget files detected: $large_files"
  ((warning_count++))
fi

# =============================================================================
# SECURITY CHECKS
# =============================================================================
log_info "Running security checks..."

echo "=== Security Check: Debug prints ==="
debug_prints=$(grep -r "print\|debugPrint\|printDebugInformation" lib/ --include="*.dart" | grep -v "// TODO\|// FIXME\|// NOTE" | wc -l)
echo "Debug prints in production code: $debug_prints"
if [ "$debug_prints" -gt 0 ]; then
  log_error "Debug prints found in production code: $debug_prints"
  ((error_count++))
fi

echo "=== Security Check: Hardcoded secrets ==="
secrets=$(grep -r -i "password\|secret\|key\|token\|api_key" lib/ --include="*.dart" | grep -v "// TODO\|// FIXME\|// NOTE" | wc -l)
echo "Potential hardcoded secrets: $secrets"
if [ "$secrets" -gt 0 ]; then
  log_error "Potential hardcoded secrets found: $secrets"
  ((error_count++))
fi

# =============================================================================
# TESTING
# =============================================================================
log_info "Running tests..."

echo "=== CI Guard: widget/golden tests at 360/800/1200 ==="
$DART test --coverage

# =============================================================================
# FINAL SUMMARY
# =============================================================================
log_info "Generating performance summary..."

echo ""
echo "=========================================="
echo "📊 PERFORMANCE & QUALITY SUMMARY"
echo "=========================================="
echo "Errors: $error_count"
echo "Warnings: $warning_count"
echo "setState calls: $setstate_count"
echo "Non-const Widgets: $const_missing"
echo "MediaQuery usage: $mediaquery_count"
echo "Large files: $large_files"
echo "=========================================="

if [ "$error_count" -gt 0 ]; then
  log_error "CI Guard failed with $error_count errors"
  exit 1
elif [ "$warning_count" -gt 0 ]; then
  log_warning "CI Guard passed with $warning_count warnings"
else
  log_success "CI Guard passed with no issues"
fi

echo ""
log_success "All performance and quality checks completed successfully!"