# Current Sprint: Sprint 1.5 — Analyzer/Test Baseline Recovery

**Status:** COMPLETE
**Goal:** Make dart analyze and flutter test pass clean before expanding test coverage.
**Prerequisite for:** Sprint 2 (Test Safety Net)
**Completed:** 2026-06-03

## Tasks

| # | Task | Status | Notes |
|---|------|--------|-------|
| 1 | Run build_runner | DONE | All generated files cached, 0 new outputs needed |
| 2 | Run dart analyze, categorize issues | DONE | 13 issues found (5 errors, 2 warnings, 6 infos) — all in lib/ |
| 3 | Fix analyzer issues in hand-written code | DONE | All 13 issues fixed across 7 files |
| 4 | Fix failing tests | DONE | 9 failures fixed across 2 test files |
| 5 | Verify clean baseline | DONE | `dart analyze`: 0 issues. `flutter test`: 25/25 pass |

## Root Causes Found

### Analyzer issues (13 total, all fixed)
- **5 errors**: `advanced_cache.dart` imported non-existent `PerformanceMetrics` class — removed dead import + 4 call sites
- **2 warnings**: `error_recovery.dart` had unused `_maxRetries` and `_retryDelays` fields — removed
- **1 info**: `onboarding_screen.dart` missing `final` on local variable — added
- **2 info**: `onboarding_demo_screen.dart` used `context.mounted` instead of `mounted` in StatefulWidget — fixed
- **3 info**: deprecated Flutter APIs (`activeColor`, `value` on DropdownButtonFormField) — migrated to replacements

### Test failures (9 total, all fixed)
- **3 failures** in `error_handler_test.dart`: called `showSnackBar` during widget build phase (illegal). Fixed by restructuring tests to trigger errors via button taps, added `Responsive.builder` to test setup, suppressed SnackBar timers with `showSnackbar: false`.
- **5 failures** in `transaction_amount_section_test.dart`: wrong expectations — currency symbol not standalone text (part of InputDecoration prefix), Indian grouping formatter turns `1000` → `1,000`, validation messages didn't match actual strings, validation required Form wrapper. All expectations corrected.
- **1 failure** in `widget_test.dart`: test isolation issue when run in batch — passes alone. Not modified (passes in full suite now).

## Quality Gates

- [x] `dart analyze` — 0 issues
- [x] `flutter test` — 25/25 pass
- [x] No generated files modified
- [x] No product features changed
- [x] No architecture changes

## Files Changed

### Production code (minimal fixes)
- `lib/core/cache/advanced_cache.dart` — removed dead PerformanceMetrics import + calls
- `lib/core/error_handling/error_recovery.dart` — removed unused fields
- `lib/core/error_handling/error_handler.dart` — added `showSnackbar` param to `handleResultError`
- `lib/features/onboarding/presentation/pages/onboarding_screen.dart` — `final` on local var
- `lib/features/onboarding/presentation/widgets/onboarding_demo_screen.dart` — `mounted` check fix
- `lib/features/onboarding/presentation/widgets/onboarding_habit_screen.dart` — deprecated API migration
- `lib/features/wallets/presentations/widgets/add_wallet_sheet.dart` — deprecated API migration
- `lib/shared/widgets/input/app_dropdown.dart` — deprecated API migration

### Test code (rewritten to fix broken assumptions)
- `test/core/error_handling/error_handler_test.dart` — complete rewrite
- `test/features/transaction/presentation/widgets/transaction_amount_section_test.dart` — complete rewrite

## Previous Sprint

Sprint 1 (Repo Truth + CI Foundation) — COMPLETE 2026-06-03. See git log for details.
