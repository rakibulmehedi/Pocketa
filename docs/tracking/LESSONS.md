# Lessons Learned

**Purpose:** Capture non-obvious findings from each sprint so future agents don't repeat mistakes.

---

## Pre-Sprint Planning (2026-06-03)

### Lesson 1: Verify plan claims before executing
The initial build plan claimed "CI has never run green." Repo reality: CI (ci.yml) passes consistently on main. Only the legacy Release workflow fails. Blind execution would have wasted time "fixing" working CI.

**Rule:** Always `gh run list` before assuming CI state.

### Lesson 2: GitHub workflow registration is not automatic
5 workflow files exist in `.github/workflows/` but only 1 (ci.yml) is registered as active on GitHub. The others (ci_guard, deploy, performance, release-please, security) exist in the repo but GitHub's Actions system doesn't list them. This may be because they were added in commits that were pushed but GitHub hasn't scanned them, or they need a triggering event.

**Rule:** After adding workflows, verify with `gh api repos/{owner}/{repo}/actions/workflows` that they appear.

### Lesson 3: FVM is installed but project isn't pinned
FVM binary exists at `~/fvm/versions/stable/bin/flutter` but the project has no `.fvmrc` or `fvm_config.json`. This means any collaborator or CI runner uses whatever Flutter version they have. Local version is 3.44.0-pre (dev channel), CI pins 3.24.0 (old stable).

**Rule:** Pin with `.fvmrc` in Sprint 1. Decide: use current stable or match CI.

### Lesson 4: Legacy workflows linger on GitHub
`release.yml` (workflow ID 163430901) runs on GitHub but the file doesn't exist locally. It was likely from an old commit or was deleted locally but the workflow definition cached on GitHub. It fails with 403 permissions and a stale submodule reference.

**Rule:** Check `gh api` for ghost workflows when debugging CI failures.

### Lesson 5: Naming inconsistency is real but harmless
`categories/presentations/` and `wallets/presentations/` use plural form while `transaction/presentation/` and others use singular. Dart imports work fine either way. Fix for consistency but don't treat as blocker.

---

*Add new lessons after each sprint completion.*
