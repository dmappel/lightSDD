---
name: sdd
description: Use when starting any development task (feature, bugfix, refactor) — pick the right process depth (quick/std/full) for lightweight spec-driven development. Trigger: /sdd or beginning of coding work.
---

# lightSDD — Router

Process depth is proportional to the task. Propose a tier, confirm in one line, proceed. Never apply more process than the task deserves.

## Tiers

| Tier | Fits | Process |
|------|------|---------|
| **quick** | typo, config tweak, one obvious edit, trivial fix | No artifacts. Do it, then verify (Always-on rules still apply). |
| **std** | small feature or bugfix, ~1–3 files, one sitting | Mini-spec inline in chat: 5–7 bullets (goal, approach, files, tests). One user "OK" → implement per `sdd-execute`. |
| **full** | multi-task feature, new subsystem, risky refactor | Single feature doc (spec + plan + progress) per `sdd-plan`, one approval → implement per `sdd-execute`. |

## Choosing a tier

- Propose in one line: *"Tier std — touches 2 files, needs tests. Mini-spec below, OK?"*
- **quick** needs no confirmation — announce and proceed.
- **std/full** wait for one confirmation, bundled with the mini-spec/doc summary so approval is a single round-trip.
- If the user names a tier (`/sdd full`), use it.
- When in doubt between two tiers, propose the lighter one and say what would bump it up.

## Always-on rules (every tier, including quick)

1. **Verification before "done":** never claim complete/fixed/passing without running the proving command *in this turn* and reading its output. "Should work" is not a status.
2. **Bugfix = red first:** reproduce a bug with a failing test *before* fixing it. No exceptions.
3. **Root cause before fix:** read the actual error, reproduce, check recent changes. No guess-fixes. After 3 failed fix attempts — stop and question the approach with the user.

## Escalation

If a task grows mid-flight (quick reveals a rabbit hole, std sprouts subtasks) — say so and propose the next tier up. Don't push through with the wrong tier.
