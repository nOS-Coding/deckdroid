#!/usr/bin/env bash
# TermuxDeck OS — Crypto & Privacy Profile
set -euo pipefail

CRYPTO_PKGS=(gnupg age pass openssl tor)
echo "Installing Crypto & Privacy Profile..."

for p in "${CRYPTO_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p (unavailable)"
done

# Configure pass to use ~/.termuxdeck/passwords
mkdir -p "$HOME/.termuxdeck/passwords"
export PASSWORD_STORE_DIR="$HOME/.termuxdeck/passwords"

# Add helper tool
cat > "$HOME/.termuxdeck/tools/deckcrypt" <<'EOF'
#!/usr/bin/env bash
# deckcrypt — Privacy helpers
case "${1:-}" in
  gen)
    age-keygen -o "$HOME/.termuxdeck/keys/age.key"
    echo "Generated age key: ~/.termuxdeck/keys/age.key"
    ;;
  *)
    echo "Usage: deckcrypt <gen>"
    ;;
esac
EOF
chmod +x "$HOME/.termuxdeck/tools/deckcrypt"

echo "✓ Crypto Profile installed."
