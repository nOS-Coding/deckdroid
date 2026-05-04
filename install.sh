#!/usr/bin/env bash
# TermuxDeck OS Installer v1.1.0
# MIT License | https://github.com/TERMUXDECK_USER/termuxdeck
set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────
TERMUXDECK_USER="nOS-Coding"
TDECK_VERSION="1.1.0"
TDECK_HOME="$HOME/.termuxdeck"
TDECK_REPO="https://$TERMUXDECK_USER.github.io/termuxdeck"

GITHUB_RAW="https://raw.githubusercontent.com/$TERMUXDECK_USER/termuxdeck/main"
LOG_FILE="$TDECK_HOME/logs/install.log"

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log()  { echo -e "${GREEN}[tdeck]${RESET} $*"; echo "$(date -u +%FT%TZ) [INFO] $*" >> "$LOG_FILE" 2>/dev/null || true; }
warn() { echo -e "${YELLOW}[warn]${RESET}  $*"; echo "$(date -u +%FT%TZ) [WARN] $*" >> "$LOG_FILE" 2>/dev/null || true; }
err()  { echo -e "${RED}[error]${RESET} $*" >&2; echo "$(date -u +%FT%TZ) [ERROR] $*" >> "$LOG_FILE" 2>/dev/null || true; }
die()  { err "$*"; exit 1; }

banner() {
  echo -e "${CYAN}"
  cat <<'EOF'
  ██████╗██████╗ ███████╗ ██████╗██╗  ██╗:
      ██╔══╝██╔══██╗██╔════╝██╔════╝██║ ██╔╝:
      ██║   ██║  ██║█████╗  ██║     █████╔╝ 
      ██║   ██║  ██║██╔══╝  ██║     ██╔═██╗ 
      ██║   ██████╔╝███████╗╚██████╗██║  ██╗:
      ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝:
  TermuxDeck OS v$TDECK_VERSION — Any device. Any arch. One terminal.
EOF
  echo -e "${RESET}"
}

# ─── Pre-flight checks ────────────────────────────────────────────────────────
check_termux() {
  if [ -z "${PREFIX:-}" ] || [ ! -d "$PREFIX" ]; then
    die "This installer must be run inside Termux."
  fi
  log "Termux environment verified."
}

# ─── Fetch and Deploy ─────────────────────────────────────────────────────────
# Downloads a file from the repository and places it in the target location.
# Idempotent: skips if file already exists unless --force is used.
fetch_and_deploy() {
  local source_path="$1"
  local target_path="$2"
  local make_executable="${3:-false}"

  if [ -f "$target_path" ] && [ "${FORCE_INSTALL:-false}" != "true" ]; then
    log "  - Skipping $source_path (already exists)"
    return 0
  fi

  log "  - Deploying $source_path ..."
  mkdir -p "$(dirname "$target_path")"
  
  if ! curl -sSL "$GITHUB_RAW/$source_path" -o "$target_path"; then
    warn "  ! Failed to download $source_path. Check your internet or TERMUXDECK_USER."
    return 1
  fi

  if [ "$make_executable" = "true" ]; then
    chmod +x "$target_path"
  fi
}

# ─── Directory Bootstrap ──────────────────────────────────────────────────────
bootstrap_dirs() {
  log "Bootstrapping directories..."
  local dirs=(
    "$TDECK_HOME/logs"
    "$TDECK_HOME/tools"
    "$TDECK_HOME/profiles"
    "$TDECK_HOME/zshrc.d"
    "$TDECK_HOME/notes/.trash"
  )
  for d in "${dirs[@]}"; do
    mkdir -p "$d"
  done
  log "TermuxDeck directory structure initialized at $TDECK_HOME"
}

# ─── Package Installation ─────────────────────────────────────────────────────
install_base_packages() {
  log "Updating package lists..."
  pkg update -y 2>/dev/null | tail -n 5

  local pkgs=(zsh starship fastfetch nano python git curl wget nodejs w3m termux-api)
  log "Installing core dependencies: ${pkgs[*]}"
  for p in "${pkgs[@]}"; do
    if command -v "$p" &>/dev/null; then
       log "  ✓ $p already installed"
    else
       pkg install -y "$p" || warn "Failed to install $p"
    fi
  done
}

install_python_deps() {
  log "Installing Python essentials..."
  pip install --quiet requests rich psutil python-dotenv 2>/dev/null || warn "Python dependencies failed"
}

# ─── Component Deployment ─────────────────────────────────────────────────────
deploy_tools() {
  local deck_tools=(
    "deckbat" "deckping" "deckid" "deckclock" "deckwifi" "decklocate" "decksniff"
    "decknote" "deckbrowse" "deckdisk" "decklog" "deckclean" "deckupdate" "decktheme"
    "deckhelp" "deckmenu" "decksetup" "deckai"
  )
  local repo_tools=(
    "tdeckconf" "tdeckprof" "termuxdeck-doctor" "termuxdeck-sync"
    "termuxdeck-web" "termuxdeck-plugin" "termuxdeck-vault"
  )
  local configs=(
    "starship.toml" "fastfetch.jsonc" "ascii-logo.txt"
  )
  log "Deploying deck tools..."
  for tool in "${deck_tools[@]}"; do
    fetch_and_deploy "$tool" "$TDECK_HOME/tools/$tool" true
  done
  log "Deploying repo tools..."
  for tool in "${repo_tools[@]}"; do
    fetch_and_deploy "$tool" "$TDECK_HOME/tools/$tool" true
  done
  log "Deploying config files..."
  for cfg in "${configs[@]}"; do
    fetch_and_deploy "$cfg" "$TDECK_HOME/$cfg"
  done
  log "Deploying profile themes..."
  mkdir -p "$TDECK_HOME/themes"
  for theme in hacker developer writer crypto radio hamradio iot base; do
    fetch_and_deploy "${theme}.toml" "$TDECK_HOME/themes/${theme}.toml"
    fetch_and_deploy "${theme}.quotes" "$TDECK_HOME/themes/${theme}.quotes"
  done
}

deploy_profiles() {
  log "Deploying profiles..."
  local profiles=(
    "hacker.sh" "developer.sh" "writer.sh"
    "crypto.sh" "radio.sh" "hamradio.sh" "iot.sh"
  )
  for p in "${profiles[@]}"; do
    fetch_and_deploy "$p" "$TDECK_HOME/profiles/$p" true
  done
}

deploy_configs() {
  log "Deploying configurations..."
  fetch_and_deploy "starship.toml" "$TDECK_HOME/starship.toml"
  fetch_and_deploy "fastfetch.jsonc" "$TDECK_HOME/fastfetch.jsonc"
  fetch_and_deploy "ascii-logo.txt" "$TDECK_HOME/ascii-logo.txt"
  fetch_and_deploy "boot.sh" "$TDECK_HOME/boot.sh" true
  fetch_and_deploy "quotes.txt" "$TDECK_HOME/quotes.txt"
  fetch_and_deploy ".zshrc" "$HOME/.zshrc"

  # Initialize config.json if not present
  local cfg="$TDECK_HOME/config.json"
  if [ ! -f "$cfg" ]; then
    log "  - Initializing default config.json"
    cat > "$cfg" <<EOF
{
  "version": "$TDECK_VERSION",
  "hostname": "tdeck-$(printf "%04x" $RANDOM)",
  "user": "${USER:-deck}",
  "profiles": [],
  "timezone": "UTC",
  "editor": "nano",
  "theme": {
    "name": "cyberpunk",
    "prompt_color": "green"
  },
  "ssh": {
    "enabled": false,
    "port": 8022
  },
  "ai": {
    "selection": "",
    "installed": []
  },
  "motd": {
    "quotes_enabled": true
  },
  "deck": {
    "tools": ["decklocate","deckclock","deckping","decksniff","deckid","deckbat","deckwifi"]
  }
}
EOF
  fi
}

# ─── Shell Integration ────────────────────────────────────────────────────────
deploy_zshrc() {
  log "Configuring Zsh integration..."
  local target="$HOME/.zshrc"
  
  if [ -f "$target" ] && grep -q "TermuxDeck OS" "$target"; then
    log "  - Zsh integration already present"
    return
  fi

  # Backup existing .zshrc
  [ -f "$target" ] && cp "$target" "$target.bak"

  cat >> "$target" <<EOF

# ─── TermuxDeck OS ───────────────────────────────────────────────────────────
export TDECK_HOME="$TDECK_HOME"
export PATH="\$TDECK_HOME/tools:\$PATH"

# Load Starship
export STARSHIP_CONFIG="\$TDECK_HOME/starship.toml"
eval "\$(starship init zsh)"

# Boot sequence
[ -f "\$TDECK_HOME/boot.sh" ] && source "\$TDECK_HOME/boot.sh"
# ─────────────────────────────────────────────────────────────────────────────
EOF
  log "  ✓ .zshrc updated."
}

symlink_binaries() {
  log "Symlinking tools to prefix/bin..."
  local bin_dir="$PREFIX/bin"
  for tool in "$TDECK_HOME/tools"/*; do
    [ -e "$tool" ] || continue
    local name=$(basename "$tool")
    if [ ! -e "$bin_dir/$name" ]; then
      ln -sf "$tool" "$bin_dir/$name"
      log "  - Linked $name"
    fi
  done
}

# ─── Main Execution ───────────────────────────────────────────────────────────
main() {
  banner
  check_termux
  
  bootstrap_dirs
  install_base_packages
  install_python_deps
  
  deploy_tools
  deploy_profiles
  deploy_configs
  deploy_zshrc
  symlink_binaries

  echo ""
  echo -e "${GREEN}${BOLD}✓ TermuxDeck OS v$TDECK_VERSION installed successfully!${RESET}"
  echo -e "  Repo: $TDECK_REPO"
  echo ""
  echo -e "  Launch 'zsh' to enter the deck."
  echo ""
}

# Force install flag support
[ "${1:-}" = "--force" ] && FORCE_INSTALL=true

main
