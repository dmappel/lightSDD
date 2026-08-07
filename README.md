# lightSDD

Lightweight spec-driven development for Claude Code. A minimal alternative to heavyweight SDD frameworks (like [superpowers](https://github.com/obra/superpowers)): keeps the discipline that makes agent-written code trustworthy, drops the ceremony and the subagent token burn.

## Core idea

**Process depth is proportional to the task.** Instead of one mandatory full pipeline for everything, three tiers:

| Tier | Fits | Process |
|------|------|---------|
| **quick** | typo, config tweak, trivial fix | No artifacts. Do it, verify. |
| **std** | small feature/bugfix, ~1–3 files | Inline mini-spec (5–7 bullets), one "OK", implement. |
| **full** | multi-task feature, risky refactor | One feature doc = spec + plan + progress ledger in a single file, one approval, implement task by task. |

Claude proposes the tier; you confirm with one word (quick needs no confirmation). If a task grows mid-flight, Claude says so and proposes the next tier up instead of pushing through.

## How a session flows

**quick** — Claude announces "tier quick", makes the change, runs the command that proves it works, shows the output. That's it.

**std** — Claude posts a mini-spec right in the chat:

> Tier std — touches 2 files, needs tests. Mini-spec:
> - **Goal:** reject empty emails on signup
> - **Approach:** validate in `SignupForm.submit`, reuse `validators.ts`
> - **Files:** `src/signup/form.ts`, `src/signup/form.test.ts`
> - **Tests:** red repro for the bug, plus empty/whitespace cases
>
> OK?

You say "ok", Claude implements, shows test output, done. One round-trip of overhead, total.

**full** — Claude explores the codebase, asks clarifying questions (batched into one message, each with a proposed default), then writes a single feature doc and posts its path plus a 5-line summary. You approve once. Claude then works through the tasks in the main session — no implementer subagents — ticking checkboxes and appending progress lines as it goes. At the end: fresh full test-suite run, an optional one-shot review subagent, and a one-line handoff question (merge / PR / leave the branch).

## Artifacts

- **quick:** nothing but the commit.
- **std:** the mini-spec in chat history and the commit(s). No files.
- **full:** exactly one file — `docs/sdd/YYYY-MM-DD-<feature>.md`:

```markdown
# <Feature>

## Spec        ← goal, non-goals, approach, interfaces, exact constraints
## Tasks       ← checkboxes: files, deliverable, what test proves it
## Progress    ← append-only log: "Task 2: done (a1b2c3d)"
```

This one file replaces the spec doc + plan doc + ledger + briefs + reports of heavyweight setups. It doubles as the recovery point: after context compaction or in a new session, Claude re-reads the checkboxes, the Progress log, and `git log` — and resumes at the first unfinished task instead of redoing completed work.

## The discipline that stays on (every tier)

- **Verification before "done"** — no success claims without a fresh command run and its output. "Should work" is not a status.
- **Red-first bugfixes** — a failing repro test before every fix, no exceptions.
- **TDD-lite invariant** — every new test must be *seen failing* once: test-first, or a 30-second red-check (temporarily revert the change → test must fail → restore). Tests assert real behavior, never mocks. Skipping tests (config, glue, prototypes) is allowed but must be declared in one line.
- **Root-cause debugging** — no guess-fixes; after 3 failed attempts, stop and question the approach.

## What it deliberately drops

- Per-task implementer/reviewer/re-review subagent loops (15–20 dispatches per plan in heavyweight setups) → all implementation is inline; **one** optional final-review subagent at the end (tier full or on request).
- Plans that duplicate the full implementation code in markdown → tasks name files, interfaces, and exact values; code is written once, in the repo.
- Mandatory design ceremony for trivial changes → tiers.
- Session-start hooks and "invoke a skill before ANY response" gating → skills load lazily, when actually relevant.

## Install

```
/plugin marketplace add dmappel/lightSDD
/plugin install lightsdd
```

## Use

- `/sdd` (or just start a coding task — the router skill picks it up): proposes a tier and proceeds.
- `/sdd full` / `/sdd std` / `/sdd quick`: force a tier.
- Ask for a review anytime — the final-review subagent isn't tied to a tier.

## Structure

```
skills/
  sdd/           router: tiers, always-on rules, escalation
  sdd-plan/      tier full: the single feature-doc format
  sdd-execute/   execution loop, TDD-lite, debugging, completion
                 + reviewer.md (optional final-review subagent prompt)
```
