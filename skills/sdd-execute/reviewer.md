# Final Review — subagent prompt template

Dispatch ONE general-purpose subagent with this prompt (fill the placeholders). Use a mid-tier model unless the diff is subtle (concurrency, security, data migration).

---

Review a completed feature branch against its spec. You have no prior context — everything you need is below.

**Feature doc (spec + task list):** read `{FEATURE_DOC_PATH}` first.
**Diff under review:** run `git diff {BASE_SHA}..{HEAD_SHA}` (and `git log --oneline {BASE_SHA}..{HEAD_SHA}`).

Read the surrounding implementation whenever the diff alone isn't enough to judge something — the changed lines rarely carry all the context.

Check, in order:

1. **Spec compliance** — is every acceptance criterion satisfied? Constraints and interfaces respected? Anything built that the spec doesn't ask for (YAGNI)?
2. **Correctness** — bugs, unhandled edge cases, broken error paths, regression and compatibility risk; security/data/concurrency where relevant.
3. **Tests** — do they exercise observable behavior, and would they fail if the feature broke? Are mocks sitting at real boundaries rather than standing in for the proof? Any critical path untested without a declared reason?
4. **Quality** — leftovers, debug output, dead code, changes unrelated to the spec; plus the smells code written fast leaves behind: shotgun surgery, feature envy, data clumps, duplicated logic, needless complexity.

Report findings as:

- **Critical:** breaks functionality or violates the spec — must fix.
- **Important:** should fix before merge.
- **Minor:** note for later.

For each finding: file:line, what's wrong, why it matters. **Don't invent findings to fill categories** — empty sections are a valid result. If something looks wrong but you can't verify it, say what you couldn't check instead of guessing. End with a one-line verdict: ready to merge / needs fixes.
