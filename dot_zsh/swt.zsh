# swt: sesh connect to a session for the current dir (or a passed dir/name),
# building the standard workspace layout (see ~/.config/sesh/layout.sh) if it
# doesn't exist yet. Run from a project/worktree dir to jump into its sesh
# workspace. sesh auto-switches the client when already inside tmux, attaches
# otherwise.
function swt() {
  local target="${1:-$PWD}"
  # Recover from a deleted cwd (e.g. a removed/recreated worktree) before calling
  # sesh, so brew/mise/sesh don't choke on an inaccessible current directory.
  cd -- "$target" 2>/dev/null || cd -- "$HOME"
  sesh connect "$target"
}
