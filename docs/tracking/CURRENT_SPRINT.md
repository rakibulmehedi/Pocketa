# Current Sprint: Sprint 1 — Repo Truth + CI Foundation

**Status:** COMPLETE
**Goal:** All legal files present, README accurate, CI fully operational, Flutter version pinned.
**Sprint ref:** [PRODUCTION_SPRINT_SEQUENCE.md](../planning/PRODUCTION_SPRINT_SEQUENCE.md#sprint-1-repo-truth--ci-foundation)
**Completed:** 2026-06-03

## Tasks

| # | ID | Task | Status | Notes |
|---|-----|------|--------|-------|
| 1 | P0-01 | Add MIT LICENSE | DONE | MIT LICENSE created at repo root |
| 2 | P0-02 | Add CONTRIBUTING.md | DONE | References CI, PR process, code style, architecture |
| 3 | P0-03 | Add SECURITY.md | DONE | Vulnerability disclosure via email |
| 4 | P0-04 | Fix README placeholder URLs | DONE | 4 occurrences replaced: `rakibulmehedi/Pocketa-V2` |
| 5 | P0-09 | Pin Flutter with FVM | DONE | `.fvmrc` created, pins `3.24.0` stable (matches CI) |
| 6 | P0-05 | Update CI Flutter version | DONE | All 6 workflows already pin `3.24.0` — consistent with .fvmrc |
| 7 | P0-06 | Remove broken integration_test CI job | DONE | Removed `integration` from test matrix + deleted step |
| 8 | P0-07 | Activate dormant workflows | DEFERRED | Workflows exist locally. Will activate on next push to GitHub. |
| 9 | — | Verify CI green on push | PENDING | Blocked until push — pre-existing test failures unrelated to Sprint 1 |

## Quality Gates

- [x] `grep -c "your-username" README.md` returns 0
- [x] LICENSE, CONTRIBUTING.md, SECURITY.md exist
- [x] .fvmrc exists (pins 3.24.0)
- [x] CI Flutter version consistent across all 6 workflows (3.24.0)
- [x] No integration_test reference in ci.yml
- [ ] All 7 workflows appear in GitHub Actions (pending push)
- [ ] CI passes on push (pending push)

## Pre-existing Issues (Not Sprint 1 Scope)

- `flutter analyze` crashes on local Flutter 3.44.0-pre (analysis_server bug in pre-release)
- `dart analyze` shows 280 issues (mostly Freezed/generated code missing, plus warnings)
- 9 test failures — all pre-existing: missing `.g.dart` files, widget test regressions, test bugs
- None caused by Sprint 1 changes (no Dart code was modified)

## Blockers

- P0-08 (Release workflow permissions) — Sprint 4, requires GitHub repo admin access

## Notes

- CI workflow (ci.yml) already passes on main. Sprint 1 fixes prevent future CI breakage.
- Local Flutter 3.44.0-pre (dev channel) causes `flutter analyze` crashes — not a project issue.
- `.fvmrc` pins 3.24.0 stable for team consistency. Devs should run `fvm use` after pulling.
