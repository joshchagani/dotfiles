#!/usr/bin/env bash
# Run the project's oxlint as a language server (lint diagnostics in Helix),
# resolving oxlint from the project's own node_modules so the rules track the
# repo's vite-plus version. `vp lint` remains the source of truth -- standalone
# oxlint may apply slightly different defaults. If no project oxlint is found,
# exit cleanly so Helix simply gets no lint server (no crash loop).
set -uo pipefail

try() { [ -x "$1" ] && exec "$1" --lsp; }

# 1) oxlint on PATH (global install)
command -v oxlint >/dev/null 2>&1 && exec oxlint --lsp

# 2) walk up from the working directory for node_modules/.bin/oxlint
dir="$PWD"
while [ "$dir" != "/" ]; do
  try "$dir/node_modules/.bin/oxlint"
  dir="$(dirname "$dir")"
done

# 3) monorepo FE package when Helix is launched at the repo/worktree root
try "$PWD/apps/web/node_modules/.bin/oxlint"

# 4) no oxlint available here
exit 0
