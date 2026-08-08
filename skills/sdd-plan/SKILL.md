---
name: sdd-plan
description: "Use for lightSDD tier full — write the single feature doc (spec + plan + progress ledger in one file) before implementation."
---

# lightSDD — Feature Doc

One file per feature: `docs/sdd/YYYY-MM-DD-<feature>.md`. It is the spec, the plan, and the progress ledger at once — the single artifact that survives context compaction. No separate spec docs, plan docs, briefs, or reports.

It gets committed alongside the work; if this project shouldn't carry it, say so in one line and put it outside the repo or in `.gitignore` first — recovery only needs the path to be stable.

## Before writing

- Explore the codebase first: relevant files, existing patterns, recent commits.
- **Infer before asking:** investigate → infer → record it under Constraints as a stated assumption. Ask only where a wrong guess is expensive: it changes behavior, architecture, compatibility, or scope. Infer what the code can answer — goals, priorities and success criteria it can't, so those you ask.
- Batch the questions that survive that filter into ONE message; for each, propose a default so the user can just say "yes".
- If genuinely competing approaches exist, present 2 options with trade-offs and a recommendation — one message, not a questionnaire.
- YAGNI ruthlessly: cut every feature the goal doesn't require.

## Template

```markdown
# <Feature>

## Spec
**Goal:** 1–2 sentences.
**Non-goals:** what we explicitly won't do.
**Approach:** short prose — architecture, data flow, error handling.
**Interfaces:** key signatures/contracts that tasks or callers rely on.
**Constraints:** exact values, versions, naming — verbatim, they can't be re-derived later. Assumptions made instead of asking go here too.
**Acceptance criteria:**
- Observable condition proving requirement A holds.
- Observable condition proving requirement B holds.

## Tasks
- [ ] **Task 1: <name>** — files: `path/a.ts`, `path/b.test.ts`. What it delivers. Evidence: the test or command that proves it works.
- [ ] **Task 2: ...**

## Progress
<!-- append-only log, written during execution -->
```

## Task granularity

- A task = one independently verifiable deliverable, not a 2-minute step.
- Name the files and the interfaces; do **not** inline full implementation code — code gets written once, in the repo.
- Do include exact values (magic strings, endpoints, limits) and non-obvious decisions.
- Order tasks so each builds on committed, verified work.

## Self-review (inline, no subagent)

After writing, scan once: does every acceptance criterion have a task that delivers it and evidence that proves it? placeholders ("TBD", "handle errors properly")? contradictions between sections? names/signatures consistent across tasks? scope that crept in? Fix inline and move on.

## Gate

Post the doc path plus a ~5-line summary: goal, approach, major tasks, how it gets verified, notable risks. The user approves once. Then implement per `sdd-execute` — no further gates unless a new decision materially changes the approved spec.
