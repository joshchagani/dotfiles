# fzf: key bindings (Ctrl-T files, Ctrl-R history, Alt-C cd) + completion.
# fd is the engine -- fast and .gitignore-aware; bat renders the preview.
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :200 {}'"

