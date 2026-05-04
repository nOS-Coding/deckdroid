# TermuxDeck OS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Termux-orange.svg)](https://termux.dev/)
[![Version](https://img.shields.io/badge/Version-1.1.0--stable-green.svg)](#)

```
   ████████╗██████╗ ███████╗ ██████╗██╗  ██╗
      ██╔══╝██╔══██╗██╔════╝██╔════╝██║ ██╔╝
      ██║   ██║  ██║█████╗  ██║     █████╔╝ 
      ██║   ██║  ██║██╔══╝  ██║     ██╔═██╗ 
      ██║   ██████╔╝███████╗╚██████╗██║  ██╗
      ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝
   TermuxDeck OS v1.1.0 — Any device. Any arch. One terminal.
```

> **Any device. Any architecture. One terminal.**

**TermuxDeck OS** is a high-performance, headless OS-layer experience built entirely within the Termux userland. It transforms any Android device into a professional cyberdeck: hacker toolkit, developer workstation, or field terminal — fast, aesthetic, and under 500 MB.

---

## Quick Install

```bash
curl -sL https://nos-coding.github.io/termuxdeck/install.sh | bash
zsh
```

## First-Run Setup (Recommended)

Run `decksetup` to configure your cyberdeck:

```bash
decksetup
```

This wizard helps you set:
- **Hostname** — Your device name
- **Profile** — hacker / developer / writer / crypto / radio / iot
- **Theme** — cyberpunk / ghost / blood / nord / ocean / etc.
- **Auto-update** — Enable automatic update checks
- **Additional packages** — Install extra tools

---

## Cyberdeck Tools

| Command | Description |
|---------|-------------|
| `deckbat` | Advanced battery metrics (temp, voltage, health, alerts) |
| `deckping` | Multi-layer connectivity audit (Gateway → DNS → Internet) |
| `deckid` | Deep device identity and network footprint |
| `deckwifi` | WiFi scanner with signal bars and security detection |
| `decklocate` | GPS + cell tower triangulation via Termux:API |
| `deckclock` | Multi-timezone world clock with NTP sync check |
| `decksniff` | tcpdump wrapper with preset capture profiles |
| `decknote` | Plain-text markdown notes system |
| `deckbrowse` | Universal terminal browser (w3m/lynx/browsh) |
| `deckdisk` | Disk management (list, mount, unmount, format) |
| `decklog` | Log viewer for TermuxDeck logs |
| `deckclean` | Storage cleanup utility |
| `deckupdate` | Check & auto-update TermuxDeck OS |
| `decktheme` | Theme manager (8 themes + 7 profile themes) |
| `deckmenu` | Interactive TUI launcher for all tools |
| `deckhelp` | Help utility with usage examples |
| `decksetup` | First-run setup wizard |
| `deckai` | AI launcher (opencode / gemini-cli) |

**Usage examples:**
```bash
deckbat --json
deckping --host 8.8.8.8
deckwifi --json
decklocate --track 5
deckbrowse github
deckbrowse search termux
deckdisk list
decktheme list
decktheme set nord
decklog view tools
deckclean check
deckupdate check
```

---

## Repository Tools

| Command | Description |
|---------|-------------|
| `tdeckconf` | Config manager (get/set/list/validate) |
| `tdeckprof` | Profile manager (set/unset/list profiles) |
| `termuxdeck-doctor` | System health audit and repair |
| `termuxdeck-sync` | Git-backed multi-device config sync |
| `termuxdeck-web` | Local web dashboard (localhost:8080) |
| `termuxdeck-plugin` | Community plugin registry manager |
| `termuxdeck-vault` | GPG encryption for sensitive config |

**Usage examples:**
```bash
tdeckconf set theme.name ghost
tdeckconf list
tdeckconf validate
tdeckprof list
tdeckprof set hacker
tdeckprof status
termuxdeck-doctor
termuxdeck-web
```

---

## Profile Management

Stackable environments tailored to your mission:

```bash
tdeckprof list              # Show available profiles
tdeckprof set writer        # Install + activate writer profile
tdeckprof set hacker        # Install + activate hacker profile
tdeckprof set developer     # Install + activate dev profile
tdeckprof set crypto        # Install + activate crypto profile
tdeckprof set radio         # Install + activate SDR profile
tdeckprof set iot           # Install + activate IoT profile
tdeckprof install-all       # Install everything
tdeckprof status            # Show active profiles
```

| Profile | Packages |
|---------|----------|
| **Hacker** | nmap, tcpdump, netcat, tshark, whois, dnsutils |
| **Developer** | git, openssh, python, nodejs, nano |
| **Writer** | mdcat, pandoc |
| **Crypto** | gnupg, openssl |
| **Radio** | rtl-sdr, sox, multimon-ng |
| **IoT** | python, mosquitto-clients |

---

## Themes

### Visual Themes (8)
```
decktheme list
decktheme set <name>
```

| Theme | Description |
|-------|-------------|
| **cyberpunk** | Green/cyan, matrix-style (default) |
| **ghost** | White/grey, minimal |
| **blood** | Deep red, aggressive |
| **matrix** | Classic green terminal |
| **nord** | Arctic blue |
| **dracula** | Purple/vampire |
| **monokai** | Pink/yellow contrast |
| **ocean** | Deep blue |

### Profile Themes (7)
Auto-match your active profile:

| Theme | Matches Profile | Style |
|-------|-----------------|-------|
| **hacker** | hacker | Matrix/green |
| **developer** | developer | Clean blue |
| **writer** | writer | Minimal purple |
| **crypto** | crypto | Dark purple |
| **radio** | radio | Navy/signal |
| **hamradio** | hamradio | Navy/signal |
| **iot** | iot | Circuit cyan |

```bash
# Set visual theme
decktheme set ocean

# Set profile theme (auto-matches active profile)
decktheme set hacker
```

Profile themes automatically activate when you set a profile via `tdeckprof set`.

---

## Configuration

All settings in `~/.termuxdeck/config.json`:

```bash
tdeckconf set hostname mydeck
tdeckconf set theme.name blood
tdeckconf get version
```

---

## Architecture Support

Runs on all Termux-supported architectures:
- ARM64 (aarch64)
- ARM32 (armv7)
- x86_64
- x86

---

## Changelog

### v1.1.0 
**Release Date:** 2026-05-04

#### New Features
- **New Boot Experience** — Custom ASCII logo + profile-specific quotes (philosophic), one-liner system info
- **Interactive Launcher** — `deckmenu` — TUI menu to browse and launch all tools
- **Theme System** — 8 visual themes + 7 profile themes with automatic switching
- **Profile Quotes** — Each profile (hacker, developer, writer, crypto, radio, hamradio, iot, base) has unique philosophic quotes shown at boot

#### New Tools
- `deckhelp` — Unified help system with usage examples for all tools
- `deckmenu` — Interactive TUI launcher (number/letter selection)
- `decklog` — Log viewer for TermuxDeck logs
- `deckclean` — Storage cleanup utility
- `deckupdate` — Check for updates
- `decktheme` — Theme manager (visual + profile themes)
- `deckdisk` — Disk management (list, mount, unmount, format)
- `tdeckprof` — Profile manager (install/set/unset profiles)

#### Improvements
- All deck tools now support `--json` and `--log` flags
- `deckbrowse` now works without URL input (defaults to Google)
- `deckai` launcher replaces old gemini wrapper — supports opencode & gemini-cli with interactive install
- `tdeckconf` updated with full dot-notation support
- Boot script colored by theme, shows battery status
- Added battery to one-liner system info

#### Bug Fixes
- Fixed missing `.zshrc` in repo (now deployed on install)
- Fixed `deckbrowse` not in installer list
- Fixed repo URL to use GitHub Pages format
- Fixed `tdeckconf reset` to not call non-existent flag

#### Files Added
- `.zshrc` — Base shell configuration with zinit plugins
- `themes/*.toml` — 8 profile themes (hacker, developer, writer, crypto, radio, hamradio, iot, base)
- `themes/*.quotes` — Profile-specific quotes (10 philosophic quotes each)

#### First-Run Setup
- `decksetup` — Interactive first-run wizard that configures:
  - Hostname, Profile selection, Theme selection
  - Auto-update toggle (enable/disable)
  - Additional package installation
  - Auto-installs profile-specific packages
- Recommended to run after fresh install: `decksetup`

#### Auto-Update System
- `deckupdate auto on` — Enable automatic update checks on shell start
- `deckupdate auto off` — Disable auto-updates
- `deckupdate check` — Manual version check
- `deckupdate upgrade` — Force upgrade to latest version

#### Repository Tools (v1.1+)
- `tdeckconf` — Config manager (get/set/list/validate/reset)
- `tdeckprof` — Profile manager (set/unset/list/install-all)
- `termuxdeck-doctor` — System health audit with `--fix` option
- `termuxdeck-sync` — Git-backed multi-device config sync
- `termuxdeck-web` — Local web dashboard (localhost:8080)
- `termuxdeck-plugin` — Community plugin registry manager
- `termuxdeck-vault` — GPG encryption for sensitive config values

#### System Boot (v1.1)
- Removed fastfetch dependency for faster boot
- Custom ASCII logo with theme-based coloring
- One-liner system info: Device · RAM · CPU · Disk · Battery
- Boot log for session tracking

---

## Contributing

## Contributing

- No CLA required
- MIT Licensed
- Headless philosophy

---

