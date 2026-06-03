# Production Execution TODO

**Created:** 2026-06-03
**Audited against:** commit a2ff55e (main)
**Method:** Every claim verified against repo reality before inclusion.

---

## Verified Tasks

### P0 — True Blockers (Must complete before any beta distribution)

| ID | Task | Owner | Status | Acceptance Criteria | Verification | Expected Commit |
|----|------|-------|--------|---------------------|--------------|-----------------|
| P0-01 | Add MIT LICENSE file | Agent | TODO | LICENSE file exists at repo root, matches MIT template | `test -f LICENSE && head -1 LICENSE` | `docs: add MIT LICENSE file` |
| P0-02 | Add CONTRIBUTING.md | Agent | TODO | File exists, references CI, PR process, code style | `test -f CONTRIBUTING.md` | `docs: add CONTRIBUTING.md` |
| P0-03 | Add SECURITY.md | Agent | TODO | File exists, has vulnerability disclosure process | `test -f SECURITY.md` | `docs: add SECURITY.md` |
| P0-04 | Fix README placeholder URLs | Agent | TODO | Zero occurrences of `your-username` in README.md | `grep -c "your-username" README.md` returns 0 | `docs: fix README URLs to point to rakibulmehedi/Pocketa-V2` |
| P0-05 | Update CI Flutter version | Agent | TODO | All workflow FLUTTER_VERSION values match project SDK constraint | `grep "FLUTTER_VERSION" .github/workflows/*.yml` shows consistent version | `ci: update Flutter version to match project SDK` |
| P0-06 | Fix or remove broken integration_test CI job | Agent | TODO | CI test matrix doesn't reference non-existent integration_test/ | `grep "integration_test" .github/workflows/ci.yml` returns empty | `ci: remove integration test job (no integration tests yet)` |
| P0-07 | Activate dormant GitHub workflows | Agent | TODO | ci_guard, deploy, performance, release-please, security appear in `gh api` workflow list | `gh api repos/rakibulmehedi/Pocketa-V2/actions/workflows` shows all | `ci: trigger workflow registration for dormant pipelines` |
| P0-08 | Fix Release workflow permissions | Founder | TODO | Release workflow has `contents: write` permission and runs clean | `gh run list --workflow=release-please.yml` shows success | `ci: fix release workflow permissions` |
| P0-09 | Pin Flutter version with FVM | Agent | TODO | `.fvmrc` exists, CI uses same version | `test -f .fvmrc && cat .fvmrc` | `chore: pin Flutter version with FVM` |
| P0-10 | Transaction repository unit tests | Agent | TODO | Tests exist for all CRUD operations in transaction repo | `flutter test test/features/transaction/data/` passes | `test: add transaction repository unit tests` |
| P0-11 | Wallet repository unit tests | Agent | TODO | Tests exist for wallet CRUD | `flutter test test/features/wallets/` passes | `test: add wallet repository unit tests` |
| P0-12 | Transaction use case unit tests | Agent | TODO | Tests for add, delete, get_summary use cases | `flutter test test/features/transaction/domain/` passes | `test: add transaction use case tests` |

### P1 — Important (Should complete before beta, not hard blockers)

| ID | Task | Owner | Status | Acceptance Criteria | Verification | Expected Commit |
|----|------|-------|--------|---------------------|--------------|-----------------|
| P1-01 | Dashboard widget test | Agent | TODO | At least 3 test cases covering dashboard rendering | `flutter test test/features/dashboard/` passes | `test: add dashboard widget tests` |
| P1-02 | Onboarding flow widget test | Agent | TODO | Test covers full onboarding flow with navigation | `flutter test test/features/onboarding/` passes | `test: add onboarding flow tests` |
| P1-03 | Add coverage threshold to CI | Agent | TODO | CI fails if coverage < 40% | `grep "coverage" .github/workflows/ci.yml` shows threshold | `ci: enforce 40% minimum test coverage` |
| P1-04 | Remove unused file_picker dependency | Agent | TODO | No imports of file_picker in lib/; removed from pubspec | `grep "file_picker" pubspec.yaml` returns empty | `chore: remove unused file_picker dependency` |
| P1-05 | Fix presentations/ naming inconsistency | Agent | TODO | categories and wallets use `presentation/` not `presentations/` | `find lib/features -name "presentations" -type d` returns empty | `refactor: fix presentations/ to presentation/ naming` |
| P1-06 | Resolve onboarding TODOs | Agent | TODO | No TODO comments in onboarding feature | `grep "TODO" lib/features/onboarding/ -r` returns empty | `fix: resolve onboarding TODOs` |
| P1-07 | Setup crash reporting (Sentry/Crashlytics) | Founder | TODO | Crash reporting SDK integrated, test crash captured | Manual verification in dashboard | `feat: add crash reporting with Sentry` |
| P1-08 | Android signing config | Founder | TODO | Release build produces signed APK | `flutter build apk --release` succeeds | `chore: configure Android release signing` |
| P1-09 | iOS provisioning + signing | Founder | TODO | Release build produces signed IPA | `flutter build ios --release --no-codesign` succeeds | `chore: configure iOS release signing` |
| P1-10 | Beta distribution setup | Founder | TODO | TestFlight or Firebase App Distribution configured | Manual: upload succeeds, tester gets install link | `ci: add beta distribution workflow` |

### P2 — Nice to Have (Polish, not blocking beta)

| ID | Task | Owner | Status | Acceptance Criteria | Verification | Expected Commit |
|----|------|-------|--------|---------------------|--------------|-----------------|
| P2-01 | Split 935-line add_edit_transaction_screen | Agent | TODO | No single file > 500 lines in presentation/ | `wc -l lib/features/transaction/presentation/pages/*.dart` all < 500 | `refactor: split add_edit_transaction_screen` |
| P2-02 | Clean up CHANGELOG planned versions | Agent | TODO | No "Planned" sections in CHANGELOG | `grep "Planned" CHANGELOG.md` returns empty | `docs: clean up CHANGELOG` |
| P2-03 | Empty state screens | Agent | TODO | Dashboard and transaction list show empty state UI | Manual QA | `feat: add empty state screens` |
| P2-04 | Privacy policy page | Founder | TODO | Privacy policy accessible from onboarding + settings | Manual QA | `feat: add privacy policy page` |
| P2-05 | Manual QA pass Android + iOS | Manual QA | TODO | All core flows tested on real devices, no crashes | QA checklist completed | N/A |

---

## Stale / Rejected Claims from Build Plan

| Claim | Status | Why |
|-------|--------|-----|
| "CI has never run green" | **STALE** | CI workflow (ci.yml) passes on main consistently. Only legacy Release workflow fails. |
| "file_picker unused" | **UNVERIFIED** | No direct imports found, but need to check if used transitively or in generated code. Moved to P1 pending verification. |
| "Safe-to-Spend feature missing" | **NOT A TASK** | Feature was from prior session work, not in current codebase. Not in scope for beta. |
| "docs/ directory missing" | **STALE** | Created docs/planning/ during this planning session. |
| "CI references scripts that don't exist" | **NEEDS VERIFY** | `scripts/perf_checks.sh` exists. CI guard uses it. Likely works. |
| "No release pipeline" | **PARTIALLY STALE** | release-please.yml exists but not registered. deploy.yml exists but dormant. Issue is workflow activation, not absence. |

---

*Updated: 2026-06-03 | Next review: after Sprint 1 completion*
