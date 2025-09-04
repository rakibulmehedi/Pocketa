# POCKETA Backlog

## Now (1–2 days)
- [ ] Wire Supabase Auth skeleton — Create auth remote with signIn/signUp/signOut; map errors to Failures; Est: M; Owner: @me; Files: lib/core/auth/*, lib/features/auth/*; Acceptance: unit tests for happy/error paths.
- [ ] Implement SyncRemote (Supabase) — Replace stub with real sender; add retry/backoff; Est: M; Owner: @me; Files: lib/core/sync/*; Acceptance: integration test flushing queue.
- [ ] Split Add/Edit Tx screen — Extract sub-widgets for type/amount/details/transfer/tags; Est: M; Owner: @me; Files: lib/features/transaction/presentation/pages/add_edit_transaction_screen.dart; Acceptance: widget tests still pass.
- [ ] Add route guard tests — Onboarding redirect and basic route table; Est: S; Owner: @me; Files: lib/core/routing/router.dart, test/*; Acceptance: tests verifying redirect.

## Next (1 week)
- [ ] Widget tests for Transactions and Wallets — Cover empty/loading/error states and interactions; Est: M; Owner: @me; Files: test/features/**; Acceptance: >12 tests added.
- [ ] Golden tests for key widgets — App bars, summary row, section cards; Est: S; Owner: @me; Files: test/goldens/**; Acceptance: images generated and reviewed.
- [ ] Tighten lints — Add stricter rules (public_member_api_docs opt-in, avoid_dynamic_calls); Est: S; Owner: @me; Files: analysis_options.yaml; Acceptance: analyze passes.
- [ ] Number formatting (Indic) — Utility for Bangla digits and Indian grouping; Est: S; Owner: @me; Files: lib/core/utils/format.dart; Acceptance: unit tests for formats.

## Later (2–4 weeks)
- [ ] Budgets feature — Entities, repo, UI; Est: L; Owner: @me; Files: lib/features/budget/**; Acceptance: create/edit budget, warnings when exceeded.
- [ ] CSV export — Generate CSV and share; Est: M; Owner: @me; Files: lib/features/export/**; Acceptance: deterministic CSV with tests.
- [ ] SMS parsing (opt-in) — Parse bank/SMS (ignore OTP); Est: L; Owner: @me; Files: lib/features/sms/**; Acceptance: parser fakes + tests.
- [ ] CI/CD — GitHub Actions for format/analyze/test + l10n; Est: S; Owner: @me; Files: .github/workflows/**; Acceptance: green pipeline.
