# TermuxDeck OS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Termux-orange.svg)](https://termux.dev/)
[![Version](https://img.shields.io/badge/Version-1.0.0--stable-green.svg)](#)

> **Any device. Any architecture. One terminal.**

**TermuxDeck OS** is a high-performance, headless OS-layer experience built entirely within the Termux userland. It transforms any Android device, Raspberry Pi, or Linux machine into a professional cyberdeck: hacker toolkit, developer workstation, or field terminal — fast, aesthetic, and under 500 MB.

---

## Quick Install

Run the following command in your Termux terminal to begin the installation:

```bash
curl -sL https://nos-coding.github.io/termuxdeck/install.sh | bash
```

Once installed, restart your shell:
```bash
zsh
```

---

## Features

### The Deck Toolkit
A suite of custom, JSON-aware tools designed for field operations:
- **deckbat**: Advanced battery metrics (temp, voltage, health).
- **deckping**: Multi-layer connectivity audit (Gateway -> DNS -> Internet).
- **deckid**: Deep device identity and network footprint.
- **deckwifi**: Proactive WiFi environment scanner.
- **decklocate**: GPS and cell-tower triangulation via Termux:API.
- **deckclock**: Multi-timezone world clock with NTP sync status.
- **decksniff**: Streamlined packet capture wrapper.
- **decknote**: Minimalist Markdown knowledge base.
- **gemini**: AI assistant integration (Gemini CLI).

### Profiles
Stackable environments tailored to your mission:
- **Hacker**: nmap, tcpdump, netcat, tshark, whois.
- **Developer**: git, openssh, python, nodejs, ~/dev/ workspace.
- **Writer**: mdcat, pandoc, wordgrinder, decknote.
- **Radio/SDR**: rtl-sdr, sox, multimon-ng.
- **IoT**: pyserial, minicom, mosquitto-clients, esptool.

---

## Configuration

TermuxDeck uses a centralized JSON configuration at ~/.termuxdeck/config.json. Manage it via the tdeckconf utility:

```bash
tdeckconf set theme.name ghost
tdeckconf list
tdeckconf validate
```

---

## Repository Tools (v1.0+)
- **termuxdeck-sync**: Git-backed multi-device configuration sync.
- **termuxdeck-vault**: GPG-encrypted sensitive config fields.
- **termuxdeck-web**: Local system status dashboard (localhost:8080).
- **termuxdeck-plugin**: Community tool registry manager.
- **termuxdeck-doctor**: Full environment health audit.

---

## Contributing

We welcome contributions from the cyberdeck community!
- No CLA required.
- MIT Licensed.
- Headless philosophy is mandatory.

---

*TermuxDeck OS — Designed for the digital nomad.*
