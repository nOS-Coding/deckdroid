# DeckDroid

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Termux-orange.svg)](https://termux.dev/)
[![Version](https://img.shields.io/badge/Version-1.1.0--stable-green.svg)](#)

```
    ██████╗ ███████╗ ██████╗██╗  ██╗██████╗ ██████╗  ██████╗ ██╗██████╗ 
    ██╔══██╗██╔════╝██╔════╝██║ ██╔╝██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗
    ██║  ██║█████╗  ██║     █████╔╝ ██║  ██║██████╔╝██║   ██║██║██║  ██║
    ██║  ██║██╔══╝  ██║     ██╔═██╗ ██║  ██║██╔══██╗██║   ██║██║██║  ██║
    ██████╔╝███████╗╚██████╗██║  ██╗██████╔╝██║  ██║╚██████╔╝██║██████╔╝
    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝
    DeckDroid v1.1.0 — Any device. Any arch. One terminal.
```

> **Any device. Any architecture. One terminal.**

**DeckDroid** is a high-performance addon with special packages and a new UI built entirely for a cyberdeck. It transforms any Android device running Termux into a professional cyberdeck: hacker toolkit, developer workstation, or field terminal — fast and aesthatic.

---

## Quick Install

```bash
curl -sL https://nos-coding.github.io/deckdroid/install.sh | bash
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
| `decklog` | Log viewer for DeckDroid logs |
| `deckclean` | Storage cleanup utility |
| `deckupdate` | Check & apply DeckDroid updates |
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
| `ddeckconf` | Config manager (get/set/list/validate) |
| `tdeckprof` | Profile manager (set/unset/list profiles) |
| `deckdroid-doctor` | System health audit and repair |
| `deckdroid-sync` | Git-backed multi-device config sync |
| `deckdroid-web` | Local web dashboard (localhost:8080) |
| `deckdroid-plugin` | Community plugin registry manager |
| `deckdroid-vault` | GPG encryption for sensitive config |

**Usage examples:**
```bash
ddeckconf set theme.name ghost
ddeckconf list
ddeckconf validate
tdeckprof list
tdeckprof set hacker
tdeckprof status
deckdroid-doctor
deckdroid-web
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
```bash
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

---

## Configuration

All settings stored in `~/.deckdroid/config.json`:

```bash
ddeckconf set hostname mydroid
ddeckconf set theme.name blood
ddeckconf get version
ddeckconf list
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

#### Rebranded: TermuxDeck OS → DeckDroid
- All config paths moved from `~/.termuxdeck/` to `~/.deckdroid/`
- All `termuxdeck-*` repo tools renamed to `deckdroid-*`
- Install script updated for new repo: `nos-coding.github.io/deckdroid`
- ASCII logo updated to spell **DECKDROID**
- Environment variable renamed `TDECK_HOME` → `DDROID_HOME`

#### New Features
- **New Boot Experience** — Custom ASCII logo + profile-specific quotes, one-liner system info
- **Interactive Launcher** — `deckmenu` — TUI menu to browse and launch all tools
- **Theme System** — 8 visual themes + 7 profile themes with automatic switching
- **Profile Quotes** — Each profile has unique philosophic quotes shown at boot

#### New Tools
- `deckhelp` — Unified help system with usage examples for all tools
- `deckmenu` — Interactive TUI launcher (number/letter selection)
- `decklog` — Log viewer for DeckDroid logs
- `deckclean` — Storage cleanup utility
- `deckupdate` — Check for updates
- `decktheme` — Theme manager (visual + profile themes)
- `deckdisk` — Disk management (list, mount, unmount, format)
- `tdeckprof` — Profile manager (install/set/unset profiles)

#### Improvements
- All deck tools now support `--json` and `--log` flags
- `deckbrowse` now works without URL input (defaults to Google)
- `deckai` supports opencode & gemini-cli with interactive install
- `ddeckconf` updated with full dot-notation support
- Boot script colored by active theme, shows battery status

#### Bug Fixes
- Fixed missing `.zshrc` in repo (now deployed on install)
- Fixed `deckbrowse` missing from installer list
- Fixed repo URL to use GitHub Pages format
- Fixed `ddeckconf reset` referencing non-existent flag

#### Files Added
- `.zshrc` — Base shell configuration with zinit plugins
- `themes/*.toml` — 8 visual themes + 7 profile themes
- `themes/*.quotes` — Profile-specific philosophic quotes (10 per profile)

#### First-Run Setup
- `decksetup` — Interactive first-run wizard:
  - Hostname, Profile, Theme, Auto-update, Additional packages

#### Auto-Update System
- `deckupdate auto on` — Enable automatic update checks on shell start
- `deckupdate auto off` — Disable auto-updates
- `deckupdate check` — Manual version check
- `deckupdate upgrade` — Force upgrade to latest version

---

## Contributing

- No CLA required
- MIT Licensed
- Headless philosophy is mandatory

---

*DeckDroid — Any device. Any arch. One terminal.*
