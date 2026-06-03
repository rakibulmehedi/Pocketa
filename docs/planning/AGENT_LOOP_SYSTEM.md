# Agent Loop System

**Purpose:** Codify how AI agents operate in this project. Every autonomous engineering session follows this system. No exceptions.

---

## Core Loop

```
OBSERVE → ORIENT → PLAN → EXECUTE → VERIFY → DOCUMENT → COMMIT → REFLECT
```

Every task — feature, bugfix, refactor, test — runs through all 8 phases. Skipping phases causes drift, regressions, and wasted context.

---

## Phase Definitions

### 1. OBSERVE — What is true right now?

Read before writing. Never assume state from memory or prior sessions.

```
Required checks:
- git status / git log (what changed recently?)
- Read files you'll touch (what exists?)
- Run tests (what passes?)
- Check CI (what's green/red?)
- Read tracking docs (what's the current sprint?)
```

**Anti-pattern:** Starting implementation from a plan without verifying the plan still matches repo reality.

**Gate:** Can you state 3 facts about current repo state relevant to your task? If no, keep observing.

### 2. ORIENT — What does this mean?

Connect observations to the task. Identify gaps between current state and goal state.

```
Questions:
- What's the delta between current and desired state?
- What assumptions am I making?
- Are there constraints I haven't checked? (Hive type IDs, existing tests, CI requirements)
- Has someone already partially done this work?
```

**Anti-pattern:** Treating every task as greenfield when partial work exists.

**Gate:** Can you describe the delta in one sentence? If no, keep orienting.

### 3. PLAN — What will I do, in what order?

State steps with verifiable success criteria. Short plans, not essays.

```
Format:
1. [action] → verify: [check]
2. [action] → verify: [check]
3. [action] → verify: [check]
```

**Rules:**
- Max 7 steps per plan. If more, break into sub-tasks.
- Each step must have a verification command or check.
- State what you will NOT touch (blast radius boundary).
- If plan changes mid-execution, update it before continuing.

**Anti-pattern:** Plans with no verification criteria. "Implement the feature" is not a plan.

**Gate:** Does every step have a verify? If no, keep planning.

### 4. EXECUTE — Do the work

Write code, edit configs, create files. One logical change at a time.

**Rules:**
- Touch only what the plan says. Surgical changes.
- Match existing code style. Don't improve neighbors.
- Run the verify check after each step before moving to the next.
- If a step fails verification, stop and re-orient. Don't push through.
- If you discover something unexpected, add it to observations, don't silently absorb it.

**Anti-pattern:** Executing the whole plan then verifying at the end. Verify per step.

**Gate:** Did each step pass its verification? If no, fix before proceeding.

### 5. VERIFY — Does it work?

Run the full verification suite, not just the step-level checks.

```
Required:
- flutter analyze (zero errors, zero warnings on touched files)
- flutter test (all pass, no regressions)
- Manual check: does the change do what was asked?
- Boundary check: did you touch anything outside plan scope?
```

**Anti-pattern:** "Tests pass" when you didn't run them because flutter isn't in PATH. Verification means actually running the command.

**Gate:** All verification commands return clean. If not, go back to EXECUTE.

### 6. DOCUMENT — Record what happened

Update tracking docs. Not prose — structured data.

```
Update:
- docs/tracking/CURRENT_SPRINT.md — mark tasks done
- docs/tracking/TASKS.md — update counts
- docs/planning/PRODUCTION_EXECUTION_TODO.md — update status
- CHANGELOG.md — if user-facing change
```

**Anti-pattern:** Skipping docs because "it's obvious from the diff." Future agents don't see your diff.

**Gate:** Can a new agent session understand what was done by reading tracking docs alone? If no, keep documenting.

### 7. COMMIT — Save the work

Follow project commit conventions. One logical change per commit.

```
Format:
<type>: <description>

<body explaining why, not what>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

**Rules:**
- Never commit failing tests.
- Never commit with `--no-verify`.
- Stage specific files, not `git add .`.
- Don't push unless explicitly asked.

**Gate:** `git status` shows clean working tree after commit.

### 8. REFLECT — What did we learn?

Answer these 5 questions after every non-trivial task:

1. **What did we assume?** — List assumptions going in.
2. **What did repo reality show?** — What was different from expectations.
3. **What broke?** — Unexpected failures or regressions.
4. **What did tests prove?** — Bugs caught, confidence gained.
5. **What should future agents remember?** — Add to `docs/tracking/LESSONS.md`.

**Anti-pattern:** Skipping reflection because the task succeeded. Success teaches too.

**Gate:** At least one lesson captured if the task took > 15 minutes.

---

## Loop Variants

### Quick Fix Loop (< 5 min tasks)
```
OBSERVE → EXECUTE → VERIFY → COMMIT
```
Skip ORIENT/PLAN/DOCUMENT/REFLECT for trivial changes (typo fixes, import cleanup, single-line bugs with obvious fix). Still verify.

### Research Loop (no code changes)
```
OBSERVE → ORIENT → DOCUMENT
```
For investigation tasks: reading code, auditing state, answering questions. Output is documentation or a plan, not code.

### Sprint Loop (multi-task sessions)
```
For each task in sprint:
    OBSERVE → ORIENT → PLAN → EXECUTE → VERIFY → DOCUMENT → COMMIT
End of sprint:
    REFLECT (sprint-level)
```
Run full loop per task. Sprint-level reflection at the end.

---

## Autonomous Agent Rules

### Rule 1: State before action
Before any tool call that modifies state (Edit, Write, Bash with side effects), state what you're about to do and why. One sentence minimum.

### Rule 2: Verify before trusting
Never trust prior session state, cached observations, or plan documents without verifying against current repo. Files move. Code changes. Plans go stale.

### Rule 3: Fail loudly
If something unexpected happens — test fails, file missing, behavior differs from plan — stop and report. Don't silently work around it. The workaround might mask a real bug.

### Rule 4: Scope lock
Define your blast radius before starting. List files you will touch. If you discover you need to touch more, pause and re-plan. Scope creep is the #1 cause of broken autonomous runs.

### Rule 5: One commit per logical change
Don't batch unrelated changes. "Fix bug AND refactor AND add test AND update docs" is 4 commits, not 1. Exception: test + implementation when doing TDD (red-green-refactor is one logical unit).

### Rule 6: Leave breadcrumbs
Every session should leave the tracking docs more accurate than it found them. Future agents depend on this.

### Rule 7: Respect invariants
Project-specific invariants that must never be violated:
- Never change Hive type IDs (corrupts user data)
- Never skip `build_runner` after modifying annotated models
- Never commit generated files (*.g.dart, *.freezed.dart)
- Never remove existing test coverage
- Always match existing code style

### Rule 8: Ask when uncertain
If confidence < 80% on any decision with irreversible consequences, stop and ask the user. The cost of asking is low. The cost of a wrong irreversible action is high.

---

## Session Startup Checklist

Every new agent session should begin with:

```
1. Read CLAUDE.md (project rules)
2. Read docs/tracking/CURRENT_SPRINT.md (what's active)
3. Read docs/tracking/TASKS.md (overall status)
4. git status && git log --oneline -5 (repo state)
5. Understand the request in context of current sprint
```

Time cost: ~30 seconds. Prevents: misaligned work, duplicate effort, stale assumptions.

---

## Anti-Pattern Catalog

| Anti-Pattern | What Happens | Fix |
|---|---|---|
| **Blind execution** | Agent follows stale plan without checking repo | Always OBSERVE first |
| **Scope creep** | "While I'm here, let me also..." | Scope lock. Separate tasks. |
| **Silent workaround** | Test fails, agent skips it | Fail loudly. Report. |
| **Batch commit** | 5 unrelated changes in 1 commit | One commit per logical change |
| **Memory trust** | "Last session said X exists" | Verify. Files move. |
| **Plan without verify** | Steps with no success criteria | Every step gets a verify |
| **End-only testing** | Write everything, test at end | Verify per step |
| **Doc skip** | "The diff tells the story" | Future agents can't see your diff |
| **Style imposition** | Reformat code you didn't change | Match existing style |
| **Assumption hiding** | Make a choice without stating it | State assumptions explicitly |

---

## Integration with Project

This system is referenced from:
- `CLAUDE.md` — mandatory for all agent sessions
- `docs/planning/PRODUCTION_SPRINT_SEQUENCE.md` — sprints follow this loop
- `docs/tracking/LESSONS.md` — reflection output goes here

---

*Created: 2026-06-03 | Version: 1.0*
