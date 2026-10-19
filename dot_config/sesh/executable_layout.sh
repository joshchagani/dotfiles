#!/usr/bin/env bash
# sesh default_session startup: build the standard workspace in the new session.
#   window 0 "claude": Claude Code (claudeb alias); drops to a shell when you exit it
#   window 1 "editor": helix (top) | shell (bottom)
#   window 2 "hunk":   live diff review (hunk diff --watch); drops to a shell on quit
# Idempotent: exits early if the layout already exists (e.g. on re-attach).
set -uo pipefail
[ -n "${TMUX:-}" ] || exit 0

dir="$(tmux display-message -p '#{pane_current_path}')"
shell="${SHELL:-/bin/zsh}"

# Already laid out? A "claude" window means we built it on a previous connect.
tmux list-windows -F '#{window_name}' | grep -qx claude && exit 0

# --- claude window (index 0): the initial window; we launch Claude Code here last ---
tmux rename-window claude
tmux select-pane -T claude

# --- editor window (index 1): helix (top) | shell (bottom) ---
tmux new-window -n editor -c "$dir" "hx '$dir'"
tmux select-pane -T helix
tmux split-window -v -c "$dir" -l 30%   # bottom: a shell
tmux select-pane -T shell
tmux select-pane -t editor.0            # leave helix focused in this window

# --- hunk window (index 2): live diff review in watch mode; drops to a shell when you quit hunk ---
tmux new-window -n hunk -c "$dir" "hunk diff --watch; exec $shell"
tmux select-pane -T hunk

# Focus the claude window, then launch Claude Code via the claudeb alias; shell on exit.
tmux select-window -t claude
exec zsh -ic 'claudeb; exec zsh'
