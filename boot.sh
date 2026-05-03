#!/usr/bin/env zsh
# TermuxDeck OS — boot.sh
# Sourced by .zshrc on every new session

TDECK_HOME="$HOME/.termuxdeck"
TDECK_CFG="$TDECK_HOME/config.json"

# ─── Read config via Python (available in base install) ───────────────────────
_tdeck_get() {
  python3 -c "
import json, sys
try:
    with open('$TDECK_CFG') as f:
        c = json.load(f)
    keys = '$1'.split('.')
    v = c
    for k in keys:
        v = v[k]
    print(v)
except: pass
" 2>/dev/null
}

# Export TDECK_ env vars
export TDECK_HOSTNAME=$(_tdeck_get hostname)
export TDECK_USER=$(_tdeck_get user)
export TDECK_THEME=$(_tdeck_get theme.name)
export TDECK_EDITOR=$(_tdeck_get editor)
export EDITOR="${TDECK_EDITOR:-nano}"

# ─── Boot log ─────────────────────────────────────────────────────────────────
echo "{\"time\":\"$(date -u +%FT%TZ)\",\"event\":\"session_start\",\"hostname\":\"$TDECK_HOSTNAME\",\"theme\":\"$TDECK_THEME\"}" \
  >> "$TDECK_HOME/logs/boot.log" 2>/dev/null || true

# ─── Fastfetch ────────────────────────────────────────────────────────────────
if command -v fastfetch &>/dev/null; then
  # Use narrow logo variant on small terminals
  if [ "${COLUMNS:-80}" -lt 50 ]; then
    fastfetch --logo-type none 2>/dev/null || true
  else
    fastfetch 2>/dev/null || true
  fi
fi

# ─── MOTD ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "\033[1;32m── TermuxDeck OS \033[0;36mv$(python3 -c "import json; print(json.load(open('$TDECK_CFG'))['version'])" 2>/dev/null || echo '?')\033[0m  ·  \033[1;33m$TDECK_HOSTNAME\033[0m  ·  $(date '+%a %b %d %H:%M')"

# Active profiles
PROFILES=$(python3 -c "
import json
try:
    c = json.load(open('$TDECK_CFG'))
    p = c.get('profiles', [])
    print(' '.join(p) if p else 'base')
except: print('base')
" 2>/dev/null)
echo -e "\033[0;90mprofiles:\033[0m $PROFILES"

# Random quote
QUOTES="$TDECK_HOME/quotes.txt"
if [ -f "$QUOTES" ]; then
  NLINES=$(wc -l < "$QUOTES")
  if [ "$NLINES" -gt 0 ]; then
    RAND_LINE=$((RANDOM % NLINES + 1))
    QUOTE=$(sed -n "${RAND_LINE}p" "$QUOTES")
    echo -e "\033[0;90m\"$QUOTE\"\033[0m"
  fi
fi
echo ""
