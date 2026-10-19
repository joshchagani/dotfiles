if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
if command -v git-spice >/dev/null 2>&1; then eval "$(git-spice shell completion zsh)"; fi
if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi
