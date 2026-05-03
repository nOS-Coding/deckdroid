# TermuxDeck OS — Comprehensive Build Plan v2
> MIT License · Open Source · Universal Architecture (x86_64, ARM64, ARM32, x86) · Headless · Termux-Native

---

## 1. Project Identity & Philosophy

TermuxDeck OS is not a wrapper around Termux — it *is* a Linux distribution in spirit, built entirely within the Termux userland on any Android device or Linux machine running Termux. It treats the host as a headless server node, a pentesting rig, a developer workstation, and a field terminal simultaneously — regardless of whether that host is a flagship phone, a budget Android tablet, a Raspberry Pi running Termux, or a Lego-chassis cyberdeck. The design philosophy is maximum aesthetic and tooling density within a hard storage ceiling of 500 MB and a minimum RAM requirement of 1 GB, with no GUI, no proot escape hatch, and no compromise on the cyberdeck identity. Every decision in this project — from the shell to the MOTD — should feel like it belongs on a piece of hardware that someone built themselves. The OS is MIT-licensed, fully open source, and built for a public community of cyberdeck builders, Termux hackers, and mobile Linux enthusiasts worldwide.

---

## 2. Universal Architecture Support

TermuxDeck OS explicitly targets all architectures supported by Termux: **ARM64 (aarch64)**, **ARM32 (armv7)**, **x86_64**, and **x86**. This is not an afterthought — it is a first-class design constraint. Every package dependency, every shell script, every `.deb` control file, and every CI pipeline step must account for all four architectures. The GitHub Actions build matrix runs on all four targets. Shell scripts use only POSIX-compatible constructs and avoid architecture-specific binary assumptions. Where a dependency is unavailable on a given architecture (e.g., some compiled tools are not in the Termux repo for x86), the installer detects the architecture via `uname -m` and gracefully skips unavailable packages, logging the gap to `~/.termuxdeck/logs/install.log`. The fastfetch config displays the detected architecture prominently in the system info block. Architecture compatibility is a community-tested requirement: every release must be verified on at least ARM64 and x86_64 before tagging.

---

## 3. Distribution & Installation via pkg

TermuxDeck OS is distributed as a native Termux package installable through `pkg install termuxdeck`. This requires maintaining a custom apt repository hosted on GitHub Releases or a static CDN. The repository contains a `termuxdeck.deb` package that, on install, runs a `postinst` script bootstrapping the entire OS layer: installing dependencies, writing configs, setting up zsh, deploying the profile system, and running fastfetch for the first time. Users add the TermuxDeck repo via a one-liner: `curl -sL https://termuxdeck.dev/install.sh | bash`, which adds the repo to the Termux sources list and runs `pkg install termuxdeck`. The `.deb` package follows the standard Termux packaging format with `control`, `postinst`, `prerm`, and a `data.tar.xz` payload. All future updates to the OS layer are manual — users re-run the install script or pull fresh configs from the Git repo. The install script is idempotent: running it twice on the same device is safe and only applies missing changes.

---

## 4. Shell — Zsh with Custom Configuration

The default and only supported shell in TermuxDeck OS is **zsh**, chosen for its unmatched combination of community adoption, plugin ecosystem, POSIX compatibility, and power-user features. On install, TermuxDeck OS deploys a custom `.zshrc` to `$HOME` that includes: the Zinit plugin manager (lightweight, fast, no Oh My Zsh bloat), syntax highlighting via `zsh-syntax-highlighting`, autosuggestions via `zsh-autosuggestions`, a custom prompt built with Starship (showing user, host, git branch, Python/Node version, and battery level), and a curated set of aliases tailored to the TermuxDeck toolkit. The prompt theme is dark, minimal, and ASCII-safe to work on any terminal emulator. Zsh history is set to 10,000 lines, shared across sessions, and stored at `~/.termuxdeck/zsh_history`. Tab completion is turbo-configured with case-insensitive matching and menu-driven selection. The shell initializes in under 300ms even on constrained hardware. The `.zshrc` is modular — split into sourced fragments under `~/.termuxdeck/zshrc.d/` — so profiles and optional packages can inject their own shell configuration without touching the base file.

---

## 5. Boot Experience — Fastfetch & MOTD

Every new Termux session on TermuxDeck OS begins with **fastfetch**, configured to display a full system snapshot branded to the OS and the hardware it runs on. The fastfetch config at `~/.config/fastfetch/config.jsonc` is deployed by the installer and includes: a custom ASCII art logo for TermuxDeck OS (compact, 6-line, fits a narrow terminal), OS name and version, device model, Android version, kernel version, Termux version, shell (zsh + version), terminal emulator, CPU model and core count, total and used RAM, storage usage, battery level and status, local IP address, architecture, and uptime. Below the fastfetch output, a short MOTD is printed showing the current date/time, a rotating "deck status" line (randomly selected hacker/sysadmin quote from a local flat file at `~/.termuxdeck/quotes.txt`), and a reminder of the installed profiles. The entire boot sequence is driven by a single script `~/.termuxdeck/boot.sh` sourced from `.zshrc`. The ASCII logo and color scheme are configurable in `~/.termuxdeck/config.json` under the `theme` key, with three built-in themes: `cyberpunk` (green/cyan), `ghost` (white/grey), and `blood` (red/dark).

---

## 6. Profile System — Hacker / Developer / Writer

TermuxDeck OS is organized around three installable **profiles** that stack on top of the base install. Profiles are shell scripts stored at `~/.termuxdeck/profiles/` and activated at install time. The **Hacker Profile** installs nmap, netcat, curl, tcpdump, wireshark-cli, masscan, whois, dnsutils, and the full custom deck tool suite. The **Developer Profile** installs git, Python, Node.js, pip, npm, openssh (optional), nano, and sets up a standard `~/dev/` workspace with a `.gitconfig` template. The **Writer Profile** installs mdcat (markdown renderer), pandoc, wordgrinder (TUI word processor), and a plain-text notes system backed by `~/.termuxdeck/notes/`. Profiles are not mutually exclusive — all three can be active simultaneously. The active profiles are recorded in `~/.termuxdeck/config.json` under the `profiles` array key. Installing a profile is done via `pkg install termuxdeck-profile-hacker` (each profile ships as its own sub-package in the TermuxDeck apt repo). A `termuxdeck-profiles` meta-package installs all three at once.

---

## 7. Configuration System — JSON in ~/.termuxdeck/

All TermuxDeck OS user configuration lives in `~/.termuxdeck/config.json`. This file is created on first install with sane defaults and is the single source of truth for the OS layer. Keys include: `hostname`, `user` (display name), `profiles` (active profile list), `timezone`, `ssh.enabled`, `ssh.port` (default: 8022), `gemini.enabled`, `gemini.api_key`, `motd.quotes_enabled`, `editor` (default: `nano`), `theme.name`, `theme.prompt_color`, and `deck.tools` (list of enabled custom tools). The config is read at shell startup by `boot.sh` using Python's `json` module or `jq`, and exported as environment variables prefixed with `TDECK_`. This makes config values available to all shell scripts and tools without requiring them to parse JSON themselves. A helper command `tdeckconf` (a small Python script) allows reading and writing individual config keys from the shell: `tdeckconf set hostname mydevice` or `tdeckconf get theme.name`. The config directory also holds: `notes/`, `logs/`, `tools/`, `profiles/`, `zshrc.d/`, `quotes.txt`, and `boot.sh`.

---

## 8. Base Package Set & Storage Budget

The total installed footprint of TermuxDeck OS must not exceed **500 MB**. The base install (zsh + zinit + starship + fastfetch + nano + Python + Node.js + core utilities) targets approximately 180 MB. The Hacker Profile adds roughly 80 MB. The Developer Profile adds roughly 60 MB. The Writer Profile adds roughly 30 MB. Gemini CLI (optional) adds roughly 50 MB. SSH server adds roughly 5 MB. This leaves around 95 MB of headroom for user data, notes, scripts, and future packages. Storage is tracked at boot by fastfetch and also queryable via `deckbat`. The installer warns if available storage drops below 600 MB before proceeding. Package selection is ruthlessly minimal — no duplicate tools, no GUI dependencies, no X11 libs. Every package added to any profile must justify its size. The `termuxdeck-doctor` utility checks the storage budget and flags overruns, showing a per-package breakdown so users know exactly what is consuming space.

---

## 9. Python & Node.js Runtimes

Both **Python 3** and **Node.js** are baked into the base TermuxDeck OS install as first-class runtimes, since they power the custom tool suite and enable user scripting out of the box. Python is installed via `pkg install python` and configured with pip, with a base set of packages: `requests`, `rich` (for pretty terminal output), `psutil`, and `python-dotenv`. Node.js is installed via `pkg install nodejs` with npm, and the global npm prefix is set to `~/.npm-global` to keep the Termux prefix clean. The `.zshrc` exports `PATH=$HOME/.npm-global/bin:$PATH` automatically. Both runtimes are available immediately after install with no extra steps. The `termuxdeck-doctor` utility checks that both runtimes are healthy and that key packages are installed, reporting any gaps on demand. Version pinning is not enforced at this stage — the latest stable versions from the Termux repo are used.

---

## 10. Gemini CLI — Optional AI Layer

**Gemini CLI** is available as an optional package (`pkg install termuxdeck-gemini`) and is not part of the base install. When installed, it provides access to Google's Gemini models directly from the terminal — useful for on-device AI assistance, code review, text generation, and research without leaving the command line. The package installs the official `@google/gemini-cli` npm package globally and creates a wrapper script that sources the API key from `~/.termuxdeck/config.json` under the `gemini.api_key` field. On first run, if no API key is present, the wrapper prompts the user to enter one and saves it to config. Gemini CLI is listed in the MOTD as active when `gemini.enabled` is `true` in config. Users on constrained devices are advised to keep Gemini CLI sessions brief and close them before running memory-intensive tools like nmap or tcpdump simultaneously.

---

## 11. Custom Tool Suite — The Deck Tools

The TermuxDeck hacker profile ships a suite of custom shell/Python tools, all prefixed with `deck`, living in `~/.termuxdeck/tools/` and symlinked into the Termux `$PREFIX/bin/` for global access. **decklocate** uses `termux-location` and `termux-telephony-cellinfo` to fetch GPS coordinates, cell tower data, and reverse-geocoded address. **deckclock** fetches current time across multiple timezones and checks NTP sync status. **deckping** runs a multi-layer connectivity test: gateway, DNS, internet, and latency in a color-coded summary. **decksniff** wraps tcpdump with preset capture profiles (HTTP, DNS, ARP, all traffic). **deckid** pulls full device identity: IMEI, Android ID, public and private IP, MAC, and hostname. **deckbat** reads battery level, temperature, voltage, and charging status with configurable low-battery alerts. **deckwifi** uses `termux-wifi-scaninfo` to list nearby networks with SSID, BSSID, signal strength, and security type. All tools write logs to `~/.termuxdeck/logs/` when run with `--log`, and support `--json` output for piping into other tools.

---

## 12. SSH Server — Optional Remote Access

SSH access to any TermuxDeck device is available as an optional install (`pkg install termuxdeck-ssh`). When installed, it deploys OpenSSH server preconfigured for Termux: port 8022, key-based auth only (password auth disabled), and a custom `sshd_config` stored at `~/.termuxdeck/sshd_config`. The `ssh.enabled` and `ssh.port` fields in `config.json` control whether the SSH server auto-starts at session launch via `boot.sh`. Helper aliases `sshstart`, `sshstop`, and `sshstatus` are added to `.zshrc` when the package is installed. On first install, an Ed25519 host key is generated and stored at `~/.termuxdeck/ssh/host_key`. The MOTD displays SSH status (running/stopped + port) when enabled. This makes any TermuxDeck device accessible from another machine on the same network — critical for headless cyberdeck operation where the device has a small screen or is stowed away.

---

## 13. Network & Hacking Tools Deep Dive

The Hacker Profile includes a carefully curated toolkit within the storage budget: nmap for network discovery and port scanning, netcat for raw TCP/UDP connections, curl and wget for HTTP interaction, tcpdump for packet capture, tshark for deep packet inspection, masscan for high-speed port scanning, whois and dig for DNS reconnaissance, and the full deck tool suite. Hydra for credential testing is available as a separate optional sub-package `termuxdeck-profile-hacker-extra`, not installed by default, to keep the base profile lean and avoid any appearance of aggressive tooling being on by default. Metasploit is explicitly excluded — too large for the 500 MB budget and too complex for the scope of this project. All hacking tools are gated behind a one-time disclaimer on profile install: "This profile installs security research tools. Use only on networks and systems you own or have explicit permission to test." The disclaimer is logged with timestamp to `~/.termuxdeck/logs/disclaimer.log` and must be explicitly accepted with `--accept` flag during install.

---

## 14. Repository Architecture & .deb Packaging

The TermuxDeck apt repository is hosted on GitHub and served via GitHub Pages. The repository structure follows the standard Debian apt format, with separate `Packages.gz` files for each supported architecture: `aarch64`, `arm`, `x86_64`, `i686`. Each `.deb` is built using a Makefile in the project's Git repo. The `control` file for each package specifies `Depends:` on the correct Termux packages, ensuring that `pkg install termuxdeck-profile-hacker` automatically pulls nmap, tcpdump, and friends. A GitHub Actions CI pipeline builds and signs all `.deb` files on every tagged release and publishes them to the `gh-pages` branch. The repo GPG key is distributed as part of the install script and added to Termux's trusted keys. Package metadata includes a `Description:`, `Homepage:`, `Maintainer:`, and `Version:` following semantic versioning. The `prerm` script for each package cleanly removes symlinks, configs, and shell fragments without touching user-created files in `~/.termuxdeck/`.

---

## 15. Git Repository & Project Structure

The TermuxDeck OS source code lives on GitHub under an MIT license. The repository structure is: `packages/` (one subdirectory per `.deb` package), `tools/` (source for all `deck*` tools), `configs/` (default config templates, zshrc, fastfetch config, starship config, quotes.txt), `profiles/` (profile shell scripts), `docs/` (markdown documentation), `scripts/` (build and release automation), `.github/workflows/` (CI/CD pipelines). The `README.md` is the primary user-facing documentation covering install instructions, profile descriptions, tool reference, config key documentation, and hardware compatibility notes. The project uses semantic versioning: `v0.1.0` for the initial release. Issues and features are tracked via GitHub Issues with labels: `bug`, `enhancement`, `profile-proposal`, `tool-idea`, `docs`, `hardware-compat`. Contributions are welcome via Pull Requests following a lightweight `CONTRIBUTING.md` guide that covers code style (POSIX shell where possible, Python 3 for complex logic), commit message format, and testing requirements.

---

## 16. RAM Management & Performance Tuning

TermuxDeck OS enforces a minimum of **1 GB RAM** and is designed to run comfortably within that constraint. The base OS layer (zsh + fastfetch + background daemons) consumes under 50 MB of RAM at idle. The SSH server adds roughly 5 MB when running. Python scripts (deck tools) are short-lived and free memory on exit. Node.js processes (Gemini CLI) are the heaviest single processes and are designed to be run on demand, not kept alive. A `memdeck` alias runs `/proc/meminfo` parsing to show current RAM usage in human-readable format. Users are warned if free memory drops below 200 MB before launching memory-intensive tools. The zsh plugin set is kept to exactly three plugins to minimize startup time and resident memory. The Starship prompt is configured with a minimal module set to avoid slow segment rendering on low-clock CPUs. Fastfetch itself is one of the fastest system info tools available and adds under 100ms to session startup.

---

## 17. Termux:API Integration

Many deck tools depend on **Termux:API** — the bridge between the Termux shell and Android system APIs. TermuxDeck OS requires both the `termux-api` Termux package and the **Termux:API** companion Android app. The installer checks for the package and warns if the API app is not detected. API-dependent tools include decklocate, deckbat, deckwifi, and deckid. Each tool gracefully degrades when the API is unavailable — it prints a clear warning and returns what data it can from `/proc` and standard Linux commands. On non-Android Linux hosts running Termux (e.g., via WSL-like setups or native Linux Termux ports), Termux:API is unavailable by design, and all API-dependent tools fall back to Linux-native equivalents: `upower` for battery, `iw` for WiFi, `ip` for network identity. This makes TermuxDeck OS genuinely portable across the full range of Termux hosts.

---

## 18. Security Model & Threat Awareness

TermuxDeck OS runs entirely in userspace with no root access required or assumed. Raw socket operations, kernel-level hostname changes, and `/proc` writes are unavailable without root. The OS documents this clearly and provides graceful fallbacks. The SSH server uses key-only auth and runs on a non-standard port. No telemetry, no analytics, no network calls home — the OS is entirely offline by default after installation. API keys (Gemini) are stored in the plain JSON config file, readable only by the Termux user. Users are advised to add `~/.termuxdeck/` to their `.gitignore` if they version-control their home directory. A future `termuxdeck-vault` package using `gpg` symmetric encryption for sensitive config fields is planned for v0.5. The hacker tools disclaimer is enforced and logged. The `termuxdeck-doctor` utility includes a basic security audit: checks for world-readable config, checks SSH config for password auth, and warns if the Gemini API key is unset but the package is installed.

---

## 19. Community, Documentation & Contribution Model

TermuxDeck OS is an open source project under the MIT license that explicitly welcomes community contributions. Documentation lives in `docs/` as plain Markdown: `INSTALL.md`, `PROFILES.md`, `TOOLS.md`, `CONFIG.md`, `HARDWARE.md`, `CONTRIBUTING.md`, and `CHANGELOG.md`. The community hub is GitHub Discussions with channels: General, Show Your Build, Tool Ideas, Bug Reports, and Profile Requests. New profile proposals (Radio/SDR, Crypto, Amateur Radio, IoT) are welcome as GitHub Issues. The project maintains a `HALL_OF_FAME.md` documenting notable cyberdeck builds running TermuxDeck OS submitted by the community. A `DEVICES.md` file tracks confirmed-working devices, contributed by the community, with columns for device name, architecture, Android version, known issues, and contributor handle. Every merged contribution is credited in `CONTRIBUTORS.md`. The project adopts a "no CLA" policy — contributions belong to their authors, licensed MIT.

---

## 20. Roadmap — From v0.1 to v1.0

The v0.1 release delivers the base `.deb` package, zsh config, fastfetch boot, three profiles, all seven deck tools, JSON config system, and the apt repository. v0.2 adds the Gemini CLI package, the SSH package, and `termuxdeck-doctor`. v0.3 introduces a Radio/SDR profile and a Crypto profile (gpg, age, pass). v0.4 hardens the tool suite with advanced modes for all deck tools. v0.5 adds `termuxdeck-vault` for encrypted config and `termuxdeck-sync` for git-backed dotfile synchronization across multiple devices. v0.6 introduces a `termuxdeck-web` optional package — a lightweight local web dashboard (served via a Python HTTP server on localhost) displaying system stats in a browser for devices connected to a display over HDMI. v0.7 adds a plugin API so community members can publish their own `termuxdeck-*` packages to the official repo after review. v1.0 is the stable release: full documentation, tested on at least five architectures and ten devices, a community-vetted package set, and a reproducible build pipeline.

---

## 21. The tdeckconf Configuration Manager

`tdeckconf` is a small but important Python utility that ships with the base TermuxDeck OS install. It provides a clean command-line interface for reading, writing, and validating the `~/.termuxdeck/config.json` file without requiring the user to hand-edit JSON. The API is: `tdeckconf get <key>`, `tdeckconf set <key> <value>`, `tdeckconf list` (shows all keys and values), `tdeckconf reset` (restores defaults from the template), and `tdeckconf validate` (checks the config against a JSON schema and reports errors). Key paths use dot notation for nested values: `tdeckconf set theme.name blood`. Type coercion is handled automatically — setting a boolean key with `"true"` or `"false"` saves it as a JSON boolean, not a string. The `tdeckconf` tool is also used internally by profile install scripts to register the profile in the `profiles` array and by the SSH package to enable SSH in config on install. It is the only sanctioned way for packages to modify user config, ensuring no package blindly overwrites user customizations.

---

## 22. termuxdeck-doctor — System Health Utility

`termuxdeck-doctor` is a diagnostic utility included in the base install that performs a full health check of the TermuxDeck OS environment and reports any issues. It checks: zsh installation and `.zshrc` integrity, Zinit and plugin availability, Starship installation, fastfetch config presence, Python and Node.js runtime health and key package availability, storage budget (warns above 450 MB used of the 500 MB ceiling), RAM availability (warns below 1 GB total), active profile consistency (profiles listed in config.json vs packages actually installed), SSH config security (password auth check), Termux:API availability, Gemini CLI API key presence if enabled, and symlink integrity for all deck tools. Output is color-coded: green for healthy, yellow for warnings, red for errors. Running `termuxdeck-doctor --fix` attempts to automatically resolve common issues: reinstalling missing symlinks, regenerating corrupted configs from defaults, and re-running failed profile installs. It is recommended to run `termuxdeck-doctor` after every `pkg upgrade` to catch any broken dependencies.

---

## 23. Logging & Audit Trail

TermuxDeck OS maintains a structured log directory at `~/.termuxdeck/logs/`. Every significant OS-layer event is logged with a UTC timestamp, event type, and relevant metadata. Log files include: `install.log` (full install and upgrade history), `boot.log` (session start times, fastfetch output, any boot errors), `disclaimer.log` (hacker profile disclaimer acceptance records), `tools.log` (every invocation of a `deck*` tool with arguments, duration, and exit code when `--log` is passed), `doctor.log` (output of every `termuxdeck-doctor` run), and `error.log` (any unhandled errors from any TermuxDeck OS component). Logs are plain text, one JSON object per line (newline-delimited JSON) for easy parsing with `jq`. Log rotation is manual — there is no automatic rotation in v0.1, but a `tdecklogs` alias provides shortcuts for viewing, grepping, and clearing logs. A future `termuxdeck-logd` daemon for structured background logging is on the v0.6 roadmap.

---

## 24. Theming System — ASCII Aesthetics

TermuxDeck OS includes a first-class theming system covering every visual element of the terminal experience. Three built-in themes ship with the base install: **cyberpunk** (bright green prompt, cyan accents, green ASCII logo — the default), **ghost** (white/grey minimal palette, no color in the logo, clean and quiet), and **blood** (deep red prompt, dark background optimized accents, aggressive aesthetic). Themes control: Starship prompt colors (via a theme-specific `starship.toml` template), fastfetch logo color and ASCII art variant, MOTD color scheme, and zsh syntax highlighting color map. Switching themes is a single command: `tdeckconf set theme.name ghost && source ~/.zshrc`. Custom themes can be added by placing a theme directory at `~/.termuxdeck/themes/<name>/` containing `starship.toml`, `fastfetch.jsonc`, and `colors.sh`. Community-contributed themes will be collected in a `termuxdeck-themes` sub-repository and installable as a package. The ASCII logo shipped with each theme is designed to fit within 40 columns to support narrow terminal emulators on small phone screens.

---

## 25. Multi-Device Awareness & Hostname System

Although TermuxDeck OS runs on any device, it is designed to be self-aware about *which* device it is running on. The `hostname` key in `config.json` gives each TermuxDeck installation a unique identity. The hostname is displayed in: the Starship prompt, the fastfetch device name field, the SSH server banner, and the MOTD greeting line. The installer generates a suggested default hostname by combining a random adjective with a random noun from a small curated word list (e.g., `silent-reef`, `hollow-pine`, `iron-ghost`) if the user does not specify one during install. Users can change their hostname at any time via `tdeckconf set hostname myname`. The hostname does not modify the Android system hostname (which requires root) but is used exclusively within the TermuxDeck OS layer. In a future version, `termuxdeck-sync` will use the hostname as the device identifier when syncing configs across multiple machines.

---

## 26. Notes System — Plain Text Knowledge Base

The **Writer Profile** introduces a lightweight plain-text notes system built into TermuxDeck OS. Notes are stored as individual Markdown files in `~/.termuxdeck/notes/`, with filenames in `YYYY-MM-DD-title.md` format. The `decknote` tool provides the interface: `decknote new "my note title"` creates a new note and opens it in nano, `decknote list` shows all notes sorted by date, `decknote search <query>` greps across all notes and returns matching lines with filenames, `decknote view <partial-title>` renders a note using mdcat, and `decknote delete <partial-title>` moves a note to `~/.termuxdeck/notes/.trash/`. Notes are version-controlled separately by the user via git — the `decknote` tool outputs a reminder to `git commit` after every new or edited note if the notes directory is a git repo. The notes system is intentionally minimal and does not implement encryption, sync, or tagging in v0.1 — those are v0.5 features.

---

## 27. Radio & SDR Profile (Planned v0.3)

The **Radio Profile** (`termuxdeck-profile-radio`) is planned for v0.3 and targets cyberdeck builders who connect Software Defined Radio dongles (RTL-SDR, HackRF) via USB OTG. It installs: `rtl-sdr` (the core RTL-SDR userspace driver and tools: `rtl_test`, `rtl_sdr`, `rtl_power`, `rtl_fm`), `sox` for audio processing of demodulated FM radio, `dump1090` for ADS-B aircraft tracking, and `multimon-ng` for decoding digital radio protocols (POCSAG, FLEX pager, AFSK). A custom deck tool `deckradio` provides a guided interface: `deckradio scan` runs a wideband power scan and displays signal peaks, `deckradio fm <freq>` tunes to an FM station and plays audio via `termux-audio`, `deckradio adsb` starts the dump1090 ADS-B decoder and displays live aircraft data in the terminal. This profile is architecture-conditional — RTL-SDR libraries may not be available on all architectures, and the installer will check and warn accordingly.

---

## 28. Crypto & Privacy Profile (Planned v0.3)

The **Crypto Profile** (`termuxdeck-profile-crypto`) focuses on encryption, privacy, and secure communication tools. It installs: `gnupg` for GPG key management, file encryption, and signing, `age` (a modern file encryption tool with a cleaner key model than GPG), `pass` (the standard Unix password manager, GPG-backed), `openssl` for certificate and key operations, and `tor` (where available in the Termux repo) for anonymized network access. A custom tool `deckcrypt` provides shortcuts: `deckcrypt encrypt <file>` encrypts a file to the user's default GPG key, `deckcrypt sign <file>` signs a file, `deckcrypt gen` generates a new age keypair and stores it in `~/.termuxdeck/keys/`. The `pass` password manager is configured to use `~/.termuxdeck/passwords/` as its store, making it easy to back up alongside other TermuxDeck config. This profile also hardens the base config: it enables `termuxdeck-vault` (GPG-encrypted sensitive fields in config.json) and sets the Gemini API key store to use age encryption.

---

## 29. termuxdeck-sync — Multi-Device Config Sync (Planned v0.5)

`termuxdeck-sync` is a planned v0.5 package that enables keeping TermuxDeck OS configurations synchronized across multiple devices using a git repository as the transport layer. The user sets up a private git repo (GitHub, Gitea, or any SSH-accessible git server) and runs `termuxdeck-sync init <repo-url>`. From that point, `termuxdeck-sync push` commits and pushes `~/.termuxdeck/config.json`, `~/.termuxdeck/zshrc.d/`, `~/.termuxdeck/profiles/`, `~/.termuxdeck/themes/`, and `~/.termuxdeck/notes/` (if the Writer Profile is active) to the remote repo. `termuxdeck-sync pull` fetches and applies changes, with a merge strategy that never overwrites device-specific keys (hostname, SSH keys, API keys) from remote. Sensitive fields (API keys, SSH private keys) are automatically excluded from sync via a `.termuxdeckignore` file. On a new device, `termuxdeck-sync clone <repo-url>` pulls the config and re-runs profile installs to bring the new device to parity with the synced state.

---

## 30. Plugin API — Community Extensions (Planned v0.7)

The **Plugin API** planned for v0.7 allows community members to publish their own `termuxdeck-*` packages to an official community sub-registry, extending TermuxDeck OS with new profiles, tools, themes, and integrations without requiring changes to the core repo. A plugin is a standard `.deb` package that follows the TermuxDeck packaging conventions: it places tool scripts in `~/.termuxdeck/tools/`, shell config fragments in `~/.termuxdeck/zshrc.d/`, and registers itself in the config's `plugins` array via `tdeckconf`. The community registry is a separate GitHub repo (`termuxdeck/community-plugins`) where plugin authors submit a `plugin.json` manifest (name, description, author, repo URL, architecture support, version) via Pull Request. After review, the plugin is listed in the registry and installable via `pkg install termuxdeck-plugin-<name>`. Plugin packages are signed by their authors and their GPG fingerprints are listed in the registry manifest. The core team maintains a vetting checklist to prevent malicious plugins from entering the registry.

---

## 31. Offline-First Design

TermuxDeck OS is designed to be fully functional with zero internet connectivity after installation. Every tool, profile, and utility operates offline by default. The deck tools that require network connectivity (deckping, decksniff, deckwifi, decklocate with cell tower data) gracefully handle offline states and clearly communicate what they can and cannot do without connectivity. The Gemini CLI is the only component that is inherently online-dependent, and it is explicitly optional. The notes system, config system, logging system, theming system, and all shell functionality work entirely offline. The install process requires internet access once to download packages from the TermuxDeck apt repo and the Termux repo, but after that, the system is self-contained. Future versions will include an optional local LLM integration (via `llama.cpp` or `ollama` where device resources permit) as an offline alternative to Gemini CLI, listed as a stretch goal for v1.0.

---

## 32. Hardware Compatibility Philosophy

TermuxDeck OS does not target a single device — it targets the *concept* of a Termux cyberdeck, which is any device where Termux runs and someone has chosen to build a deliberate, tool-rich computing environment. Confirmed compatible categories include: Android smartphones (any architecture, Android 7+), Android tablets, Android TV boxes with a USB keyboard, Raspberry Pi running Android, Chromebooks with Termux via Linux (Crostini) or Android subsystem, and standard Linux machines running Termux. The `HARDWARE.md` in the repo tracks specific confirmed devices with notes on known issues. Hardware-conditional behavior is gated on `uname -m` (architecture), `uname -o` (OS type: Android vs Linux), and `termux-info` output. Where a tool or feature is unavailable on a given hardware category, the installer skips it with a clear explanation and logs the skip to `install.log`. No device is treated as the "primary" target — BRIXEL is the original development machine, but it gets no special treatment in the codebase.

---

## 33. Amateur Radio Profile (Planned v0.4)

The **Amateur Radio Profile** (`termuxdeck-profile-hamradio`) is a specialized extension for licensed amateur radio operators. It installs: `fldigi` (where a Termux-compatible headless build exists), `js8call` CLI tools, `wsjtx` audio processing utilities, `hamlib` (the universal ham radio control library with `rigctl` for radio CAT control over USB/Bluetooth serial), and `aprsdroid` companion integration tools. Custom tools include `deckrig` for controlling compatible radios via `rigctl`, `deckaprs` for sending and receiving APRS position and message packets using a connected TNC or audio modem, and `decklog` for maintaining a plain-text QSO (contact) log at `~/.termuxdeck/hamradio/logbook.txt` in ADIF-compatible format. This profile requires a callsign to be set in config (`tdeckconf set hamradio.callsign YOURCALL`) and displays it in the MOTD when active. It is the most hardware-dependent profile and is marked as experimental in v0.4.

---

## 34. IoT & Sensor Profile (Planned v0.4)

The **IoT Profile** (`termuxdeck-profile-iot`) targets cyberdeck builders who connect sensors, microcontrollers, and IoT devices to their Android host via USB OTG serial adapters. It installs: `pyserial` (Python serial communication library), `minicom` (TUI serial terminal), `screen` (which doubles as a serial monitor), `mosquitto-clients` (MQTT publish/subscribe CLI tools for IoT messaging), and `esptool` (ESP8266/ESP32 firmware flashing tool via Python). Custom tools include `deckserial` for quickly connecting to a USB serial device with auto-detected baud rate, `deckmqtt` for publishing and subscribing to MQTT topics from the terminal with a clean display, and `deckflash` for flashing MicroPython or Arduino firmware to connected microcontrollers. A companion `~/.termuxdeck/iot/` directory stores device profiles (name, VID/PID, baud rate, protocol) so frequently used devices can be connected with a single command rather than manually specifying parameters every time.

---

## 35. Accessibility & Narrow Terminal Support

TermuxDeck OS is designed to be fully usable on small phone screens without a Bluetooth or USB keyboard — important because many cyberdeck builds go through phases where the keyboard is disconnected or unavailable. All output from deck tools is designed for a minimum width of **40 columns**, with `--wide` flags available for tools that can use more space when connected to a larger display. The Starship prompt truncates long paths intelligently and stays under 30 characters on narrow screens. The fastfetch ASCII logo has a "narrow" variant (3 lines, 30 columns) automatically selected when the terminal width is below 50 columns (detected via `$COLUMNS`). All color output respects the `NO_COLOR` environment variable for full compatibility with monochrome terminals and screen readers. The `tdeckconf set theme.name ghost` command provides the most readable experience on monochrome or e-ink displays. Documentation includes a dedicated `NARROW_SCREEN.md` guide for optimizing TermuxDeck OS on small displays.

---

## 36. Update Philosophy & Manual Versioning

TermuxDeck OS deliberately adopts a **manual update model** — there is no automatic updater, no background update daemon, and no nag prompts. This is a conscious choice for a system designed for field use and stability: automatic updates in the middle of a session are a liability on a cyberdeck. Package-level updates (the underlying Termux packages like nmap, Python, Node.js) happen via the normal `pkg upgrade` command. OS-layer updates (new features, tool updates, config schema changes) are distributed as new `.deb` package versions and applied by the user when they choose. The `termuxdeck-doctor` utility checks the installed TermuxDeck version against the latest tag in the GitHub repo (one network call, only when explicitly run) and informs the user if a newer version is available, without installing anything. The `CHANGELOG.md` is the authoritative record of what changed in each version, and users are encouraged to read it before upgrading. Breaking config changes are versioned with a migration guide in the changelog.

---

## 37. Testing & Continuous Integration

Every pull request to the TermuxDeck OS repository runs a GitHub Actions CI pipeline that validates the following: shell script linting via `shellcheck` on all `.sh` files, Python linting via `flake8` and type checking via `mypy` on all `.py` files, `.deb` package structure validation (control file format, file permissions, postinst executable bit), JSON schema validation of the default `config.json` template, and a simulated install test in a Docker container running a minimal ARM64 Termux environment (via QEMU emulation). The CI pipeline also runs `termuxdeck-doctor` at the end of the simulated install and fails if any red-status checks are reported. Architecture-specific build jobs produce `.deb` files for all four supported architectures. Release tagging triggers the publish pipeline which signs packages, updates the `Packages.gz` index, and deploys to GitHub Pages. A nightly CI run on the `main` branch tests against the latest Termux package versions to catch upstream breakage early.

---

## 38. Philosophy of Headlessness

The decision to be fully headless — no GUI, no Xorg, no VNC, no web interface by default — is not a limitation but a **design virtue** in TermuxDeck OS. Headlessness means: faster boot, lower RAM usage, lower storage footprint, better battery life, and a forcing function toward mastering the terminal. Every feature, every tool, and every UI in TermuxDeck OS is expressed entirely through text on a terminal. This creates a consistent, predictable, keyboard-driven experience regardless of screen size, resolution, or display availability. The OS is designed to be operated entirely over SSH if needed — every tool produces machine-readable output (via `--json`) and human-readable output (default), and no tool requires an interactive terminal to function. The headless philosophy also means TermuxDeck OS runs well on Android TV boxes, headless ARM servers, and remote devices accessed purely over SSH. The optional `termuxdeck-web` dashboard planned for v0.6 is the sole exception — and even then, it serves a terminal-in-a-browser, not a traditional GUI.

---

## 39. Long-Term Vision — TermuxDeck OS as a Platform

The long-term vision for TermuxDeck OS extends beyond a personal tool collection into a **platform** — a recognized, stable, documented environment that cyberdeck builders can rely on as the foundation of their builds. In the same way that Kali Linux became the standard for pentesting and Raspberry Pi OS became the standard for SBC hobbyists, TermuxDeck OS aims to become the standard for Android-based cyberdeck computing. This means: a stable package API that plugin authors can depend on, a device compatibility database maintained by the community, a recognized version scheme that hardware builders can reference in their build logs, and eventually a presence in cyberdeck community spaces (Hackaday, Reddit, Discord). The project will never chase feature bloat — every addition must serve the cyberdeck use case specifically, stay within the storage budget, and respect the headless philosophy. The original BRIXEL build — a Samsung J3 in a Lego chassis with a Rii keyboard — remains the spiritual reference platform: if it runs well on that, it runs well everywhere.

---

*TermuxDeck OS — Any device. Any architecture. One terminal.*
*MIT License · Open Source · github.com/[maintainer]/termuxdeck*
