#!/usr/bin/env bash
# build-deb.sh — Build a .deb package for a given architecture
# Usage: bash build-deb.sh <arch>
set -euo pipefail

ARCH="${1:-aarch64}"
VERSION=$(cat VERSION 2>/dev/null || echo "1.0.0")
PKG_NAME="termuxdeck"
PKG_DIR="dist/${PKG_NAME}_${VERSION}_${ARCH}"
DATA_DIR="$PKG_DIR/data"
DEBIAN_DIR="$PKG_DIR/DEBIAN"

echo "Building termuxdeck v$VERSION for $ARCH..."

mkdir -p "$DEBIAN_DIR"
HOME_TDECK="$DATA_DIR/data/data/com.termux/files/home/.termuxdeck"
mkdir -p "$HOME_TDECK/tools"
mkdir -p "$HOME_TDECK/profiles"
mkdir -p "$DATA_DIR/data/data/com.termux/files/home/.config/fastfetch"

# Tools
TOOLS=(deckbat deckclock deckid decklocate decknote deckping decksniff deckwifi gemini tdeckconf termuxdeck-doctor termuxdeck-sync termuxdeck-web termuxdeck-plugin termuxdeck-vault)
for t in "${TOOLS[@]}"; do
  [ -f "$t" ] && cp "$t" "$HOME_TDECK/tools/"
done

# Profiles
PROFILES=(crypto.sh developer.sh hacker.sh hamradio.sh iot.sh radio.sh writer.sh)
for p in "${PROFILES[@]}"; do
  [ -f "$p" ] && cp "$p" "$HOME_TDECK/profiles/"
done

# Configs & Core
cp .zshrc "$DATA_DIR/data/data/com.termux/files/home/"
cp starship.toml "$DATA_DIR/data/data/com.termux/files/home/"
cp fastfetch.jsonc "$DATA_DIR/data/data/com.termux/files/home/.config/fastfetch/"
cp boot.sh "$HOME_TDECK/"
cp quotes.txt "$HOME_TDECK/"

# Write control file
cat > "$DEBIAN_DIR/control" <<EOF
Package: $PKG_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: nOS-Coding <maintainer@termuxdeck.dev>
Depends: zsh, starship, fastfetch, nano, python, nodejs, git, curl
Description: TermuxDeck OS — Cyberdeck OS layer for Termux
 A complete OS-layer for Termux: shell config, deck tools, boot sequence,
 theming, and profile management. Built for cyberdeck builders worldwide.
Homepage: https://github.com/nOS-Coding/termuxdeck
EOF

# Write postinst
cat > "$DEBIAN_DIR/postinst" <<'POSTINST'
#!/usr/bin/env bash
set -euo pipefail
export PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
# Run the local installer in config-only mode to bootstrap
bash "$HOME/.termuxdeck/install.sh" --config-only || true
POSTINST

# Write prerm
cat > "$DEBIAN_DIR/prerm" <<'PRERM'
#!/usr/bin/env bash
# Remove symlinks only, never touch user data in ~/.termuxdeck/
TOOLS=(deckbat deckping deckid deckwifi decklocate deckclock decksniff decknote tdeckconf termuxdeck-doctor)
for t in "${TOOLS[@]}"; do
  link="$PREFIX/bin/$t"
  [ -L "$link" ] && rm -f "$link" && echo "Removed symlink: $t"
done
PRERM

chmod 755 "$DEBIAN_DIR/postinst" "$DEBIAN_DIR/prerm"

# Build the .deb
mkdir -p dist
dpkg-deb --build "$PKG_DIR" "dist/${PKG_NAME}_${VERSION}_${ARCH}.deb" 2>/dev/null \
  || tar -czf "dist/${PKG_NAME}_${VERSION}_${ARCH}.deb.tar.gz" -C "$PKG_DIR" .

echo "✓ Built: dist/${PKG_NAME}_${VERSION}_${ARCH}.deb"
