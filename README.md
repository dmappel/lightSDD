# lightSDD

Lightweight spec-driven development for Claude Code. A minimal alternative to heavyweight SDD frameworks (like [superpowers](https://github.com/obra/superpowers)): keeps the discipline that makes agent-written code trustworthy, drops the ceremony and the subagent token burn.

## Core idea

**Process depth is proportional to the task.** Instead of one mandatory full pipeline for everything, three tiers:

| Tier | Fits | Process |
|------|------|---------|
| **quick** | typo, config tweak, trivial fix | No artifacts. Do it, verify. |
| **std** | small feature/bugfix, ~1–3 files | Inline mini-spec (5–7 bullets), one "OK", implement. |
| **full** | multi-task feature, risky refactor | One feature doc = spec + plan + progress ledger in a single file, one approval, implement task by task. |

Claude proposes the tier; you confirm with one word (quick needs no confirmation).

## What it keeps from heavyweight SDD

- **Verification before "done"** — no success claims without a fresh command run and its output.
- **Red-first bugfixes** — a failing repro test before every fix, no exceptions.
- **TDD-lite invariant** — every new test must be *seen failing* once (test-first, or a 30-second red-check by temporarily reverting the change). Tests assert real behavior, never mocks.
- **Root-cause debugging** — no guess-fixes; 3 failed attempts → stop and question the approach.
- **A progress ledger that survives context compaction** — the task checklist lives in the feature doc itself.

## What it drops

- Per-task implementer/reviewer/re-review subagent loops (15–20 dispatches per plan in heavyweight setups) → all implementation is inline; **one** optional final-review subagent at the end.
- Plans that duplicate the full implementation code in markdown → tasks name files, interfaces, and exact values; code is written once, in the repo.
- Mandatory design ceremony for trivial changes → tiers.
- Five artifacts per feature (spec, plan, ledger, briefs, reports) → one file in `docs/sdd/`.

## Install

```
/plugin marketplace add dmappel/lightSDD
/plugin install lightsdd
```

## Use

- `/sdd` (or just start a coding task — the router skill picks it up): proposes a tier and proceeds.
- `/sdd full` / `/sdd std` / `/sdd quick`: force a tier.

## Structure

```
skills/
  sdd/           router: tiers, always-on rules, escalation
  sdd-plan/      tier full: the single feature-doc format
  sdd-execute/   execution loop, TDD-lite, debugging, completion
                 + reviewer.md (optional final-review subagent prompt)
```
