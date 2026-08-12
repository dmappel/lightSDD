#!/usr/bin/env bash

set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/lightsdd-codex-test.XXXXXX")
trap 'rm -rf "$TEST_ROOT"' EXIT

python3 -m json.tool "$ROOT/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/.agents/plugins/marketplace.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/marketplace.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/plugin.json" >/dev/null
bash -n "$ROOT/hooks/session-start"

assert_contains() {
  local file=$1
  local text=$2

  if ! grep -Fq "$text" "$file"; then
    printf 'missing required text in %s: %s\n' "$file" "$text" >&2
    return 1
  fi
}

assert_frontmatter_contains() {
  local file=$1
  local text=$2

  python3 -c '
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
frontmatter = source.split("---", 2)[1]
if sys.argv[2] not in frontmatter:
    raise SystemExit(f"missing required frontmatter text in {sys.argv[1]}: {sys.argv[2]}")
' "$file" "$text"
}

assert_contains "$ROOT/skills/sdd/SKILL.md" "## Scope boundary"
assert_contains "$ROOT/skills/sdd/SKILL.md" "## User-facing communication"
assert_frontmatter_contains "$ROOT/skills/sdd/SKILL.md" "Do not use for non-software artifacts"
assert_contains "$ROOT/README.md" "## User-facing communication"

bash "$ROOT/hooks/session-start" | python3 -c '
import json
import sys

payload = json.load(sys.stdin)
context = payload["hookSpecificOutput"]["additionalContext"]
assert "Do not invoke lightSDD for work on non-software artifacts" in context
'

git -C "$ROOT" diff --check

CODEX_HOME="$TEST_ROOT" codex plugin marketplace add "$ROOT" >/dev/null
CODEX_HOME="$TEST_ROOT" codex plugin add lightsdd@lightsdd-marketplace >/dev/null
VERSION=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["version"])' "$ROOT/.codex-plugin/plugin.json")
test -f "$TEST_ROOT/plugins/cache/lightsdd-marketplace/lightsdd/$VERSION/skills/sdd/SKILL.md"

if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$ROOT" >/dev/null
fi

echo "lightSDD package validation passed"
