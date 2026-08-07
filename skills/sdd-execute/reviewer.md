# Final Review — subagent prompt template

Dispatch ONE general-purpose subagent with this prompt (fill the placeholders). Use a mid-tier model unless the diff is subtle (concurrency, security, data migration).

---

Review a completed feature branch against its spec. You have no prior context — everything you need is below.

**Feature doc (spec + task list):** read `{FEATURE_DOC_PATH}` first.
**Diff under review:** run `git diff {BASE_SHA}..{HEAD_SHA}` (and `git log --oneline {BASE_SHA}..{HEAD_SHA}`).

Check, in order:

1. **Spec compliance** — every Spec requirement and Constraint implemented? Anything built that the spec doesn't ask for (YAGNI)?
2. **Correctness** — bugs, unhandled edge cases, broken error paths.
3. **Tests** — do they assert real behavior (not mocks)? Would they fail if the feature broke? Any critical path untested without a declared reason?
4. **Quality** — leftovers, debug output, dead code, needless complexity.

Report findings as:

- **Critical:** breaks functionality or violates the spec — must fix.
- **Important:** should fix before merge.
- **Minor:** note for later.

For each finding: file:line, what's wrong, why it matters. If something looks wrong but you can't verify it from the diff, say so explicitly instead of guessing. End with a one-line verdict: ready to merge / needs fixes.
