---
name: sdd
description: "Use as soon as a conversation turns to changing a codebase — building a feature, fixing a bug, refactoring — including while still only discussing, scoping, planning, or deciding what should be done, and even when the user says \"we're just talking\" or \"don't write code yet\". Picks the process depth (quick/std/full) for lightweight spec-driven development. Triggers: /sdd; \"what should we do here\", \"what's the plan\", \"let's scope this\", \"write a spec / design doc\"; analyzing a repo, transcript or ticket to work out what to build next; agreeing a plan in chat; the first edit of any feature, bugfix or refactor. Load it at the START of that conversation, not at the first line of code."
---

# lightSDD — Router

Process depth is proportional to the *risk* of the task, not its size. Propose a tier, confirm in one line, proceed — never more process than the task deserves.

## Tiers

| Tier | Fits | Process |
|------|------|---------|
| **quick** | obvious, low-risk, reversible; no real design decision | No artifacts. Do it, then verify — Always-on rules still apply. |
| **std** | bounded feature or bugfix, design clear, blast radius contained | Mini-spec in chat, one "OK" → implement per `sdd-execute`. |
| **full** | cross-cutting feature, unclear design, risky refactor, or a change to contracts / data / security / concurrency | Feature doc per `sdd-plan`, one approval → implement per `sdd-execute`. |

## Choosing a tier

A tier the user names (`/sdd full`) wins. Otherwise weigh design uncertainty, blast radius, reversibility, contracts, security/concurrency risk. **File count is a weak signal** — one auth change can be `full`, five config edits `quick`.

**Not a task yet?** An open problem rather than a change ("thinking about realtime collab, not sure how") gets no tier: talk it through, no artifact and no gate, and propose a tier once the shape is agreed.

**Arriving mid-discussion?** A plan already hammered out in chat still gets a tier and its spec **before** the first edit — a doc written after the code isn't a spec, it's a report.

- Propose in one line: *"Tier std — design clear, blast radius one module. Mini-spec below, OK?"*
- **quick** needs no confirmation — announce and proceed.
- **std/full** take one confirmation, bundled with the mini-spec/doc summary — approval is a single round-trip.
- In doubt between two tiers, propose the lighter one and say what would bump it up.

**std mini-spec** — 5–7 bullets in chat, no file: goal · approach · **acceptance criteria** (the observable conditions that mean "done") · tests/verification · non-goals or constraints, if any · likely files, when useful.

## Always-on rules (every tier, including quick)

1. **Verification before "done":** never claim complete/fixed/passing without running the proving command *in this turn* and reading its output. "Should work" is not a status.
2. **Bugfix = reproduce first:** reproduce the bug before fixing it, with a failing test whenever practical. The automation is negotiable, the reproduction isn't.
3. **Root cause before fix:** read the actual error, reproduce, check recent changes. No guess-fixes. After 3 failed fix attempts — stop editing and reassess (see `sdd-execute`).
4. **No silent scope creep:** park unrelated discoveries instead of fixing them in passing.

## Changing tier mid-flight

Both directions, as soon as you know. **Escalate** when the task grows or reveals hidden risk (quick hits a rabbit hole, std sprouts subtasks). **De-escalate** when exploration shows the work is simpler than proposed. Either way say so — don't finish in the wrong tier out of inertia.
