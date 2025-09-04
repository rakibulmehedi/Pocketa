# Analysis Report — 2025-09-02

Toolchain note: `flutter`/`dart` CLI not available in this environment. Static analysis performed via source scanning. Scripts are provided to run full analysis locally and pack reports.

## Analyzer Findings (static heuristics)
- MediaQuery usages: 1 (viewInsets only, acceptable)
  - lib/features/wallets/presentations/widgets/add_wallet_sheet.dart:123 — uses `viewInsets` for keyboard (OK)
- LayoutBuilder hotspots: 2
  - lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart:415 — Amount section layout switch (OK)
  - lib/core/responsive/responsive.dart:23 — Intentional helper (OK)
- Hardcoded UI strings: none detected in presentation (i18n enforced)
- Responsive scope: Present at app root (lib/app.dart: builder → Responsive)
- Potential overflow fixed: Summary header height clamped and paddings adapted

## Predicted runtime issues
- None critical detected. Monitor transaction form for overflow on extreme text scales.

## Performance risks
- add_edit_transaction_screen.dart is large (~880 LOC): consider splitting into sub-widgets to reduce rebuild surfaces.
- Consider adding prototypeItem/itemExtent in lists where cells are uniform (N/A for current SliverList that interleaves dividers).

## i18n status
- All user-facing strings appear localized via AppLocalizations. ARB files bn/en synchronized.

## Suggested local commands
```
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter analyze > reports/2025-09-02/analyze.out.txt || true
fvm flutter test --coverage > reports/2025-09-02/test.out.txt || true
```
