#!/usr/bin/env bash
# Claude Code SessionStart hook: when Claude is launched inside a tmux session
# (as it is from the sesh default_session layout, see ./layout.sh), print a map
# of the surrounding tmux session to stdout. Claude Code injects a SessionStart
# hook's stdout into the agent's context, so the agent starts out knowing it
# lives in tmux and can read/drive the other panes and windows by name.
#
# Safe by construction: outside tmux there is no $TMUX, so this exits silently
# and injects nothing. sesh only ever runs inside tmux, so this only speaks up
# inside a sesh-built workspace. The map is a point-in-time snapshot of whatever
# windows/panes exist when Claude boots.
set -uo pipefail

command -v tmux >/dev/null 2>&1 || exit 0
[ -n "${TMUX:-}" ] || exit 0

session="$(tmux display-message -p '#{session_name}' 2>/dev/null)" || exit 0
[ -n "$session" ] || exit 0

me="${TMUX_PANE:-}" # this agent's own pane id, e.g. %5

# window/pane facts, tab-delimited so titles and paths with spaces survive.
fmt=$'#{window_index}\t#{window_name}\t#{window_active}\t#{pane_index}\t#{pane_id}\t#{pane_active}\t#{pane_title}\t#{pane_current_command}\t#{pane_current_path}'

panes="$(tmux list-panes -s -F "$fmt" 2>/dev/null)" || exit 0
[ -n "$panes" ] || exit 0

cat <<'EOF'

## tmux / sesh session context

This Claude session is running inside a **tmux** session (built by sesh; see
~/.config/sesh/layout.sh). That durable fact is the important part: Claude can
see and drive the other panes and windows directly, so when the user points at
one by name ("the helix pane", "the shell", "the hunk window"), look it up live
and act on it with tmux.

How to look and drive (always current, never stale):
- List live state: `tmux list-panes -s -F '#{window_index} #{window_name} #{pane_id} #{pane_title} #{pane_current_command}'`
- Read a pane:     `tmux capture-pane -p -t <target>`  (add `-S -200` for scrollback)
- Send input:      `tmux send-keys -t <target> '<text>' Enter`  (types into that pane's program)
- A <target> is a pane id like `%5`, a window name, or `<window>.<pane>` (e.g. `editor.0`).

The list below is a point-in-time SNAPSHOT from when Claude started, useful only
for initial orientation. Pane ids (`%N`) are stable handles for a pane's
lifetime, but window names/indices and the set of panes can change. Before
acting on a specific pane, re-run `tmux list-panes -s` to confirm it is current.
EOF

printf -- '- Session: `%s`\n' "$session"
[ -n "$me" ] && printf -- '- This agent is running in pane `%s`.\n' "$me"
printf '\nWindows and panes (snapshot at startup):\n'

last_w=""
while IFS=$'\t' read -r widx wname wact pidx pid pact ptitle pcmd ppath; do
	[ -n "$widx" ] || continue
	if [ "$widx" != "$last_w" ]; then
		wmark=""
		[ "$wact" = "1" ] && wmark=" (active window)"
		printf -- '- [%s] %s%s\n' "$widx" "$wname" "$wmark"
		last_w="$widx"
	fi
	marks=""
	[ "$pact" = "1" ] && marks="${marks} [active pane]"
	[ -n "$me" ] && [ "$pid" = "$me" ] && marks="${marks} [<- this Claude agent]"
	printf -- '    - pane %s `%s` "%s" - %s (%s)%s\n' "$pidx" "$pid" "$ptitle" "$pcmd" "$ppath" "$marks"
done <<<"$panes"

exit 0
