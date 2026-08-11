# lightSDD

Lightweight spec-driven development for Claude Code. A minimal alternative to heavyweight SDD frameworks (like [superpowers](https://github.com/obra/superpowers)): keeps the discipline that makes agent-written code trustworthy, drops the ceremony and the subagent token burn.

## Core idea

**Process depth is proportional to the risk of the task** — not to its size. Instead of one mandatory full pipeline for everything, three tiers:

| Tier | Fits | Process |
|------|------|---------|
| **quick** | obvious, low-risk, reversible; no real design decision | No artifacts. Do it, verify. |
| **std** | bounded feature/bugfix, design is clear, blast radius contained | Inline mini-spec (5–7 bullets), one "OK", implement. |
| **full** | cross-cutting feature, unclear design, risky refactor, or a change to contracts / data / security / concurrency | One feature doc = spec + plan + progress ledger in a single file, one approval, implement task by task. |

Tier follows design uncertainty, blast radius, reversibility and risk; file count is only a weak signal — one auth change can be `full`, five config edits can be `quick`.

Claude proposes the tier; you confirm with one word (quick needs no confirmation). Mid-flight it moves either way: escalates when a task reveals hidden risk, de-escalates when exploration shows the work is simpler than proposed.

## How a session flows

**quick** — Claude announces "tier quick", makes the change, runs the command that proves it works, shows the output. That's it.

**std** — Claude posts a mini-spec right in the chat:

> Tier std — clear design, one module. Mini-spec:
> - **Goal:** reject empty emails on signup
> - **Approach:** validate in `SignupForm.submit`, reuse `validators.ts`
> - **Acceptance:** empty and whitespace-only input blocks submit and shows the field error; valid input is unaffected
> - **Tests:** red repro for the bug, plus empty/whitespace cases
> - **Files:** `src/signup/form.ts`, `src/signup/form.test.ts`
>
> OK?

You say "ok", Claude implements, shows test output, done. One round-trip of overhead, total.

**full** — Claude explores the codebase, infers what it can and asks only the questions where a wrong guess is expensive (batched into one message, each with a proposed default), then writes a single feature doc and posts its path plus a 5-line summary. You approve once. Claude then works through the tasks in the main session — no implementer subagents — ticking checkboxes and appending progress lines as it goes. At the end: a fresh verification run, an optional one-shot review subagent, and a one-line handoff question (merge / PR / leave the branch).

## Artifacts

- **quick:** nothing but the commit.
- **std:** the mini-spec in chat history and the commit(s). No files.
- **full:** exactly one file — `docs/sdd/YYYY-MM-DD-<feature>.md`:

```markdown
# <Feature>

## Spec        ← goal, non-goals, approach, interfaces, constraints, acceptance criteria
## Tasks       ← checkboxes: files, deliverable, evidence that proves it
## Progress    ← append-only log: "Task 2: done (a1b2c3d)"
```

This one file replaces the spec doc + plan doc + ledger + briefs + reports of heavyweight setups. It doubles as the recovery point: after context compaction or in a new session, Claude re-reads the checkboxes, the Progress log, and `git log` — and resumes at the first unfinished task instead of redoing completed work.

## The discipline that stays on (every tier)

- **Verification before "done"** — no success claims without a fresh command run and its output, and a plain statement of what was and wasn't run. "Should work" is not a status.
- **Reproduce-first bugfixes** — reproduce before fixing, with a failing repro test whenever practical. The automation is negotiable, the reproduction isn't.
- **TDD-lite invariant** — a task isn't done until a test exists that would fail if the feature broke. For new code red comes for free. For *changes to existing behavior* — where a test can pass for the wrong reason — red must be seen: test-first, or a 30-second red-check (revert the key line → test must fail → restore). Mocks are fine at system boundaries; what doesn't count is a mock assertion standing in for the behavioral proof. Skipping tests (config, glue, prototypes) is allowed but must be declared in one line.
- **Root-cause debugging** — minimize the reproduction, observe the actual state before forming a hypothesis, no guess-fixes; after 3 failed attempts, stop editing and reassess the model of the problem instead of trying fix #4.
- **No silent scope creep** — unrelated discoveries get parked, not fixed in passing.

## What it deliberately drops

- Per-task implementer/reviewer/re-review subagent loops (15–20 dispatches per plan in heavyweight setups) → all implementation is inline; **one** optional final-review subagent at the end (tier full or on request).
- Plans that duplicate the full implementation code in markdown → tasks name files, interfaces, and exact values; code is written once, in the repo.
- Mandatory design ceremony for trivial changes → tiers.
- A separate brainstorming skill and a fixed `brainstorm → plan → execute` pipeline → design discussion lives inside tier full's planning step, where it's actually needed; when a request isn't a task yet, Claude talks it through with no tier and no artifact.
- "Invoke a skill before ANY response" gating, and injecting whole skill bodies into every session → one session-start hook injects a single routing rule (six lines) pointing at the `sdd` router; every other skill still loads lazily, when actually relevant.

## Install

```
/plugin marketplace add dmappel/lightSDD
/plugin install lightsdd
```

## Use

- `/sdd` (or just start talking about a change — the router is picked up while planning, not at the first line of code): proposes a tier and proceeds.
- `/sdd full` / `/sdd std` / `/sdd quick`: force a tier.
- Ask for a review anytime — the final-review subagent isn't tied to a tier.

## Structure

```
skills/
  sdd/           router: tiers, always-on rules, escalation
  sdd-plan/      tier full: the single feature-doc format
  sdd-execute/   execution loop, TDD-lite, debugging, completion
                 + reviewer.md (optional final-review subagent prompt)
hooks/
  session-start  injects the one rule that routes a change conversation
                 into `sdd` before code — the rest stays lazy
```
