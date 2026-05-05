#!/usr/bin/env bash
# DeckDroid — Hacker Profile installer
set -euo pipefail
HACKER_PKGS=(nmap netcat-openbsd curl wget tcpdump tshark whois dnsutils)
echo ""
echo "DeckDroid — Hacker Profile"
echo "────────────────────────────────────────────────"
echo "This profile installs security research tools."
echo "Use ONLY on networks and systems you own or have"
echo "explicit written permission to test."
echo "────────────────────────────────────────────────"
read -r -p "Type 'accept' to continue: " ACCEPT
if [ "$ACCEPT" != "accept" ]; then
  echo "Aborted."; exit 1
fi
echo "$(date -u +%FT%TZ) disclaimer accepted" >> "$HOME/.deckdroid/logs/disclaimer.log"
for p in "${HACKER_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable on $(uname -m))"
done
python3 "$HOME/.deckdroid/tools/ddeckconf" set profiles hacker 2>/dev/null || true
echo "✓ Hacker Profile installed."
