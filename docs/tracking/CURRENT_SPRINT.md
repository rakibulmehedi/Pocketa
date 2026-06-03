# Current Sprint: Sprint 1 — Repo Truth + CI Foundation

**Status:** NOT STARTED
**Goal:** All legal files present, README accurate, CI fully operational, Flutter version pinned.
**Sprint ref:** [PRODUCTION_SPRINT_SEQUENCE.md](../planning/PRODUCTION_SPRINT_SEQUENCE.md#sprint-1-repo-truth--ci-foundation)

## Tasks

| # | ID | Task | Status | Notes |
|---|-----|------|--------|-------|
| 1 | P0-01 | Add MIT LICENSE | TODO | |
| 2 | P0-02 | Add CONTRIBUTING.md | TODO | |
| 3 | P0-03 | Add SECURITY.md | TODO | |
| 4 | P0-04 | Fix README placeholder URLs | TODO | 4 occurrences of `your-username` |
| 5 | P0-09 | Pin Flutter with FVM | TODO | FVM installed at ~/fvm, no .fvmrc |
| 6 | P0-05 | Update CI Flutter version | TODO | All workflows pin 3.24.0, local is 3.44.0 |
| 7 | P0-06 | Remove broken integration_test CI job | TODO | integration_test/ dir doesn't exist |
| 8 | P0-07 | Activate dormant workflows | TODO | ci_guard, deploy, performance, release-please, security |
| 9 | — | Verify CI green on push | TODO | Final gate |

## Quality Gates

- [ ] `grep -c "your-username" README.md` returns 0
- [ ] LICENSE, CONTRIBUTING.md, SECURITY.md exist
- [ ] .fvmrc exists
- [ ] CI Flutter version consistent across all workflows
- [ ] No integration_test reference in ci.yml
- [ ] All 7 workflows appear in GitHub Actions
- [ ] CI passes on push

## Blockers

None identified.

## Notes

- CI workflow (ci.yml) already passes. Main risk is dormant workflows that may fail on activation.
- Release workflow fails due to 403 permission — separate task (P0-08, Sprint 4).
- Flutter local version (3.44.0-pre) is dev channel. CI should use stable. Decide version at execution time.
