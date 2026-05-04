#!/usr/bin/env zsh
# TermuxDeck OS — boot.sh
# Sourced by .zshrc on every new session

TDECK_HOME="$HOME/.termuxdeck"
TDECK_CFG="$TDECK_HOME/config.json"
QUOTES_DIR="$TDECK_HOME/themes"

# ─── Colors ────────────────────────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; B='\033[1m'; DIM='\033[2m'; N='\033[0m'

# ─── Config reader ────────────────────────────────────────────────────────────
_tdeck_get() {
  python3 -c "
import json, sys
try:
  with open('$TDECK_CFG') as f: c = json.load(f)
  keys = '$1'.split('.'); v = c
  for k in keys: v = v[k]
  print(v)
except: pass
" 2>/dev/null
}

# Export config to env
export TDECK_HOSTNAME=$(_tdeck_get hostname)
export TDECK_USER=$(_tdeck_get user)
export TDECK_THEME=$(_tdeck_get theme.name)
export TDECK_EDITOR=$(_tdeck_get editor)
export EDITOR="${TDECK_EDITOR:-nano}"

# Get active profile (first one)
TDECK_PROFILE=$(python3 -c "
import json
try:
  c = json.load(open('$TDECK_CFG'))
  p = c.get('profiles', [])
  print(p[0] if p else 'base')
except: print('base')
" 2>/dev/null)

# ─── Boot log ─────────────────────────────────────────────────────────────────
echo "{\"time\":\"$(date -u +%FT%TZ)\",\"event\":\"session_start\",\"hostname\":\"$TDECK_HOSTNAME\",\"profile\":\"$TDECK_PROFILE\"}" \
  >> "$TDECK_HOME/logs/boot.log" 2>/dev/null || true

# ─── ASCII Logo ───────────────────────────────────────────────────────────────
LOGO_FILE="$TDECK_HOME/ascii-logo.txt"
if [ -f "$LOGO_FILE" ]; then
  # Color logo based on theme
  case "$TDECK_THEME" in
    blood) echo -e "${R}"; cat "$LOGO_FILE" ;;
    ghost) echo -e "${DIM}"; cat "$LOGO_FILE" ;;
    nord|ocean) echo -e "${C}"; cat "$LOGO_FILE" ;;
    dracula|monokai) echo -e "${M:-"\033[0;35m"}"; cat "$LOGO_FILE" ;;
    *) echo -e "${G}"; cat "$LOGO_FILE" ;;
  esac
  echo -e "${N}"
fi

# ─── Profile-specific quote ─────────────────────────────────────────────────
PROFILE_QUOTE_FILE="$QUOTES_DIR/${TDECK_PROFILE}.quotes"
if [ -f "$PROFILE_QUOTE_FILE" ]; then
  NLINES=$(wc -l < "$PROFILE_QUOTE_FILE")
  RAND_LINE=$((RANDOM % NLINES + 1))
  QUOTE=$(sed -n "${RAND_LINE}p" "$PROFILE_QUOTE_FILE")
  echo -e "${C}${B}▸ ${QUOTE}${N}"
else
  # Fallback to random general quote
  if [ -f "$TDECK_HOME/quotes.txt" ]; then
    NLINES=$(wc -l < "$TDECK_HOME/quotes.txt")
    RAND_LINE=$((RANDOM % NLINES + 1))
    QUOTE=$(sed -n "${RAND_LINE}p" "$TDECK_HOME/quotes.txt")
    echo -e "${C}${B}▸ ${QUOTE}${N}"
  fi
fi

# ─── Version & Hostname ────────────────────────────────────────────────────────
VERSION=$(_tdeck_get version)
echo -e "${B}${G}TermuxDeck OS ${VERSION}${N} · ${B}${C}$TDECK_HOSTNAME${N} · ${B}$(date '+%a %b %d %H:%M')${N}"

# ─── One-liner System Info ───────────────────────────────────────────────────
DEVICE=$(getprop ro.product.model 2>/dev/null || hostname)
RAM_INFO=$(free -h 2>/dev/null | awk '/Mem:/ {print $2 " used / " $3 " free"}' || echo "N/A")
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')

# Storage
STORAGE=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $2 " total, " $3 " used, " $4 " free"}' || echo "N/A")

# Battery
if command -v termux-battery-status &>/dev/null; then
  BAT=$(termux-battery-status 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f\"{d.get('percentage','N/A')}%\", d.get('status',''))" 2>/dev/null || echo "N/A")
else
  BAT="N/A"
fi

echo -e "${DIM}│${N} ${C}$DEVICE${N} · RAM: ${Y}$RAM_INFO${N} · CPU: ${Y}$CPU_LOAD${N} · Disk: ${Y}$STORAGE${N} · ⚡ ${G}$BAT${N}"
echo ""