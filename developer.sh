#!/usr/bin/env bash
# TermuxDeck OS — Developer Profile installer
set -euo pipefail
DEV_PKGS=(git python nodejs openssh nano)
echo "Installing Developer Profile..."
for p in "${DEV_PKGS[@]}"; do
  pkg install -y "$p" 2>/dev/null && echo "  ✓ $p" || echo "  ✗ $p"
done
mkdir -p "$HOME/dev"
# .gitconfig template if not present
if [ ! -f "$HOME/.gitconfig" ]; then
  cat > "$HOME/.gitconfig" <<'GITCFG'
[core]
  editor = nano
[color]
  ui = auto
[pull]
  rebase = false
GITCFG
fi
echo "✓ Developer Profile installed. Workspace: ~/dev"
