#!/usr/bin/env bash
set -euo pipefail

RUN_DATE="$(date +%F)"
BASE_DIR="reports/${RUN_DATE}"
RAW_DIR="${BASE_DIR}/raw"
LATEST_DIR="reports/latest"

mkdir -p "${BASE_DIR}" "${RAW_DIR}" "${LATEST_DIR}"

# Normalize responsive reports
if [ -f reports/RESPONSIVE_AUDIT.md ]; then
  cp reports/RESPONSIVE_AUDIT.md "${BASE_DIR}/01_responsive_audit_report.md"
fi
if [ -f reports/responsive_audit_report.md ]; then
  cp reports/responsive_audit_report.md "${BASE_DIR}/01_responsive_audit_report.md"
fi
if [ -f reports/responsive_migration_map.json ]; then
  cp reports/responsive_migration_map.json "${BASE_DIR}/01_responsive_migration_map.json"
fi

# Move generic reports into raw (if any)
for f in reports/REPORT.md reports/DONE_REPORT.md reports/NEXT_TASKS.md reports/TASKS.md reports/issues.json reports/ARCH_MAP.txt; do
  if [ -f "$f" ]; then
    cp "$f" "${RAW_DIR}/" || true
  fi
done

# Update latest snapshot
rm -f ${LATEST_DIR}/* 2>/dev/null || true
cp -a ${BASE_DIR}/* ${LATEST_DIR}/ 2>/dev/null || true

# Generate global summary
dart scripts/gen_summary.dart || true
echo "Report pack complete for ${RUN_DATE}"

