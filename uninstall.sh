#!/usr/bin/env bash
# DeckDroid Uninstaller v1.1.0
# MIT License | https://github.com/nOS-Coding/deckdroid
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────
DDROID_HOME="$HOME/.deckdroid"
DDROID_USER="nOS-Coding"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${GREEN}[droid]${RESET} $*"; }
warn() { echo -e "${YELLOW}[warn]${RESET}  $*"; }
err()  { echo -e "${RED}[error]${RESET} $*" >&2; }

banner() {
  echo -e "${CYAN}"
  cat <<'EOF'
    ██████╗ ███████╗ ██████╗██╗  ██╗██████╗ ██████╗  ██████╗ ██╗██████╗ 
    ██╔══██╗██╔════╝██╔════╝██║ ██╔╝██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗
    ██║  ██║█████╗  ██║     █████╔╝ ██║  ██║██████╔╝██║   ██║██║██║  ██║
    ██║  ██║██╔══╝  ██║     ██╔═██╗ ██║  ██║██╔══██╗██║   ██║██║██║  ██║
    ██████╔╝███████╗╚██████╗██║  ██╗██████╔╝██║  ██║╚██████╔╝██║██████╔╝
    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝ 
EOF
  echo -e "  DeckDroid Uninstaller — Removing all DeckDroid components"
  echo -e "${RESET}"
}

# ─── Confirmation ─────────────────────────────────────────────────────────────
confirm_uninstall() {
  echo -e "${YELLOW}This will remove ALL DeckDroid components:${RESET}"
  echo -e "  - $DDROID_HOME (config, tools, themes, logs, etc.)"
  echo -e "  - Symlinks in $PREFIX/bin"
  echo -e "  - DeckDroid entries from ~/.zshrc"
  echo ""
  echo -n "Are you sure you want to continue? (yes/no): "
  read -r response
  case "$response" in
    yes|y|Y) return 0 ;;
    *) echo -e "${CYAN}Cancelled.${RESET}"; exit 0 ;;
  esac
}

# ─── Remove Symlinks ──────────────────────────────────────────────────────────
remove_symlinks() {
  log "Removing symlinks from $PREFIX/bin..."
  local tools=(
    "deckbat" "deckping" "deckid" "deckclock" "deckwifi" "decklocate" "decksniff"
    "decknote" "deckbrowse" "deckdisk" "decklog" "deckclean" "deckupdate" "decktheme"
    "deckhelp" "deckmenu" "decksetup" "deckai"
    "ddeckconf" "tdeckprof" "deckdroid-doctor" "deckdroid-sync"
    "deckdroid-web" "deckdroid-plugin" "deckdroid-vault"
  )
  
  for tool in "${tools[@]}"; do
    if [ -L "$PREFIX/bin/$tool" ]; then
      rm -f "$PREFIX/bin/$tool"
      log "  - Removed symlink: $tool"
    fi
  done
}

# ─── Clean .zshrc ────────────────────────────────────────────────────────────
clean_zshrc() {
  log "Cleaning ~/.zshrc..."
  local zshrc="$HOME/.zshrc"
  
  if [ -f "$zshrc" ]; then
    # Create backup
    cp "$zshrc" "$zshrc.bak.$(date +%s)"
    
    # Remove DeckDroid block
    if grep -q "DeckDroid" "$zshrc"; then
      # Use awk to remove the DeckDroid block
      awk '
        /^# ─── DeckDroid / { skip=1 }
        skip && /^# ──────────────────────────────────────────────────────────/ { skip=0; next }
        !skip { print }
      ' "$zshrc" > "$zshrc.tmp"
      
      mv "$zshrc.tmp" "$zshrc"
      log "  - Removed DeckDroid entries from .zshrc"
      log "  - Backup saved as .zshrc.bak.*"
    else
      log "  - No DeckDroid entries found in .zshrc"
    fi
  fi
}

# ─── Remove DeckDroid Directory ──────────────────────────────────────────────
remove_deckdroid_home() {
  if [ -d "$DDROID_HOME" ]; then
    log "Removing $DDROID_HOME..."
    rm -rf "$DDROID_HOME"
    log "  - DeckDroid directory removed"
  else
    warn "  - $DDROID_HOME not found (already removed?)"
  fi
}

# ─── Main Execution ───────────────────────────────────────────────────────────
main() {
  banner
  confirm_uninstall
  
  echo ""
  log "Starting uninstallation..."
  
  remove_symlinks
  clean_zshrc
  remove_deckdroid_home
  
  echo ""
  echo -e "${GREEN}${BOLD}✓ DeckDroid has been completely uninstalled!${RESET}"
  echo -e "  To finish cleanup, restart your shell or run: ${CYAN}zsh${RESET}"
  echo ""
}

main
