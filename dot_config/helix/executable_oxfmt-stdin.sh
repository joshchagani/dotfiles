#!/usr/bin/env bash
# Format stdin with the project's Oxfmt -- the same engine as the nucleus repo's
# `vp fmt` -- so Helix's format-on-save output is identical to CI.
#
# $1 is a filename hint (e.g. a.tsx) used only to pick the parser. We resolve the
# project's own oxfmt from node_modules so the version always matches `vp`.
# If oxfmt can't be found, the buffer passes through unchanged (never mangled).
set -uo pipefail
hint="${1:-a.tsx}"

run() { exec "$1" --stdin-filepath="$hint"; }

# 1) oxfmt on PATH (if ever installed globally)
command -v oxfmt >/dev/null 2>&1 && run "$(command -v oxfmt)"

# 2) walk up from the working directory for node_modules/.bin/oxfmt
dir="$PWD"
while [ "$dir" != "/" ]; do
  [ -x "$dir/node_modules/.bin/oxfmt" ] && run "$dir/node_modules/.bin/oxfmt"
  dir="$(dirname "$dir")"
done

# 3) monorepo FE package when Helix is launched at the repo/worktree root
[ -x "$PWD/apps/web/node_modules/.bin/oxfmt" ] && run "$PWD/apps/web/node_modules/.bin/oxfmt"

# 4) last resort: leave the buffer untouched
exec cat
