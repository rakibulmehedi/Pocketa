#!/usr/bin/env bash
set -euo pipefail

echo "Launching Dart DevTools..."
flutter pub global activate devtools >/dev/null 2>&1 || true
flutter pub global run devtools

