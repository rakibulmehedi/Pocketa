# CI Guard — i18n / Responsive / Performance

This guard fails CI when:
- `flutter analyze` reports warnings or errors
- Hardcoded UI strings are detected (heuristic: `Text("...")`)
- Dot-notation ARB keys are present (must be snake_case)
- Direct `MediaQuery.of(context).size.width/height` are found outside `core/responsive/responsive.dart`

## How to run locally
```bash
chmod +x scripts/perf_checks.sh
scripts/perf_checks.sh