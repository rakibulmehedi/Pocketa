# Responsive UI/UX Audit and Refactor

## Summary
- Central responsive utility confirmed at `lib/core/ui/responsive.dart` (AppSize, context.s, rem/sp/ic, gutters, grid helpers).
- Supplemental simple breakpoints found at `lib/core/responsive/responsive.dart` and a `ResponsiveScaffold` at `lib/core/responsive/responsive_scaffold.dart`.
- Inconsistent usage detected: some screens used `MediaQuery` and magic numbers.
- Actions: Extended central utility with `.w` and `.h` (percent-of-viewport) and refactored `TransactionListScreen` to use it.

## Changes
- feat(responsive): add `.w` and `.h` numeric extensions to `lib/core/ui/responsive.dart`.
- refactor(ui): make `TransactionListScreen` adaptive (expandedHeight, paddings, icon size), remove direct `MediaQuery` and magic numbers.

### Files Updated
- lib/core/ui/responsive.dart
- lib/features/transaction/presentation/pages/transaction_list_screen.dart

## Before → After Examples
- AppBar expandedHeight: `240` → `context.s.rem(28..40)` based on breakpoint.
- Spacing: `SizedBox(height: 24)` → `SizedBox(height: context.s.space2xl)`.
- Padding: `EdgeInsets.all(24)` → `EdgeInsets.all(context.s.space2xl)`.
- Icon size: `size: 56` → `56.ic(context)`.

## Deprecated/Legacy Helpers
- Continue to support `core/responsive/responsive.dart` for DeviceSizeClass access, but prefer `context.s` from `core/ui/responsive.dart` for scalable spacing/typography.

## Next Screens to Refactor (recommended)
- Add/Edit Transaction: replace magic paddings/labels with `context.s` spacing and typographic scales.
- Wallet picker + Add wallet sheet: use `context.s.pageGutter` and `space*` getters.
- Dashboard body: remove hardcoded text sizes and adopt spacing helpers.

## Validation Plan
- fvm flutter analyze
- fvm flutter test (add visual/widget tests incrementally)
- Manual spot-check: phone portrait/landscape, 7" and 11" tablets, desktop window (resizable). Ensure no clipping/overflow.

## Conventional Commits
- feat(responsive): add centralized Responsive numeric extensions `.w()` and `.h()`
- refactor(ui): apply responsive utils to TransactionListScreen
- chore(responsive): recommend migration from MediaQuery/magic numbers to `context.s`

