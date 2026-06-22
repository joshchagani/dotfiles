# hunk - terminal diff reviewer (reference for the assistant)

hunk (npm package `hunkdiff`) is a review-first terminal diff VIEWER. It reviews
changesets; it does NOT manage commits/branches/stacks (git-spice does that). It
is set as the user's git pager, so `git diff` / `git show` open in hunk.

## Commands
- `hunk diff`        review the working-tree changeset (uncommitted), incl. untracked
- `hunk show [REV]`  review a commit (default HEAD)
- `hunk patch FILE`  review a patch file;  `... -` reads a patch from stdin
- `hunk`             show help;  `hunk --version`
- `hunk skill path`  print the path to hunk's agent skill (for Claude)

## In the TUI
- Press `?` for the full keymap (authoritative source for keys).
- `c` adds a human inline comment/note on the focused line.
- Watch mode (config `watch = true`) auto-reloads as files change.
- To leave the tmux window without quitting hunk, switch windows (prefix + number).

## Agent (Claude) review loop -- via the live-session CLI
- `hunk session review --json`                          inspect file/hunk structure
- `hunk session navigate --repo . --next-comment`       walk to the next note (or --prev-comment)
- `hunk session comment list --repo . --type user`      read the human's `c` notes
- `hunk session comment add --repo . --file F --new-line N --summary "..."`  leave a note
- Flow: the user presses `c` to leave questions/changes -> Claude loads the hunk
  skill, reads the notes with `comment list`, and acts on them.
