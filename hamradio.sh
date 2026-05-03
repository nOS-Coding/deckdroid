#!/usr/bin/env bash
# TermuxDeck OS — Amateur Radio Profile
set -euo pipefail

HAM_PKGS=(hamlib)

echo ""
echo "TermuxDeck OS — Amateur Radio Profile"
echo "────────────────────────────────────────────────"

for p in "${HAM_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

python3 "$HOME/.termuxdeck/tools/tdeckconf" set profiles hamradio 2>/dev/null || true
echo "✓ Amateur Radio Profile installed."
