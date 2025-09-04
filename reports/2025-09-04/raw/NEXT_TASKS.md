# NEXT TASKS (Automation-friendly)

## NOW (1–2 days)
- [ ] Supabase Auth skeleton — Add supabase_flutter, auth remote (signInEmail, signUpEmail, signOut), onAuthState stream; map errors → Failure; Est: M; Files: lib/core/auth/**, lib/features/auth/**; Acceptance: unit tests for happy/error paths.
- [ ] Implement SyncRemote (Supabase) — Replace stub in core/sync; add retry/backoff; wire queue flush on app foreground; Est: M; Files: lib/core/sync/**; Acceptance: queued events reach server in test env.
- [ ] Split Add/Edit Txn screen — Extract sub-widgets (type, amount, details, transfer, tags) and add widget tests; Est: M; Files: lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart; Acceptance: behavior unchanged, tests pass.
- [ ] Router guard tests — Verify onboarding redirect using widget tests; Est: S; Files: lib/core/routing/router.dart, test/**; Acceptance: redirect toggles based on onboarding_done flag.

## NEXT (1 week)
- [ ] Widget tests — Transactions list states, wallet picker empty/error, category chips; Est: M; Files: test/features/**; Acceptance: 12+ tests.
- [ ] Golden tests — SummaryRow, CustomAppBar variants; Est: S; Files: test/goldens/**; Acceptance: stable golden images.
- [ ] Indic number formatting — Utility + tests; Est: S; Files: lib/core/utils/format.dart; Acceptance: bn digits + Indian grouping.
- [ ] Tighten lints & CI — Add more rules; GitHub Actions for format/analyze/test and gen-l10n; Est: S; Files: analysis_options.yaml, .github/workflows/**; Acceptance: green pipeline.

## LATER (2–4 weeks)
- [ ] Budgets feature — Entities, repositories, UI and analytics; Est: L; Files: lib/features/budget/**; Acceptance: create/edit, limit alerts.
- [ ] CSV export — Generate + share; Est: M; Files: lib/features/export/**; Acceptance: deterministic CSV + tests.
- [ ] SMS parsing (opt-in) — Bank SMS parser (ignore OTP), fakes + tests; Est: L; Files: lib/features/sms/**; Acceptance: deterministic parse cases.
