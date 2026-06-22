#!/usr/bin/env bash
# Interactive tmux/Helix Q&A popup (bound to prefix+Q via display-popup).
# Multi-turn: the conversation keeps context, so you can ask follow-ups.
# The FIRST question is sent together with your LIVE config (so answers reflect
# your current bindings, never stale); follow-ups continue the same chat.
# Backed by the `ask-tmux` Ollama model via /api/chat (think off, 15m keep-alive).
#
# Close the popup with:  Ctrl-D  ·  Ctrl-C  ·  or type  /q   (also: exit / quit / blank)
set -uo pipefail
MODEL="ask-tmux"
API="http://${OLLAMA_HOST:-127.0.0.1:11434}/api/chat"

trap 'printf "\n"; exit 0' INT   # Ctrl-C closes cleanly

# If the model isn't built on this machine, show how to enable it (don't error).
if ! ollama show "$MODEL" >/dev/null 2>&1; then
  printf '\033[1;33mNo local model on this machine.\033[0m\n'
  printf 'Enable it with:\n  ollama pull <model> && ollama create %s -f ~/.config/ollama/ask-tmux.Modelfile\n' "$MODEL"
  printf '\033[2m(any key to close)\033[0m'; read -rsn1 _ 2>/dev/null || true
  exit 0
fi

# Your live config, bundled with the first question below.
config="$(
  printf '===== ~/.config/tmux/tmux.conf =====\n'; cat "$HOME/.config/tmux/tmux.conf" 2>/dev/null
  printf '\n===== ~/.config/helix/config.toml (the user overrides only) =====\n'; cat "$HOME/.config/helix/config.toml" 2>/dev/null
  printf '\n===== Helix keymap (curated, v25.07.1) =====\n'; cat "$HOME/.config/ollama/helix-ref.md" 2>/dev/null
  printf '\n===== Helix supplement (file explorer, vim differences, multi-cursor) =====\n'; cat "$HOME/.config/ollama/helix-extra.md" 2>/dev/null
  printf '\n===== Learning Helix (concepts & workflows) =====\n'; cat "$HOME/.config/ollama/helix-learn.md" 2>/dev/null
  printf '\n===== hunk (terminal diff reviewer) reference =====\n'; cat "$HOME/.config/ollama/hunk-ref.md" 2>/dev/null
)"

messages='[]'
first=1

# A random "did you know" tip across tmux / Helix / sesh / hunk, shown on open.
tips=(
  'Helix: select a word with `w`, then `ms"` to surround it with quotes.'
  'Helix: `mi(` selects inside the parens -- then `c` to change it.'
  'Helix: `%` selects the whole file; then `s` drops a cursor on every regex match.'
  'Helix: `C` adds a cursor on the next line for quick multi-cursor edits.'
  'Helix: `Space r` does a semantic LSP rename across the file.'
  'Helix: `Space e` opens a file-tree explorer; `Space f` is the fuzzy file picker.'
  'Helix: `;` collapses a multi-selection back to a single cursor.'
  'Helix: run `hx --tutor` for a built-in interactive tutorial.'
  'tmux: `prefix z` zooms a pane to fullscreen -- press again to restore.'
  'tmux: `prefix Shift-H/J/K/L` resizes the focused pane.'
  'tmux: `prefix |` and `prefix -` split panes in the current directory.'
  'tmux: `prefix d` detaches -- the session keeps running in the background.'
  'sesh: `prefix T` opens the fuzzy project picker; `Ctrl-d` there kills a session.'
  'sesh: it ranks dirs by zoxide frecency, so your busiest projects float to the top.'
  'hunk: `git diff` opens hunk (your git pager); press `?` inside for the keymap.'
  'hunk: press `c` on a line to leave a note, then ask Claude to address your comments.'
)
tip="${tips[$((RANDOM % ${#tips[@]}))]}"
printf '\033[1;36mtmux/helix assistant\033[0m  \033[2m(/q or Ctrl-D to close)\033[0m\n'
printf '\033[2m💡 %s\033[0m\n' "$tip"

while true; do
  printf '\n\033[1;32m? \033[0m'
  IFS= read -r q || { printf '\n'; break; }                 # Ctrl-D
  case "${q//[[:space:]]/}" in ''|/q|/quit|quit|exit) break;; esac

  if [ "$first" = 1 ]; then
    content="$config"$'\n\n===== QUESTION =====\n'"$q"; first=0
  else
    content="$q"
  fi

  messages="$(jq --arg c "$content" '. + [{role:"user",content:$c}]' <<<"$messages")"
  resp="$(jq -n --arg m "$MODEL" --argjson msgs "$messages" \
            '{model:$m,messages:$msgs,stream:false,think:false,keep_alive:"15m"}' \
          | curl -s "$API" --data-binary @-)"
  answer="$(jq -r '.message.content // .error // "(no response)"' <<<"$resp")"
  printf '\033[0m%s\n' "$answer"
  messages="$(jq --arg a "$answer" '. + [{role:"assistant",content:$a}]' <<<"$messages")"
done
