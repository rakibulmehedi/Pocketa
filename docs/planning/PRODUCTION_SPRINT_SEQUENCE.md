# Production Sprint Sequence

**Created:** 2026-06-03
**Target:** Private beta ready
**Engineering loop:** Plan -> Execute -> Verify -> Document -> Commit -> Reflect

---

## Sprint 1: Repo Truth + CI Foundation

**Goal:** All legal files present, README accurate, CI fully operational, Flutter version pinned.

### Scope
- Legal files (LICENSE, CONTRIBUTING, SECURITY)
- README URL fixes
- CI workflow activation + version alignment
- FVM pin
- Remove broken integration test CI job

### Non-Goals
- Writing tests (Sprint 2)
- Code changes to lib/ (never in this sprint)
- Release pipeline fixing (Sprint 4)
- Feature work

### Ordered Tasks
1. P0-01: Add MIT LICENSE
2. P0-02: Add CONTRIBUTING.md
3. P0-03: Add SECURITY.md
4. P0-04: Fix README placeholder URLs
5. P0-09: Pin Flutter with FVM (.fvmrc)
6. P0-05: Update CI Flutter version in all workflows
7. P0-06: Remove/fix broken integration_test CI job
8. P0-07: Trigger activation of dormant workflows (push to re-register)
9. Verify: all CI workflows green on push

### Quality Gates
- [ ] `grep -c "your-username" README.md` returns 0
- [ ] `test -f LICENSE && test -f CONTRIBUTING.md && test -f SECURITY.md`
- [ ] `test -f .fvmrc`
- [ ] `grep "FLUTTER_VERSION" .github/workflows/*.yml` shows consistent version
- [ ] `grep "integration_test" .github/workflows/ci.yml` returns empty
- [ ] CI passes on push to main

### Documentation Updates
- Update PRODUCTION_EXECUTION_TODO.md task statuses
- Update CURRENT_SPRINT.md

### Learning Loop Questions
- Did CI workflows auto-register after push, or need manual enablement?
- What Flutter version should CI use — stable channel or pinned?
- Are there hidden CI failures in the 5 dormant workflows?

### Exit Criteria
All P0 repo/CI tasks (P0-01 through P0-09) complete. CI green on main.

---

## Sprint 2: Test Safety Net

**Goal:** Test coverage >= 40% on critical paths. CI enforces threshold.

### Scope
- Transaction repository tests
- Wallet repository tests
- Transaction use case tests
- Dashboard widget test
- Onboarding flow widget test
- CI coverage threshold

### Non-Goals
- Integration tests (need device, separate sprint)
- Performance tests
- UI redesign
- Feature additions

### Ordered Tasks
1. P0-10: Transaction repository unit tests
2. P0-11: Wallet repository unit tests
3. P0-12: Transaction use case tests
4. P1-01: Dashboard widget test
5. P1-02: Onboarding flow widget test
6. P1-03: Add coverage threshold to CI (40%)
7. P1-04: Verify and remove file_picker if unused
8. Verify: `flutter test` all green, coverage >= 40%

### Quality Gates
- [ ] `flutter test` passes with 0 failures
- [ ] `flutter test --coverage` reports >= 40%
- [ ] CI enforces coverage threshold
- [ ] No untested CRUD operation in transaction or wallet repos

### Documentation Updates
- Coverage report snapshot in docs/tracking/
- Update TODO statuses
- LESSONS.md: testing patterns that worked

### Learning Loop Questions
- What was hardest to test? (Hive mocking? Riverpod providers?)
- Which areas have hidden complexity that need more coverage?
- Did any tests reveal actual bugs?

### Exit Criteria
40%+ coverage. CI green with threshold enforced. All P0 test tasks done.

---

## Sprint 3: Real-Device QA Execution

**Goal:** Manual QA on Android + iOS. Fix all crash-level bugs found.

### Scope
- Manual QA checklist creation
- Android real-device testing
- iOS real-device testing
- Fix crash-level bugs discovered
- Fix presentations/ naming inconsistency (P1-05)

### Non-Goals
- Automated E2E tests (future)
- UI polish beyond crash fixes
- Performance optimization
- Feature additions

### Ordered Tasks
1. Create QA checklist covering all user flows
2. P2-05: Manual QA pass Android
3. P2-05: Manual QA pass iOS
4. Fix any crash-level bugs found during QA
5. P1-05: Fix presentations/ -> presentation/ naming
6. P1-06: Resolve onboarding TODOs
7. Document QA results

### Quality Gates
- [ ] All core flows tested: onboarding, add transaction, edit transaction, delete, dashboard view, wallet management, category management
- [ ] Zero crashes on Android
- [ ] Zero crashes on iOS
- [ ] No navigation dead-ends
- [ ] Consistent naming across all features

### Documentation Updates
- QA results in docs/tracking/
- Bug list with severity
- Update TODO statuses

### Learning Loop Questions
- What flows feel clunky but work?
- Where do users get confused?
- Any data corruption scenarios?

### Exit Criteria
Zero crash-level bugs on Android + iOS. All P1 code quality tasks done.

---

## Sprint 4: Beta Release Preparation

**Goal:** Signed builds on TestFlight / Firebase App Distribution. Crash reporting live.

### Scope
- Android signing config
- iOS provisioning + signing
- Crash reporting setup
- Beta distribution pipeline
- Release workflow fix
- Privacy policy (placeholder)

### Non-Goals
- Supabase sync activation
- Feature additions
- Gamification
- Advanced analytics

### Ordered Tasks
1. P1-08: Android signing config
2. P1-09: iOS provisioning + signing
3. P1-07: Setup crash reporting (Sentry or Crashlytics)
4. P0-08: Fix Release workflow permissions
5. P1-10: Beta distribution setup (TestFlight / Firebase)
6. P2-04: Privacy policy page (placeholder)
7. Tag v0.2.0-beta.1
8. Upload to distribution platform
9. Verify: tester can install from link

### Quality Gates
- [ ] `flutter build apk --release` produces signed APK
- [ ] `flutter build ios --release` produces signed IPA (or --no-codesign on CI)
- [ ] Crash reporting captures test crash event
- [ ] Distribution link works for external tester
- [ ] Privacy policy accessible in app

### Documentation Updates
- Release process documented
- Beta tester instructions
- Update TODO statuses

### Learning Loop Questions
- What was the signing pain point?
- Is release-please the right versioning strategy?
- Do we need separate staging/production flavors?

### Exit Criteria
Signed build on TestFlight or Firebase. 1+ external tester can install. Crash reporting verified.

---

## Sprint 5: Private Beta Feedback Loop

**Goal:** Onboard 5 beta testers. Collect feedback. Fix critical issues from real usage.

### Scope
- Beta tester onboarding
- Feedback collection system
- Critical bug fixes from tester reports
- Analytics event setup for core flows
- Hive schema migration safety check

### Non-Goals
- New features based on feedback (goes to backlog)
- Supabase activation
- Major UI overhaul
- Public release

### Ordered Tasks
1. Write beta tester instructions document
2. Onboard 5 beta testers
3. Setup feedback collection (GitHub Issues template or form)
4. Monitor crash reports for 1 week
5. Triage and fix critical bugs
6. Add analytics events for core flows
7. Hive schema migration safety audit
8. P2-01: Split monster screen if testers report issues
9. P2-02: Clean CHANGELOG

### Quality Gates
- [ ] 5 testers installed and used app
- [ ] < 1% crash rate over 7 days
- [ ] All critical feedback triaged
- [ ] No data corruption reports
- [ ] Analytics events firing for: onboarding complete, transaction added, transaction deleted

### Documentation Updates
- Beta feedback summary
- Triage decisions
- LESSONS.md: what real users found vs what we expected

### Learning Loop Questions
- What surprised us about real usage?
- What assumptions were wrong?
- What's the #1 feature request?
- Is the app stable enough for wider beta?

### Exit Criteria
5 testers active for 7+ days. < 1% crash rate. Critical bugs fixed. Decision made on wider beta timeline.

---

## Cross-Sprint Engineering Loop

After every sprint, answer:

1. **What did we assume?** — List assumptions going in.
2. **What did repo reality show?** — What was different from expectations.
3. **What broke?** — Unexpected failures or regressions.
4. **What did tests prove?** — Bugs caught, confidence gained.
5. **What should future agents remember?** — Save to LESSONS.md.

---

*Created: 2026-06-03 | Audited against: commit a2ff55e (main)*
