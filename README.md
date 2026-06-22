# dotfiles

My macOS dev environment, managed with [chezmoi](https://chezmoi.io). Terminal-first:
Ghostty + tmux + Helix, with sesh, yazi, hunk, and a local-LLM helper popup.

## New machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply joshchagani/dotfiles
```

chezmoi prompts for the **ollama model** for the `prefix+Q` popup
(`qwen3-coder:30b`, `qwen3.5:9b`, or `none` to disable it), then places the configs
and runs the bootstrap (`run_once_after_install-tools.sh`), which installs the tools
via Homebrew + mise. Afterward, in tmux press **`prefix + I`** to install tmux plugins.

> On a low-RAM machine, pick `qwen3.5:9b` or `none` at the prompt — the rest of the
> setup is unaffected.

## What's inside

| Tool | Role | Config |
| ---- | ---- | ------ |
| **zsh** | shell; env in `.zprofile`/`.zshenv`, interactive in `.zshrc` (fzf, zoxide, sesh, spaceship) | `dot_z*` |
| **tmux** | multiplexer; prefix `Ctrl-b` | `dot_config/tmux/tmux.conf.tmpl` |
| **sesh** | project switcher (`prefix+T`) + per-project layout | `dot_config/sesh/` |
| **Helix** | editor (`hx`); LSPs + format-on-save (Oxfmt/ruff/ty) | `dot_config/helix/` |
| **yazi** | terminal file manager (`y`) | `dot_config/yazi/` |
| **hunk** | review-first diff viewer; set as the git pager | `dot_config/hunk/` |
| **ask-tmux** | local-LLM popup (`prefix+Q`) over ollama | `dot_config/ollama/` |

## Cheat sheet

**tmux** (prefix = `Ctrl-b`)
- `prefix T` — sesh project picker (`Ctrl-d` in it kills a session)
- `prefix |` / `-` — split; `prefix h/j/k/l` — move panes (repeatable)
- `prefix Shift-H/J/K/L` — resize; `prefix z` — zoom a pane; `prefix Space` — cycle layouts
- `prefix Q` — local-LLM popup; `prefix r` — reload config; `prefix d` — detach

**Helix** (`hx`) — selection-first (kakoune-style: select, *then* act)
- `Space f` file picker · `Space e` file explorer · `Space /` global search · `Space b` buffers
- `Ctrl-y` yazi picker · `Space r` LSP rename · `mi(`/`ma(` inside/around · `C` cursor below
- `hx --tutor` for the built-in interactive tutorial

**hunk** — `git diff`/`git show` open it (it's the git pager); `?` for its keymap.
Review loop: open it, `c` to leave inline comments, then ask Claude to address them.

## The `prefix+Q` popup (local LLM)

A tmux popup that answers tmux/Helix/hunk questions, grounded in *your live config*
(it reads your actual `tmux.conf` + Helix config each time, so answers match your
real keys — never stale defaults). Backed by ollama; the model is a per-machine
choice (the `chezmoi init` prompt). `none` removes the binding entirely.

To change the model later: edit `ollamaModel` in `~/.config/chezmoi/chezmoi.toml`,
then `ollama create ask-tmux -f ~/.config/ollama/ask-tmux.Modelfile`.

## Day-to-day chezmoi

- `chezmoi edit <file>` — edit a managed file · `chezmoi apply` — apply changes
- `chezmoi update` — pull the repo + apply · `chezmoi diff` — preview changes

## Design notes (the non-obvious "why")

- **Global tooling = mise, not `pnpm -g`/`npm -g`.** LSP servers etc. install via
  `mise use -g npm:<pkg>`. mise has no pnpm backend, so "mise + pnpm" isn't a thing.
- **tmux-continuum auto-restore is OFF.** sesh builds layouts on connect; a replayed
  snapshot fought that. Manual resurrect (`prefix Ctrl-s`/`Ctrl-r`) still works.
- **hunk is the git pager** (`core.pager = hunk pager`); Helix opens files via
  `Ctrl-y` (yazi `--chooser-file`) or the built-in `Space e`.
- **FE format-on-save = Oxfmt** (the nucleus repo's `vp fmt` engine) via
  `helix/oxfmt-stdin.sh`, so editor output matches CI; Python = ruff + ty.
- **Paths templatized** with `{{ .chezmoi.homeDir }}` for portability.
- Refresh the Helix keymap reference after a Helix upgrade:
  `curl -fsSL https://raw.githubusercontent.com/helix-editor/helix/$(hx --version | awk '{print $2}')/book/src/keymap.md -o ~/.config/ollama/helix-keymap.md`
