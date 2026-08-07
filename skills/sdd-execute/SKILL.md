---
name: sdd-execute
description: Use when implementing lightSDD work (tier std or full) — execution loop, TDD-lite discipline, debugging rules, and completion.
---

# lightSDD — Execute

All implementation happens inline in this session. No implementer subagents, no per-task reviewer dispatches.

## Loop (per task)

1. Implement the task and its tests (together is fine).
2. **Red evidence** — see TDD-lite below.
3. Run the tests; everything green, output clean.
4. Glance over the diff once: leftovers, debug prints, scope creep?
5. Commit. Tier full: tick the task checkbox and append a Progress line: `Task N: done (<short-sha>)`.

Don't pause between tasks for "should I continue?" — stop only when blocked or when a decision is genuinely the user's.

## TDD-lite

**The invariant:** a task isn't done until a test exists that would fail if the feature were broken — and you have *seen* it fail. Two legal ways to get there:

- **Test-first:** test → run → red → implement → green.
- **Red-check:** wrote code and test together, test is green → temporarily revert/break the key line of the change → the test MUST fail → restore → green. ~30 seconds, same proof.

Rules:

- **Bugfix:** failing repro test *before* the fix, always. The repro is half the diagnosis.
- **Assert real behavior, never mock behavior.** A test whose assertion is `mock.toHaveBeenCalled(...)` doesn't count.
- **Skipping tests** (pure config, glue, UI tweaks, throwaway prototype) is allowed but must be declared in one line: "no tests here because X" — a decision, not an omission.
- **Hard to test = hard to use.** If a test is painful to write, simplify the interface first, then test.

## Debugging (whenever anything fails)

Root cause before fix — no guess-fixes:

1. Read the actual error/stack completely; reproduce it reliably; check what changed recently (`git diff`, new deps).
2. One hypothesis at a time, smallest change that tests it. Don't stack fixes.
3. After **3 failed fix attempts**: stop. The problem is likely structural — question the approach with the user instead of trying fix #4.

## Recovery after compaction

Re-read the feature doc (checkboxes + Progress) and `git log`. Tasks marked done are DONE — never redo them; trust the doc and git over your recollection.

## Completion

1. **Fresh full test-suite run.** The output is the evidence; never claim done from an earlier run.
2. **Optional final review** — for tier full, or whenever the user asks: dispatch ONE reviewer subagent using [reviewer.md](reviewer.md), giving it the feature doc path and the diff range (merge-base..HEAD). Fix Critical/Important findings (push back with reasoning if a finding is wrong); list Minor ones for the user. One review, one fix pass, one short re-check — no loops.
3. **Hand off:** report what was built with test evidence, then ask in one line: merge / push + PR / leave the branch. The integration decision is the user's.
