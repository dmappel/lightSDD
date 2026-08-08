---
name: sdd-execute
description: "Use when implementing lightSDD work (tier std or full) — execution loop, TDD-lite discipline, debugging rules, and completion."
---

# lightSDD — Execute

All implementation happens inline in this session. No implementer subagents, no per-task reviewer dispatches.

Work on a feature branch — on the default branch, create one before the first commit. Required for full, the same default for std unless the user says otherwise; it's also what makes the merge/PR/leave choice at completion exist.

## Loop (per task)

1. Implement the task and its tests (together is fine).
2. **Red evidence** — see TDD-lite below.
3. Run the tests; everything green, output clean.
4. Glance over the diff once: leftovers, debug prints, scope creep?
5. Commit. Tier full: tick the task checkbox and append a Progress line: `Task N: done (<short-sha>)`.

Don't pause between tasks for "should I continue?" — stop only when blocked or when a decision is genuinely the user's.

**Unrelated discoveries** (a bug elsewhere, a tempting refactor) are parked, not fixed: one line in Progress (tier full) or one sentence to the user (tier std). Never fix silently mid-task — that's scope creep.

## TDD-lite

**The invariant:** a task isn't done until a test exists that would fail if the feature were broken.

- **New code** (the function/module didn't exist): the test can't pass before the implementation — red is automatic, nothing extra to do. Test-first when it sharpens the design.
- **Changing existing behavior:** a test here can pass for the wrong reason, so red must be *seen* — test-first (test → red → change → green), or **red-check**: revert the key line, the test MUST fail, restore. ~30 seconds, and only this case needs it.
- **Bugfix:** reproduce before fixing, always — a failing repro test whenever practical (red → fix → green). When automation genuinely isn't (prod-only race, real UI), record a deterministic reproducer instead and re-run it after the fix.
- **Mocks** are fine at system boundaries (HTTP, clock, queue, SaaS, DB) when they buy determinism or speed. Assert observable outcomes: `mock.toHaveBeenCalled(...)` alone isn't evidence — unless the interaction *is* the contract (a webhook fired, a message published).
- **Skipping tests** (pure config, glue, UI tweaks, throwaway prototype) is allowed but must be declared in one line: "no tests here because X, verified instead by Y" — a decision, not an omission.
- **Hard to test = hard to use.** If a test is painful to write, simplify the interface first, then test.

## Debugging (whenever anything fails)

Root cause before fix — no guess-fixes:

1. Read the actual error/stack completely; reproduce it reliably; check what changed recently (`git diff`, new deps).
2. **Minimize the reproduction** first: strip the failing scenario until removing anything else makes the bug disappear. Debugging the full scenario spends most hypotheses on noise.
3. **Observe before hypothesizing** — log, dump or break on the actual state. The hypothesis comes from something you saw, not from what the code looks like it does.
4. One hypothesis at a time, smallest change that tests it. Don't stack fixes.
5. After **3 failed fix attempts**: stop editing and write out the reassessment — which assumption is still unverified? architecture, environment, a dependency, a recent change? Act on that, not on fix #4. Go to the user only when the way forward needs a decision that's theirs — product, design, trade-off — not merely because the counter hit 3.

## Recovery after compaction

Re-read the feature doc (checkboxes + Progress) and `git log`. Tasks marked done are DONE — never redo them; trust the doc and git over your recollection.

## Completion

1. **Fresh verification run** — in this turn, never a claim carried over. The relevant suite plus what the change needs (lint, typecheck, build, a runtime check); the **full** repo suite when the tier is full, when the change can reach unrelated areas, or when it's cheap. Then state what you ran and what you didn't.
2. **Optional final review** — for tier full, security/data/concurrency/migration changes, or on request: dispatch ONE reviewer subagent per [reviewer.md](reviewer.md) with the feature doc path and the diff range (merge-base..HEAD). Fix Critical/Important findings (push back with reasoning if one is wrong), list Minor ones for the user. One review, one fix pass, one re-check — no loops.
3. **Hand off:** report what was built, which acceptance criteria it satisfies, and the fresh verification evidence. Then ask in one line: merge / push + PR / leave the branch. The integration decision is the user's.
