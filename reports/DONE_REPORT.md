# DONE INVENTORY — POCKETA

## 1. Executive Summary
POCKETA follows a feature-first Flutter architecture with Riverpod, GoRouter, and Hive for offline-first data. Transactions, Wallets, and Categories are implemented end-to-end (entities, repos, presentation). i18n (bn/en) is present and now consistently wired across UI. A simple analytics provider with batching exists, and a persisted background sync queue is in place (stub remote). Quality is generally good with clear layering and utilities. Top gaps: (1) Supabase auth + RLS remote is missing, (2) Sync remote is stubbed (no network send), (3) Tests are minimal for widgets and routing.

Confidence: High for what’s present (evidence below). Unknowns: CSV export, SMS parsing.

## 2. DONE INVENTORY (Table)
| Area | Status | Proof (file:line, commit) | Notes |
|------|--------|---------------------------|-------|
| Architecture: Feature-first | Done | lib/features/* (module folders); fc829ac (2025-08-30) | Clear separation domain/data/presentation |
| Router + Onboarding redirect | Done | lib/core/routing/router.dart:10-16; 6a02f0e (2025-09-02) | Redirect to /welcome until onboarding_done |
| Transactions (CRUD + UI) | Done | lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart:760-827; 4c60f1c | Full add/edit, validation, analytics, sync enqueue |
| Transaction repository | Done | lib/features/transaction/data/transaction_repo_impl.dart; bf02781 | Hive-backed repo with queries/aggregates |
| Wallets | Done | lib/features/wallets/presentations/widgets/wallet_picker_button.dart; eae0981 | Picker + Add wallet sheet |
| Categories | Done | lib/features/categories/presentations/widgets/category_chips_picker.dart; cdfb11f | Chips picker + Add dialog |
| i18n (ARB bn/en) | Done | lib/l10n/app_en.arb; lib/l10n/app_bn.arb; a9e90c2 | gen-l10n present; extensive keys |
| Sealed Failures | Done | lib/core/errors/failure.dart:1-23; 6a02f0e | Cache/Database/NetworkFailure |
| Exception→Failure mapper | Done | lib/core/errors/exception_mapper.dart:4-16; 6a02f0e | Standardized mapping |
| Offline DB bootstrap | Done | lib/core/db/hive_bootstrap.dart:11-31,33-47; 6a02f0e | Safe open + compaction helper |
| Analytics provider (batched) | Done | lib/core/analytics/analytics_service.dart:6-12,29-69; 6a02f0e | Batching wrapper + provider |
| Background sync queue | Partial | lib/core/sync/sync_queue.dart:24-38,83-107; 6a02f0e | Persisted queue; remote is stub |
| Theming | Done | lib/core/theme/app_theme.dart; a9e90c2 | Light/dark M3 themes |
| Testing (unit) | Partial | test/core/**, test/features/**; 6a02f0e | Analytics, mapper, sync, providers |
| Budgeting | Missing | – | Placeholder only |
| CSV export | Unknown | – | Not found in repo |
| SMS parsing | Missing | – | Not found in repo |
| Supabase Auth/RLS | Missing | – | No auth code/SQL present |

## 3. Evidence Ledger (snippets)
- Router redirect — lib/core/routing/router.dart:10-16
```
redirect: (context, state) {
  final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
  final onboarded = prefs.get('onboarding_done') == true;
  final atWelcome = state.uri.path == '/welcome';
  if (!onboarded && !atWelcome) return '/welcome';
  if (onboarded && atWelcome) return '/';
  return null;
}
```
- Sealed Failures — lib/core/errors/failure.dart:1-7
```
sealed class Failure {
  final String message;
  final Object? cause;
  const Failure(this.message, {this.cause});
  @override
  String toString() => '${runtimeType.toString()}($message)';
}
```
- Analytics batching provider — lib/core/analytics/analytics_service.dart:6-12,29-44
```
final analyticsProvider = Provider<AnalyticsService>((ref) {
  final sink = DebugAnalyticsService();
  final batched = BatchingAnalyticsService(sink);
  ref.onDispose(batched.dispose);
  return batched;
});
...
Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
  _buffer.add({'name': name, 'params': params ?? <String, dynamic>{}});
  if (_buffer.length >= maxItems) await _flush();
  _timer ??= Timer(maxDelay, () { _flush(); });
}
```
- Sync queue enqueue + flush — lib/core/sync/sync_queue.dart:46-55,83-95
```
void enqueue(String type, Map<String, dynamic> payload) {
  final event = { 'type': type, 'payload': payload, 'ts': DateTime.now().toUtc().toIso8601String() };
  _buffer.add(event);
  _persist();
  _schedule();
}
...
Future<void> flush() async {
  _timer?.cancel();
  if (_buffer.isEmpty) return;
  final batch = List<Map<String, dynamic>>.from(_buffer);
  try { await remote.sendEvents(batch); _buffer.clear(); _persist(); } catch (_) {}
}
```

## 4. Quality & Risks
- Perf: Large UI file `add_edit_transaction_screen.dart` (~880 LOC) — split into sub-widgets; compact Hive at thresholds; Riverpod `.select()` reduces rebuilds.
- Security: No secrets detected; Android manifests include only INTERNET in debug/profile (OK). Supabase RLS is missing.
- i18n: ARB bn/en complete for screens; no hardcoded UI strings remain; add Indic number formatting utility (missing).
- Testing: Solid unit test seeds (analytics, mapper, sync); need widget and router tests; goldens possible for summary/app bars.
- DX: Lints basic; add CI with `flutter analyze`/`flutter test` & `flutter gen-l10n`.

## 5. Verification Plan (UNKNOWNs)
- CSV export: `rg -n "CSV|export" lib`; if found, add tests. Otherwise task.
- SMS parsing: `rg -n "sms|otp|regex" lib`; likely missing.
- Supabase: integrate `supabase_flutter` and add auth flows; verify with integration test.
- Commands (use FVM if configured): `fvm flutter pub get`, `fvm flutter gen-l10n`, `fvm flutter analyze`, `fvm flutter test --coverage`.

