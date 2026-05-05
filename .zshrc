# DeckDroid v1.1 — Base Zsh Configuration
# MIT License | https://github.com/nOS-Coding/DeckDroid

# ── Environment ────────────────────────────────────────────────────────
export DDROID_HOME="$HOME/.deckdroid"
export STARSHIP_CONFIG="$DDROID_HOME/starship.toml"

# ── PATH ─────────────────────────────────────────────────────────────────
export PATH="$DDROID_HOME/tools:$HOME/.npm-global/bin:$PATH"

# ── Starship Prompt ────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── Aliases ─────────────────────────────────────────────────────────────
alias ddeckconf="$DDROID_HOME/tools/ddeckconf"
alias deckbat="$DDROID_HOME/tools/deckbat"
alias deckping="$DDROID_HOME/tools/deckping"
alias deckid="$DDROID_HOME/tools/deckid"
alias deckclock="$DDROID_HOME/tools/deckclock"
alias deckwifi="$DDROID_HOME/tools/deckwifi"
alias decklocate="$DDROID_HOME/tools/decklocate"
alias decksniff="$DDROID_HOME/tools/decksniff"
alias decknote="$DDROID_HOME/tools/decknote"
alias deckbrowse="$DDROID_HOME/tools/deckbrowse"
alias deckdroid-doctor="$DDROID_HOME/tools/deckdroid-doctor"

# ── History ────────────────────────────────────────────────────────────
export HISTFILE="$DDROID_HOME/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# ── Tab Completion ────────────────────────────────────────────────────
autoload -U compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Z:a-z}'

# ── Boot Sequence ─────────────────────────────────────────────────────
[ -f "$DDROID_HOME/boot.sh" ] && source "$DDROID_HOME/boot.sh"
