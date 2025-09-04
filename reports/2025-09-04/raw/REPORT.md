# POCKETA Codebase Report

## 1) Executive Summary
- Solid feature-first structure with clear domain/data/presentation split for Transactions, Wallets, Categories. Router uses GoRouter with onboarding redirect.
- Offline-first via Hive is implemented with safe-open and basic compaction; repository logic is clean and deterministic.
- i18n is robust (en/bn) and we removed remaining hardcoded strings across presentation, improving UX consistency.
- Added AnalyticsService with batching and a persisted SyncQueue stub to prepare for remote sync without blocking UI.
- Gaps: No Supabase auth or remote RLS wiring yet; background sync remote is a stub; tests are minimal; some large widgets could be segmented.

Top 5 fixes (done/next):
1. Localize remaining strings and add missing ARB keys (DONE).
2. Add batching analytics provider and wire critical events (DONE).
3. Introduce persisted non-blocking sync queue for tx upsert/delete (DONE with stub remote).
4. Riverpod micro-optimizations in category providers to reduce rebuilds (DONE).
5. Add focused tests for analytics, exception mapping, sync queue; plan to expand widget tests (PARTIAL).

## 2) Architecture Map
See `reports/ARCH_MAP.txt` for the ASCII diagram.

### Layered breakdown
- core: analytics, errors (sealed Failures), result, routing, sync, db bootstrap, theme, responsive.
- features:
  - transaction: entities/usecases/repos, Hive repo impl, pages and viewmodels.
  - wallets: same pattern; picker and add sheet.
  - categories: same pattern; chips picker and create dialog.
  - onboarding + dashboard: presentation only.
- shared: common widgets (app bars, buttons, section cards, inputs).

## 3) Feature Coverage Matrix
| Capability             | Status   | Notes | Key files |
|------------------------|----------|-------|-----------|
| Auth (Supabase)        | Missing  | No auth SDK/flows present | N/A |
| Onboarding             | Partial  | Welcome screen + router redirect | lib/features/onboarding/presentation/pages/welcome_screen.dart, lib/core/routing/router.dart |
| Add/Edit Transaction   | Done     | Full form, transfer modes, tags | lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart |
| Wallets                | Done     | Hive + picker + add sheet | lib/features/wallets/* |
| Categories             | Done     | Chips + add dialog | lib/features/categories/* |
| Budgeting              | Missing  | Placeholder only | lib/features/dashboard/presentation/pages/dashboard_screen.dart |
| CSV export             | Unknown  | Not found | N/A |
| Analytics              | Partial  | Batching + events for key flows | lib/core/analytics/analytics_service.dart |
| SMS parsing            | Missing  | Not found | N/A |
| i18n (bn/en)           | Done     | ARB + codegen | lib/l10n/* |
| Theming                | Done     | Light/dark themes | lib/core/theme/app_theme.dart |
| Offline-first sync     | Partial  | Queue + stub remote | lib/core/sync/* |

## 4) Findings
### Architecture & Layering
- Feature-first structure respected; domain/data/presentation separation is consistent.
- Sealed Failures added in `lib/core/errors/failure.dart` and mapper in `lib/core/errors/exception_mapper.dart`.

### Riverpod
- Providers used appropriately. Optimized category lookups using `select()` to avoid broad rebuilds (`category_providers.dart`).
- Consider more `.autoDispose` where applicable for screens.

### Navigation (GoRouter)
- Onboarding redirect added using a Hive prefs flag (`onboarding_done`). No deep-link guard tests.

### Data & Offline-first
- Hive boxes are safely opened with basic corruption recovery and optional compaction threshold (`hive_bootstrap.dart`).
- Transaction repository implements deterministic calculations and transfer semantics.
- Sync queue persists events and flushes with a timer; remote is a stub.

### Supabase Auth & Security
- Missing auth, no RLS policies/sql present. No secrets detected.

### Lint & Formatting
- `analysis_options.yaml` includes `flutter_lints` + a few rules. Opportunity to tighten.

### i18n
- All presentation strings now use ARB keys. Added keys for menus, hints, and section labels.
- ARB files have bn/en coverage; pluralization already used in other keys.

### Analytics
- Single analytics provider with batching; core events wired: `onb_step_viewed`, `onb_continue_clicked`, `dashboard_viewed`, `txn_added/edited/deleted`.

### Performance
- Large files: add_edit_transaction_screen.dart (~880 LOC) could be split for readability/testability.
- Rebuild hotspots reduced via `.select()`.

### Testing
- Added unit tests: analytics batching, exception mapper, sync queue, i18n key access, category provider selection, hive helper.
- Widget/golden coverage is still low; plan below.

## 5) Risk Register
| Risk | Severity | Likelihood | Impact | Mitigation |
|------|----------|------------|--------|------------|
| No Supabase auth/RLS | High | High | Security and feature gap | Implement auth flows + map errors to Failures; add RLS-aware service layer |
| Sync remote is stub | High | High | Data not syncing | Implement Supabase remote sender with retries/backoff |
| Large transaction screen | Med | Med | Slower iteration, brittle tests | Split into sub-widgets, add widget tests |
| i18n regressions | Low | Med | UX inconsistency | Keep `flutter gen-l10n` in CI; add key smoke test |
| Hive corruption edge cases | Low | Low | Data loss | Keep safe-open & backup/export options |

## 6) Verification Plan
- Add analyzer and test runs in CI; ensure `flutter gen-l10n` step executed.
- Add integration test for onboarding redirect and transaction add/edit flow using widget tests.
- Implement a fake Supabase remote and verify queue flushes on demand.

## 7) Command Outputs
Attempted local toolchain queries:

```
$ dart --version
bash: dart: command not found

$ flutter --version
bash: flutter: command not found
```

Run locally on a Flutter workstation:
- flutter pub get
- flutter gen-l10n
- flutter analyze
- flutter test

*** End of Report ***
