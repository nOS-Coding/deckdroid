#!/usr/bin/env zsh
# DeckDroid — boot.sh
# Sourced by .zshrc on every new session

DDROID_HOME="$HOME/.deckdroid"
DDROID_CFG="$DDROID_HOME/config.json"
QUOTES_DIR="$DDROID_HOME/themes"

# ─── Colors ────────────────────────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; C='\033[0;36m'; B='\033[1m'; DIM='\033[2m'; N='\033[0m'

# ─── Config reader ────────────────────────────────────────────────────────────
_ddroid_get() {
  python3 -c "
import json, sys
try:
  with open('$DDROID_CFG') as f: c = json.load(f)
  keys = '$1'.split('.'); v = c
  for k in keys: v = v[k]
  print(v)
except: pass
" 2>/dev/null
}

# Export config to env
export DDROID_HOSTNAME=$(_ddroid_get hostname)
export DDROID_USER=$(_ddroid_get user)
export DDROID_THEME=$(_ddroid_get theme.name)
export DDROID_EDITOR=$(_ddroid_get editor)
export EDITOR="${DDROID_EDITOR:-nano}"

# Get active profile (first one)
DDROID_PROFILE=$(python3 -c "
import json
try:
  c = json.load(open('$DDROID_CFG'))
  p = c.get('profiles', [])
  print(p[0] if p else 'base')
except: print('base')
" 2>/dev/null)

# ─── Boot log ─────────────────────────────────────────────────────────────────
echo "{\"time\":\"$(date -u +%FT%TZ)\",\"event\":\"session_start\",\"hostname\":\"$DDROID_HOSTNAME\",\"profile\":\"$DDROID_PROFILE\"}" \
  >> "$DDROID_HOME/logs/boot.log" 2>/dev/null || true

# ─── ASCII Logo ───────────────────────────────────────────────────────────────
LOGO_FILE="$DDROID_HOME/ascii-logo.txt"
if [ -f "$LOGO_FILE" ]; then
  # Color logo based on theme
  case "$DDROID_THEME" in
    blood) echo -e "${R}"; cat "$LOGO_FILE" ;;
    ghost) echo -e "${DIM}"; cat "$LOGO_FILE" ;;
    nord|ocean) echo -e "${C}"; cat "$LOGO_FILE" ;;
    dracula|monokai) echo -e "${M:-"\033[0;35m"}"; cat "$LOGO_FILE" ;;
    *) echo -e "${G}"; cat "$LOGO_FILE" ;;
  esac
  echo -e "${N}"
fi

# ─── Profile-specific quote ─────────────────────────────────────────────────
PROFILE_QUOTE_FILE="$QUOTES_DIR/${DDROID_PROFILE}.quotes"
if [ -f "$PROFILE_QUOTE_FILE" ]; then
  NLINES=$(wc -l < "$PROFILE_QUOTE_FILE")
  RAND_LINE=$((RANDOM % NLINES + 1))
  QUOTE=$(sed -n "${RAND_LINE}p" "$PROFILE_QUOTE_FILE")
  echo -e "${C}${B}▸ ${QUOTE}${N}"
else
  # Fallback to random general quote
  if [ -f "$DDROID_HOME/quotes.txt" ]; then
    NLINES=$(wc -l < "$DDROID_HOME/quotes.txt")
    RAND_LINE=$((RANDOM % NLINES + 1))
    QUOTE=$(sed -n "${RAND_LINE}p" "$DDROID_HOME/quotes.txt")
    echo -e "${C}${B}▸ ${QUOTE}${N}"
  fi
fi

# ─── Version & Hostname ────────────────────────────────────────────────────────
VERSION=$(_ddroid_get version)
echo -e "${B}${G}DeckDroid ${VERSION}${N} · ${B}${C}$DDROID_HOSTNAME${N} · ${B}$(date '+%a %b %d %H:%M')${N}"

# ─── One-liner System Info ───────────────────────────────────────────────────
# Device - try multiple methods
DEVICE="N/A"
if command -v getprop &>/dev/null; then
  DEVICE=$(getprop ro.product.model 2>/dev/null || hostname)
elif [ -f /system/build.prop ]; then
  DEVICE=$(grep "ro.product.model" /system/build.prop 2>/dev/null | cut -d= -f2 || hostname)
else
  DEVICE=$(hostname 2>/dev/null || echo "Unknown")
fi

# RAM
RAM_INFO="N/A"
if command -v free &>/dev/null; then
  RAM_INFO=$(free -h 2>/dev/null | awk '/Mem:/ {print $3 "/" $2}' | tr -d ' ' || echo "N/A")
fi

# CPU Load
CPU_LOAD="N/A"
CPU_LOAD=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',' || echo "N/A")

# Storage
STORAGE="N/A"
STORAGE=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $3 "/" $2}' | tr -d ' ' || echo "N/A")

# Battery - requires termux-api package
BAT="N/A"
if command -v termux-battery-status &>/dev/null; then
  BAT=$(termux-battery-status 2>/dev/null | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    pct = d.get('percentage', 'N/A')
    status = d.get('status', '')
    print(f\"{pct}% {status}\")
except Exception as e:
    pass
" 2>/dev/null || echo "N/A")
else
  # Fallback: try reading from /sys/class/power_supply/
  if [ -f /sys/class/power_supply/battery/capacity ]; then
    BAT=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)% || echo "N/A"
  fi
fi

echo -e "${DIM}│${N} ${C}$DEVICE${N} · RAM: ${Y}$RAM_INFO${N} · CPU: ${Y}$CPU_LOAD${N} · Disk: ${Y}$STORAGE${N} · ⚡ ${G}$BAT${N}"
echo ""