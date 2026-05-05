#!/usr/bin/env bash
# build-repo.sh — Build the apt repository structure for GitHub Pages
set -euo pipefail

REPO_DIR="apt-repo"
DIST_DIR="dist"
COMPONENT="main"
CODENAME="deckdroid"

ARCH_MAP=(aarch64 arm x86_64 i686)

mkdir -p "$REPO_DIR/dists/$CODENAME/$COMPONENT"

for ARCH in "${ARCH_MAP[@]}"; do
  PKG_DIR="$REPO_DIR/dists/$CODENAME/$COMPONENT/binary-$ARCH"
  mkdir -p "$PKG_DIR"
  POOL_DIR="$REPO_DIR/pool/$COMPONENT"
  mkdir -p "$POOL_DIR"

  # Copy .deb files into pool
  if [ -d "$DIST_DIR" ]; then
    for deb in "$DIST_DIR"/*_"$ARCH".deb; do
      [ -f "$deb" ] || continue
      cp "$deb" "$POOL_DIR/"
      echo "  Pooled: $(basename "$deb")"
    done
  fi

  # Generate Packages file
  if command -v dpkg-scanpackages &>/dev/null; then
    dpkg-scanpackages --arch "$ARCH" "$POOL_DIR" /dev/null > "$PKG_DIR/Packages" 2>/dev/null || true
    gzip -9c "$PKG_DIR/Packages" > "$PKG_DIR/Packages.gz"
    bzip2 -9c "$PKG_DIR/Packages" > "$PKG_DIR/Packages.bz2"
    echo "  Generated Packages for $ARCH"
  fi
done

# Generate Release file
cat > "$REPO_DIR/dists/$CODENAME/Release" <<EOF
Origin: DeckDroid
Label: DeckDroid
Suite: $CODENAME
Codename: $CODENAME
Version: 1.1.0
Architectures: ${ARCH_MAP[*]}
Components: $COMPONENT
Description: DeckDroid apt repository
Date: $(date -Ru)
EOF

# Add checksums
if [ -d "$REPO_DIR/dists/$CODENAME" ]; then
  cd "$REPO_DIR/dists/$CODENAME"
  for f in $(find . -name "Packages*" -o -name "Contents*"); do
    echo " $(md5sum "$f" | awk '{print $1}') $(wc -c < "$f") $f" >> Release
  done
  cd - > /dev/null
fi

# GPG sign Release (requires GPG key in CI)
if gpg --list-secret-keys &>/dev/null; then
  gpg --clearsign -o "$REPO_DIR/dists/$CODENAME/InRelease" "$REPO_DIR/dists/$CODENAME/Release"
  gpg -abs -o "$REPO_DIR/dists/$CODENAME/Release.gpg" "$REPO_DIR/dists/$CODENAME/Release"
  echo "  GPG signed Release"
else
  echo "  Warning: No GPG key found, skipping signing"
fi

# Export GPG public key
gpg --export --armor > "$REPO_DIR/deckdroid.gpg.key" 2>/dev/null || true

echo "✓ apt repository built at $REPO_DIR/"
