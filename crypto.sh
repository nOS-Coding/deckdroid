#!/usr/bin/env bash
# DeckDroid — Crypto & Privacy Profile
set -euo pipefail

CRYPTO_PKGS=(gnupg age pass openssl tor)
echo "Installing Crypto & Privacy Profile..."

for p in "${CRYPTO_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

# Configure pass to use ~/.deckdroid/passwords
mkdir -p "$HOME/.deckdroid/passwords"
export PASSWORD_STORE_DIR="$HOME/.deckdroid/passwords"

# Add helper tool
cat > "$HOME/.deckdroid/tools/deckcrypt" <<'EOF'
#!/usr/bin/env bash
# deckcrypt — Privacy helpers
case "${1:-}" in
  gen)
    age-keygen -o "$HOME/.deckdroid/keys/age.key"
    echo "Generated age key: ~/.deckdroid/keys/age.key"
    ;;
  *)
    echo "Usage: deckcrypt <gen>"
    ;;
esac
EOF
chmod +x "$HOME/.deckdroid/tools/deckcrypt"

echo "✓ Crypto Profile installed."
