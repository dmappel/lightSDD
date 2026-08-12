---
name: sdd
description: "Use as soon as a conversation turns to changing a codebase — building a feature, fixing a bug, refactoring — including while still only discussing, scoping, planning, or deciding what should be done, and even when the user says \"we're just talking\" or \"don't write code yet\". Picks the process depth (quick/std/full) for lightweight spec-driven development. Triggers: /sdd; \"what should we do here\", \"what's the plan\", \"let's scope this\", \"write a spec / design doc\"; analyzing a repo, transcript or ticket to work out what software change to build; agreeing a plan in chat; the first edit of any feature, bugfix or refactor. Do not use for non-software artifacts such as offers, resumes, articles, presentations, spreadsheets, or general research unless they are inputs to deciding a software change. Load it at the START of a software-change conversation, not at the first line of code."
---

# lightSDD — Router

Process depth is proportional to the *risk* of the task, not its size. Select the tier, get at most one confirmation when needed, and proceed — never more process than the task deserves.

## Scope boundary

Use lightSDD only when the user is considering or requesting a change to software in the codebase: a feature, bugfix, refactor, or a change to configuration, dependencies, APIs, schemas, security, or runtime behavior. Being in a repository is not enough by itself.

**Outside lightSDD:** creating, reviewing, or researching non-software artifacts such as offers, resumes, articles, marketing copy, research summaries, presentations, or spreadsheets. Use lightSDD only when such material is input to deciding what software change to build. Otherwise respond normally or use the relevant non-SDD workflow, with no tier or SDD gate.

Examples:

- "Review this commercial offer" → outside lightSDD.
- "Research these competitors" → outside lightSDD unless the findings will define a software change.
- "Read this product brief and scope the checkout feature" → use lightSDD before analyzing the brief.

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

- Select the tier internally. Name it only under the user-facing rules below.
- **quick** needs no confirmation — proceed with a concise, outcome-oriented status.
- **std/full** take one confirmation, bundled with the mini-spec/doc summary — approval is a single round-trip.
- In doubt between two tiers, propose the lighter one and say what would bump it up.

**std mini-spec** — 5–7 bullets in chat, no file: goal · approach · **acceptance criteria** (the observable conditions that mean "done") · tests/verification · non-goals or constraints, if any · likely files, when useful.

## User-facing communication

The process is internal by default; the user should mainly see what will happen and what they need to decide.

- Lead with the intended outcome or current action, then give the reason and next deliverable.
- Do not narrate skill selection, tool calls, files read for routing, or an agent/subagent roster. Do not mention `sdd-plan` or `sdd-execute` in ordinary status updates.
- Name `quick`, `std`, or `full` only when the user explicitly invokes or names lightSDD, or asks about the workflow. Otherwise use plain language such as "This is a contained change; here is the short plan."
- If the host requires announcing skill use, use one plain sentence: "I'm using lightSDD to choose the right amount of planning." Then return to the user's goal.
- Keep routine progress updates to one or two sentences. Surface decisions, blockers, material risks, and verification results; omit orchestration detail.

Prefer:

> I'll review the offer's claims and assumptions, then return a revised version. I won't change disputed points until you confirm them.

Avoid:

> lightSDD selected full; I'll invoke researcher, critic, editor, and graph tools before synthesizing the artifact chain.

## Always-on rules (every tier, including quick)

1. **Verification before "done":** never claim complete/fixed/passing without running the proving command *in this turn* and reading its output. "Should work" is not a status.
2. **Bugfix = reproduce first:** reproduce the bug before fixing it, with a failing test whenever practical. The automation is negotiable, the reproduction isn't.
3. **Root cause before fix:** read the actual error, reproduce, check recent changes. No guess-fixes. After 3 failed fix attempts — stop editing and reassess (see `sdd-execute`).
4. **No silent scope creep:** park unrelated discoveries instead of fixing them in passing.

## Changing tier mid-flight

Both directions, as soon as you know. **Escalate** when the task grows or reveals hidden risk (quick hits a rabbit hole, std sprouts subtasks). **De-escalate** when exploration shows the work is simpler than proposed. Either way say so — don't finish in the wrong tier out of inertia.
