#!/usr/bin/env bash
# sesh default_session startup: build the standard workspace in the new session.
#   window "editor": helix (left) | shell (right)
#   window "claude": Claude Code (claudeb alias); drops to a shell when you exit it
#   window "hunk":   live diff review (hunk diff --watch); drops to a shell on quit
# Idempotent: exits early if the layout already exists (e.g. on re-attach).
set -uo pipefail
[ -n "${TMUX:-}" ] || exit 0

dir="$(tmux display-message -p '#{pane_current_path}')"
shell="${SHELL:-/bin/zsh}"

# Already laid out? A "claude" window means we built it on a previous connect.
tmux list-windows -F '#{window_name}' | grep -qx claude && exit 0

# --- editor window: helix (left) | shell (right) ---
tmux rename-window editor
tmux select-pane -T helix
tmux split-window -h -c "$dir" -l 30%   # right: a shell
tmux select-pane -T shell

# --- claude window: launch Claude Code via the claudeb alias; shell on exit ---
tmux new-window -n claude -c "$dir" "zsh -ic 'claudeb; exec zsh'"
tmux select-pane -T claude

# --- hunk window: live diff review in watch mode; drops to a shell when you quit hunk ---
tmux new-window -n hunk -c "$dir" "hunk diff --watch; exec $shell"
tmux select-pane -T hunk

# Focus the editor window + helix pane, then launch Helix.
tmux select-window -t editor
tmux select-pane -t 0
exec hx "$dir"
