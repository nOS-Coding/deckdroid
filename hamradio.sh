#!/usr/bin/env bash
# DeckDroid — Amateur Radio Profile
set -euo pipefail

HAM_PKGS=(hamlib rtl-sdr sox multimon-ng)

echo ""
echo "DeckDroid — Amateur Radio Profile"
echo "────────────────────────────────────────────────"

for p in "${HAM_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

python3 "$HOME/.deckdroid/tools/ddeckconf" set profiles hamradio 2>/dev/null || true
echo "✓ Amateur Radio Profile installed."
