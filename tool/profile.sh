#!/usr/bin/env bash
set -euo pipefail

echo "Running app in profile mode..."
echo "Tip: Attach DevTools separately (see tool/devtools.sh)"

flutter run --profile -d chrome

