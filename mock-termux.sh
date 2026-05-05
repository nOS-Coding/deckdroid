#!/usr/bin/env bash
# mock-termux.sh — Mock Termux/Android commands for macOS debugging
# Source this file: source mock-termux.sh

echo -e "\033[1;36mDeckDroid macOS Debug Mode — Mocking Termux commands\033[0m"

# Mock termux-battery-status
termux-battery-status() {
    echo '{"percentage":87,"status":"CHARGING","temperature":32.5,"health":"GOOD"}'
}

# Mock getprop
getprop() {
    case "$1" in
        ro.product.model) echo "MacBook Air (mocked)" ;;
        ro.build.version.release) echo "14.0" ;;
        *) echo "unknown" ;;
    esac
}

# Mock pkg (use brew instead)
pkg() {
    case "$1" in
        install)
            shift
            echo -e "\033[1;33m[mock] pkg install $* → Would run: brew install $*\033[0m"
            # Uncomment to actually install via brew:
            # brew install "$@" 2>/dev/null || true
            ;;
        update) echo -e "\033[1;33m[mock] pkg update → Would run: brew update\033[0m" ;;
        *) command pkg "$@" 2>/dev/null || echo "pkg: command not found (mocked)" ;;
    esac
}

# Mock Python install
install_python_macos() {
    if ! command -v python3 &>/dev/null; then
        echo -e "\033[1;33mInstalling Python via brew...\033[0m"
        brew install python 2>/dev/null || echo "brew not found. Install Python manually."
    else
        echo -e "\033[0;32mPython found: $(python3 --version)\033[0m"
    fi
}

# Mock pip
pip() {
    if ! command -v pip3 &>/dev/null && ! command -v pip &>/dev/null; then
        echo -e "\033[1;33m[mock] pip not found, using python3 -m pip\033[0m"
        python3 -m pip "$@"
    else
        command pip "$@"
    fi
}

# Fix free/uptime for macOS
if ! command -v free &>/dev/null; then
    free() {
        echo "              total        used        free      shared  buff/cache   available"
        echo "Mem:       16GiB        4GiB        8GiB        1GiB        4GiB        11GiB"
    }
fi

# Export mocks
export -f termux-battery-status getprop pkg pip free

echo -e "\033[0;32m✓ Mock environment ready. Run your DeckDroid tools now.\033[0m"
echo -e "\033[0;90m  termux-battery-status, getprop, pkg, free are all mocked\033[0m\n"
