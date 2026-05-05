#!/usr/bin/env python3
"""check-upstream.py — Check that all DeckDroid dependencies are still available in Termux repos."""
import urllib.request, json, sys

TERMUX_PACKAGES_API = "https://api.github.com/repos/termux/termux-packages/git/trees/master?recursive=1"
REQUIRED = [
    "zsh", "starship", "fastfetch", "nano", "python", "nodejs",
    "git", "curl", "wget", "nmap", "tcpdump", "tshark", "openssh",
    "pandoc", "gnupg",
]

print("Checking Termux package availability...")
try:
    req = urllib.request.Request(TERMUX_PACKAGES_API, headers={"User-Agent": "deckdroid-ci"})
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read())
    tree_paths = {item["path"] for item in data.get("tree", [])}
except Exception as e:
    print(f"Warning: Could not fetch Termux package tree: {e}")
    sys.exit(0)  # Don't fail nightly on network error

missing = []
for pkg in REQUIRED:
    pkg_path = f"packages/{pkg}"
    if pkg_path in tree_paths:
        print(f"  ✓ {pkg}")
    else:
        print(f"  ✗ {pkg} — NOT FOUND in termux-packages")
        missing.append(pkg)

if missing:
    print(f"\nWarning: {len(missing)} package(s) may be unavailable: {missing}")
    sys.exit(1)
else:
    print(f"\n✓ All {len(REQUIRED)} required packages present in Termux upstream.")
