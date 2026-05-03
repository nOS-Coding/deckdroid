#!/usr/bin/env bash
# TermuxDeck OS — IoT & Sensor Profile
set -euo pipefail

IOT_PKGS=(minicom mosquitto-clients)
PYTHON_PKGS=(pyserial esptool)

echo ""
echo "TermuxDeck OS — IoT & Sensor Profile"
echo "────────────────────────────────────────────────"

for p in "${IOT_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

echo "Installing Python IoT tools..."
for p in "${PYTHON_PKGS[@]}"; do
  pip install "$p" --quiet && echo "  ✓ $p" || echo "  ✗ $p (pip failed)"
done

python3 "$HOME/.termuxdeck/tools/tdeckconf" set profiles iot 2>/dev/null || true
echo "✓ IoT Profile installed."
