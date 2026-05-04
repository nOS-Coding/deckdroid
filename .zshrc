# TermuxDeck OS v1.1 — Base Zsh Configuration
# MIT License | https://github.com/TERMUXDECK_USER/termuxdeck/

# ── Environment ────────────────────────────────────────────────────────
export TDECK_HOME="$HOME/.termuxdeck"
export STARSHIP_CONFIG="$TDECK_HOME/starship.toml"

# ── PATH ─────────────────────────────────────────────────────────────────
export PATH="$TDECK_HOME/tools:$HOME/.npm-global/bin:$PATH"

# ── Starship Prompt ────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── Aliases ─────────────────────────────────────────────────────────────
alias tdeckconf="$TDECK_HOME/tools/tdeckconf"
alias deckbat="$TDECK_HOME/tools/deckbat"
alias deckping="$TDECK_HOME/tools/deckping"
alias deckid="$TDECK_HOME/tools/deckid"
alias deckclock="$TDECK_HOME/tools/deckclock"
alias deckwifi="$TDECK_HOME/tools/deckwifi"
alias decklocate="$TDECK_HOME/tools/decklocate"
alias decksniff="$TDECK_HOME/tools/decksniff"
alias decknote="$TDECK_HOME/tools/decknote"
alias deckbrowse="$TDECK_HOME/tools/deckbrowse"
alias tdock="$TDECK_HOME/tools/termuxdeck-doctor"

# ── History ────────────────────────────────────────────────────────────
export HISTFILE="$TDECK_HOME/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# ── Tab Completion ────────────────────────────────────────────────────
autoload -U compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Z:a-z}'

# ── Boot Sequence ─────────────────────────────────────────────────────
[ -f "$TDECK_HOME/boot.sh" ] && source "$TDECK_HOME/boot.sh"
