---
name: sdd-plan
description: Use for lightSDD tier full — write the single feature doc (spec + plan + progress ledger in one file) before implementation.
---

# lightSDD — Feature Doc

One file per feature: `docs/sdd/YYYY-MM-DD-<feature>.md`. It is the spec, the plan, and the progress ledger at once — the single artifact that survives context compaction. No separate spec docs, plan docs, briefs, or reports.

## Before writing

- Explore the codebase first: relevant files, existing patterns, recent commits.
- Ask clarifying questions only where the answer changes the design. Batch them into ONE message; for each, propose a default so the user can just say "yes".
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
**Constraints:** exact values, versions, naming — verbatim, they can't be re-derived later.

## Tasks
- [ ] **Task 1: <name>** — files: `path/a.ts`, `path/b.test.ts`. What it delivers. Test: what proves it works.
- [ ] **Task 2: ...**

## Progress
<!-- append-only log, written during execution -->
```

## Task granularity

- A task = one independently testable deliverable, not a 2-minute step.
- Name the files and the interfaces; do **not** inline full implementation code — code gets written once, in the repo.
- Do include exact values (magic strings, endpoints, limits) and non-obvious decisions.
- Order tasks so each builds on committed, tested work.

## Self-review (inline, no subagent)

After writing, scan once: placeholders ("TBD", "handle errors properly")? contradictions between sections? every Spec point covered by a task? names/signatures consistent across tasks? Fix inline and move on.

## Gate

Post the doc path plus a ~5-line summary; the user approves once. Then implement per `sdd-execute`. This is the only approval gate before completion.
