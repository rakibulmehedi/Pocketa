# Production Grade Build Plan

**Date:** 2026-06-03
**Version:** 0.1.0+1
**Goal:** Move Pocketa from working prototype to private-beta-ready product.

---

## Executive Verdict

**Pocketa is a well-architected prototype with critical gaps that block a private beta.** Clean Architecture is solid, Riverpod usage is consistent, and the feature set covers core personal finance flows. However: test coverage is dangerously low (~8% file coverage), community health files are missing (LICENSE, CONTRIBUTING, SECURITY), CI references non-existent directories, README has placeholder URLs, and the codebase has never been validated against a real CI run on the current Flutter version. The app cannot ship to beta testers until these gaps are closed.

**Verdict: NOT beta-ready. 3-5 sprints to private beta.**

---

## Readiness Scorecard

| Dimension | Score | Status | Notes |
|---|---|---|---|
| **Architecture** | 8/10 | PASS | Clean Architecture, feature-first. Minor naming inconsistency (presentations vs presentation). |
| **State Management** | 8/10 | PASS | Riverpod throughout. 20 ConsumerWidgets, 16 StatefulWidgets, 20 setStates (acceptable). |
| **Test Coverage** | 2/10 | FAIL | 11 test files for 137 source files. No repo tests, no use case tests, no dashboard/onboarding tests. No integration tests. |
| **CI/CD** | 4/10 | WARN | 7 workflows exist but: reference non-existent integration_test/, Flutter version mismatch (CI: 3.24.0, local: 3.44.0), never verified green. |
| **Community Health** | 3/10 | FAIL | Missing: LICENSE, CONTRIBUTING.md, SECURITY.md. README has placeholder URLs (your-username). |
| **UX Trust** | 6/10 | WARN | Core flows work. 935-line monster screen (add_edit_transaction). Only 2 TODOs (privacy policy, demo transactions). |
| **Release Readiness** | 2/10 | FAIL | No release process. No signing config. No versioning strategy. No privacy policy. |
| **Documentation** | 4/10 | WARN | CLAUDE.md excellent. CHANGELOG exists. No docs/ directory. No API docs. No user-facing docs. |
| **Security** | 5/10 | WARN | CI security checks exist. No runtime secrets. But no LICENSE = legal risk. No privacy policy. |
| **Performance** | 7/10 | PASS | Performance monitoring built in. Perf tests exist. Responsive system solid. |

**Overall: 4.9/10 -- Prototype, not shippable.**

---

## True Blockers (Must Fix Before Any Beta)

### BLOCKER 1: Test Coverage is Critical Risk
- **11 test files / 137 source files = ~8% file coverage**
- Zero tests for: transaction repository, wallet repository, dashboard, onboarding flow, any use case
- No integration tests (CI references `integration_test/` which doesn't exist)
- **Risk:** Any refactor or feature addition has no safety net. Regressions will ship silently.

### BLOCKER 2: Missing Legal Files
- **No LICENSE file** (README claims MIT but file doesn't exist)
- **No CONTRIBUTING.md** (CHANGELOG references it)
- **No SECURITY.md**
- **Risk:** Legal exposure. Contributors have no license grant. No vulnerability disclosure process.

### BLOCKER 3: CI Has Never Run Green
- Flutter version mismatch: CI pins `3.24.0`, local is `3.44.0`
- CI integration test job references non-existent `integration_test/` directory
- `flutter` not in PATH on dev machine -- tests/analyze unverifiable locally
- **Risk:** False confidence. CI may be broken. No proof the app builds on CI.

### BLOCKER 4: No Release Pipeline
- No signing config (Android keystore, iOS certificates)
- No release workflow that produces distributable artifacts
- No version bump strategy beyond manual pubspec edits
- **Risk:** Cannot distribute to beta testers.

### BLOCKER 5: README Placeholder URLs
- All GitHub URLs use `your-username/pocketa` instead of `rakibulmehedi/Pocketa-V2`
- Support email `support@pocketa.app` -- does this exist?
- **Risk:** Unprofessional. Confuses contributors. Broken links.

---

## Non-Blockers Worth Noting

| Issue | Severity | Notes |
|---|---|---|
| `presentations/` vs `presentation/` naming in categories + wallets | LOW | Inconsistent but functional. Fix in refactor sprint. |
| 935-line `add_edit_transaction_screen.dart` | MEDIUM | Monster file. Works but hard to maintain. Split when touching. |
| Safe-to-Spend feature in observations but not in codebase | INFO | Either removed or never merged. Confirm status. |
| `file_picker` dependency -- is it used? | LOW | Verify or remove. |
| No privacy policy page (TODO in onboarding) | MEDIUM | Required for App Store/Play Store submission. |
| CHANGELOG has future versions (v0.2.0, v0.3.0) as "Planned" | LOW | Aspirational. Remove or move to roadmap. |

---

## Next 5 Sprints

### Sprint 1: Foundation Fix (IMMEDIATE NEXT)
**Goal:** Make CI green, add legal files, fix README.

| Task | Est. Effort | Priority |
|---|---|---|
| Add MIT LICENSE file | 5 min | P0 |
| Add CONTRIBUTING.md | 15 min | P0 |
| Add SECURITY.md | 10 min | P0 |
| Fix README URLs (your-username -> rakibulmehedi/Pocketa-V2) | 10 min | P0 |
| Update CI Flutter version to match project (or pin with FVM) | 15 min | P0 |
| Remove or stub integration_test CI job | 10 min | P0 |
| Verify CI runs green on GitHub Actions | 15 min | P0 |
| Fix flutter PATH on dev machine | 10 min | P0 |

**Exit criteria:** CI green on main. All community health files present. README links work.

---

### Sprint 2: Test Safety Net
**Goal:** Get test coverage to 40%+ on critical paths.

| Task | Est. Effort | Priority |
|---|---|---|
| Transaction repository tests | 1-2 hrs | P0 |
| Wallet repository tests | 1 hr | P0 |
| Transaction use case tests (add, delete, get_summary) | 1-2 hrs | P0 |
| Dashboard screen widget test | 1 hr | P1 |
| Onboarding flow widget test | 1 hr | P1 |
| Category CRUD tests | 30 min | P1 |
| Add coverage threshold to CI (40% minimum) | 15 min | P1 |

**Exit criteria:** `flutter test` passes. Coverage >= 40%. CI enforces threshold.

---

### Sprint 3: Release Pipeline
**Goal:** Be able to produce and distribute a signed build.

| Task | Est. Effort | Priority |
|---|---|---|
| Android keystore setup + signing config | 30 min | P0 |
| iOS certificate + provisioning profile | 30 min | P0 |
| Add Fastlane or manual release workflow | 1-2 hrs | P1 |
| Version bump strategy (release-please or manual) | 30 min | P1 |
| TestFlight / Firebase App Distribution setup | 1 hr | P1 |
| Privacy policy page (even placeholder) | 30 min | P1 |

**Exit criteria:** Can build signed APK/IPA from CI. Can distribute to 5 beta testers.

---

### Sprint 4: UX Polish & Trust
**Goal:** Fix paper cuts that erode user trust.

| Task | Est. Effort | Priority |
|---|---|---|
| Split 935-line add_edit_transaction_screen | 2-3 hrs | P1 |
| Fix `presentations/` -> `presentation/` naming (categories, wallets) | 30 min | P1 |
| Audit and remove unused dependencies (file_picker?) | 15 min | P2 |
| Resolve remaining TODOs (privacy policy, demo transactions) | 1 hr | P1 |
| Empty state screens (no transactions, no wallets) | 1 hr | P1 |
| Error boundary / graceful degradation on all screens | 1 hr | P1 |

**Exit criteria:** No 500+ line screens. Consistent naming. All TODOs resolved or tracked.

---

### Sprint 5: Beta Hardening
**Goal:** Final validation before beta testers get access.

| Task | Est. Effort | Priority |
|---|---|---|
| Manual QA pass on Android + iOS | 2 hrs | P0 |
| Crash reporting setup (Sentry or Firebase Crashlytics) | 1 hr | P0 |
| Analytics events for core flows | 1 hr | P1 |
| Onboarding flow end-to-end validation | 30 min | P0 |
| Data migration safety check (Hive schema) | 30 min | P0 |
| Write beta tester instructions | 30 min | P1 |
| Tag v0.2.0-beta.1 release | 15 min | P0 |

**Exit criteria:** Signed build on TestFlight/Firebase. Crash reporting live. 5 beta testers onboarded.

---

## Immediate Next Sprint Recommendation

**Start Sprint 1: Foundation Fix.**

Rationale: Everything downstream depends on CI being green and legal files existing. Cannot write tests confidently if CI doesn't run. Cannot distribute if LICENSE is missing. This sprint is ~90 minutes of work and unblocks all other sprints.

Sequence:
1. Fix flutter PATH locally
2. Add LICENSE, CONTRIBUTING.md, SECURITY.md
3. Fix README URLs
4. Update CI Flutter version
5. Remove broken integration_test CI job
6. Push and verify CI green

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| CI workflows have never run; may have deeper issues | HIGH | HIGH | Run manually via workflow_dispatch before relying on them |
| Hive schema changes in future may corrupt user data | MEDIUM | CRITICAL | Add migration tests in Sprint 2. Never change existing type IDs. |
| Flutter version drift (local vs CI vs stable) | MEDIUM | MEDIUM | Pin with FVM. Update CI to match. |
| No crash reporting = blind to production issues | HIGH | HIGH | Add Crashlytics in Sprint 5, before beta distribution |
| Single developer bus factor | HIGH | MEDIUM | CONTRIBUTING.md + good docs reduce onboarding cost |
| Supabase sync is stubbed -- users may expect cloud backup | LOW | MEDIUM | Document "offline-only" clearly in beta. Don't promise sync. |

---

## Suggested Commit Message

```
docs: add production grade build plan for private beta readiness

Audit codebase, CI, tests, and community health files.
Identify 5 true blockers: test coverage (8%), missing legal files,
broken CI, no release pipeline, placeholder README URLs.
Define 5-sprint roadmap from prototype to private beta.
```

---

*Generated: 2026-06-03 | Audited against: commit a2ff55e (main)*
