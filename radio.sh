#!/usr/bin/env bash
# TermuxDeck OS — Radio & SDR Profile
set -euo pipefail

RADIO_PKGS=(rtl-sdr sox multimon-ng)
echo "Installing Radio & SDR Profile..."

for p in "${RADIO_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

# Note: dump1090 is often built from source in Termux or available in community repos
echo "  ! dump1090 may require manual build or community repo."

echo "✓ Radio Profile installed."
