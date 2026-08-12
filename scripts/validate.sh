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
git -C "$ROOT" diff --check

CODEX_HOME="$TEST_ROOT" codex plugin marketplace add "$ROOT" >/dev/null
CODEX_HOME="$TEST_ROOT" codex plugin add lightsdd@lightsdd-marketplace >/dev/null
VERSION=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["version"])' "$ROOT/.codex-plugin/plugin.json")
test -f "$TEST_ROOT/plugins/cache/lightsdd-marketplace/lightsdd/$VERSION/skills/sdd/SKILL.md"

if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$ROOT" >/dev/null
fi

echo "lightSDD package validation passed"
