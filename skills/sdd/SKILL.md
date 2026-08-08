---
name: sdd
description: "Use when starting any development task (feature, bugfix, refactor) — pick the right process depth (quick/std/full) for lightweight spec-driven development. Trigger: /sdd or beginning of coding work."
---

# lightSDD — Router

Process depth is proportional to the *risk* of the task, not its size. Propose a tier, confirm in one line, proceed. Never apply more process than the task deserves.

## Tiers

| Tier | Fits | Process |
|------|------|---------|
| **quick** | obvious, low-risk, reversible; no real design decision | No artifacts. Do it, then verify (Always-on rules still apply). |
| **std** | bounded feature or bugfix, design clear, blast radius contained | Mini-spec inline in chat. One user "OK" → implement per `sdd-execute`. |
| **full** | cross-cutting feature, unclear design, risky refactor, or a change to contracts / data / security / concurrency | Single feature doc (spec + plan + progress) per `sdd-plan`, one approval → implement per `sdd-execute`. |

## Choosing a tier

A tier the user names (`/sdd full`) wins. Otherwise weigh design uncertainty, blast radius, reversibility, contracts, security/concurrency risk. **File count is a weak signal** — one auth change can be `full`, five config edits `quick`.

**If it isn't a task yet** — an open problem, not a change ("thinking about realtime collab, not sure how") — don't assign a tier. Talk it through first: no artifact, no gate. Propose a tier once the shape of the solution is agreed.

- Propose in one line: *"Tier std — design clear, blast radius one module. Mini-spec below, OK?"*
- **quick** needs no confirmation — announce and proceed.
- **std/full** wait for one confirmation, bundled with the mini-spec/doc summary so approval is a single round-trip.
- In doubt between two tiers, propose the lighter one and say what would bump it up.

**std mini-spec** — 5–7 bullets in chat, no file: goal · approach · **acceptance criteria** (the observable conditions that mean "done") · tests/verification · non-goals or constraints, if any · likely files, when useful.

## Always-on rules (every tier, including quick)

1. **Verification before "done":** never claim complete/fixed/passing without running the proving command *in this turn* and reading its output. "Should work" is not a status.
2. **Bugfix = reproduce first:** reproduce the bug before fixing it — with a failing test whenever that's practical. The automation is negotiable, the reproduction isn't.
3. **Root cause before fix:** read the actual error, reproduce, check recent changes. No guess-fixes. After 3 failed fix attempts — stop editing and reassess (see `sdd-execute`).
4. **No silent scope creep:** park unrelated discoveries instead of fixing them in passing.

## Changing tier mid-flight

Both directions, as soon as you know. **Escalate** when the task grows or reveals hidden risk (quick hits a rabbit hole, std sprouts subtasks) — don't push through with the wrong tier. **De-escalate** when exploration shows the work is simpler than proposed — drop a tier instead of finishing the ceremony for its own sake.
