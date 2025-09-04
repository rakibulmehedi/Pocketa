# Responsive Refactor Audit (Centralized via core/responsive/responsive.dart)

## Summary
- Centralized responsiveness now flows exclusively through `lib/core/responsive/responsive.dart`.
- Re-export connects advanced `context.s` API (from `core/ui/responsive.dart`) to the public surface so screens import a single module.
- Removed ad‑hoc `MediaQuery` use in Transactions list; clamped summary header height to avoid desktop overflow.

## Inventory & Baseline (key patterns found)
| File | Line | Pattern | Suggested Fix |
|------|------|---------|---------------|
| lib/features/transaction/presentation/pages/transaction_list_screen.dart | 33 | MediaQuery.size.width (removed) | Use `context.s` or `ResponsiveConstrained` |
| lib/shared/widgets/summary_header.dart | 23 | Constant padding (16,56,16,16) | Use `context.s.rem(...)` adaptive padding |
| lib/app.dart | 24 | Imported core/ui/responsive.dart | Import `core/responsive/responsive.dart` |
| lib/features/transaction/presentation/pages/transaction_list_screen.dart | 10 | Imported core/ui/responsive.dart | Import `core/responsive/responsive.dart` |
| lib/shared/widgets/summary_header.dart | 3 | Imported core/ui/responsive.dart | Import `core/responsive/responsive.dart` |
| lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart | 415 | LayoutBuilder (width branching) | OK (local form layout), keep for now |
| lib/features/wallets/presentations/widgets/add_wallet_sheet.dart | 123 | MediaQuery.viewInsets | OK (keyboard), keep |

## Changes Applied
- Re-exported advanced helpers from `core/responsive/responsive.dart` and added `context.isCompact` alias.
- Added numeric helpers `.w(ctx)` and `.h(ctx)` (viewport fractions) to central API.
- TransactionListScreen now uses:
  - `expandedHeight: (0.22.h(ctx)).clamp(180, 260)`
  - `context.s.space*` for spacing and `56.ic(ctx)` for icon sizing.
- SummaryHeader uses `rem()`-based adaptive paddings; no hardcoded magic numbers.

## Before → After (snippets)
- Before (header height): `expandedHeight: 240`
- After: `expandedHeight: (0.22.h(context)).clamp(180.0, 260.0)`

- Before (header padding): `EdgeInsets.fromLTRB(16,56,16,16)`
- After: `EdgeInsets.fromLTRB(2.rem(ctx), topRem, 2.rem(ctx), 2.rem(ctx))`

## Files Migrated
- lib/app.dart (imports)
- lib/features/transaction/presentation/pages/transaction_list_screen.dart
- lib/shared/widgets/summary_header.dart

## Items to Tackle Next
- Add/Edit Transaction screen: replace scattered constants with `context.s.space*`, consider `ResponsiveConstrained` for overall page paddings.
- Wallet picker / Add wallet sheet: adopt `context.s.pageGutter` for outer padding.
- Dashboard body: replace magic numbers with `context.s` helpers consistently.

## Validation Plan
- fvm flutter analyze
- fvm flutter test
- Manual checks at widths: 360, 800, 1200 — verify padding, maxWidth, and header height within clamps and no text overflow.

*** End of Report ***
