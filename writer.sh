#!/usr/bin/env bash
# TermuxDeck OS — Writer Profile installer
set -euo pipefail
WRITER_PKGS=(mdcat pandoc wordgrinder)
echo "Installing Writer Profile..."
for p in "${WRITER_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable on $(uname -m))"
done
mkdir -p "$HOME/.termuxdeck/notes/.trash"
echo "✓ Writer Profile installed. Notes: ~/.termuxdeck/notes/"
