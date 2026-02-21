#!/bin/bash
# install.sh - Deploy quad terminal setup on a fresh machine

# ─── Colors ───────────────────────────────────────────────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
DIM="\033[2m"

# ─── Helpers ──────────────────────────────────────────────────────────────────
print_header() {
    echo ""
    echo -e "${MAGENTA}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}${BOLD}║       🖥️  quad terminal installer  🖥️          ║${RESET}"
    echo -e "${MAGENTA}${BOLD}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
}

print_step() {
    echo -e "${CYAN}${BOLD}▶ $1${RESET}"
}

print_ok() {
    echo -e "  ${GREEN}✔${RESET}  $1"
}

print_skip() {
    echo -e "  ${YELLOW}⊘${RESET}  ${DIM}$1 (skipped — already exists)${RESET}"
}

print_warn() {
    echo -e "  ${YELLOW}⚠${RESET}  $1"
}

print_error() {
    echo -e "  ${RED}✘${RESET}  $1"
}

print_done() {
    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}${BOLD}║           ✅  install complete!              ║${RESET}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "  Run ${CYAN}${BOLD}quad.sh${RESET} from any terminal to launch your quad setup."
    echo -e "  ${DIM}(Restart your shell or run: source ~/.bashrc)${RESET}"
    echo ""
}

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Header ───────────────────────────────────────────────────────────────────
print_header

# ─── Step 1: Install tmux if needed ───────────────────────────────────────────
print_step "Checking for tmux..."
if ! command -v tmux &> /dev/null; then
    print_warn "tmux not found — installing via apt..."
    sudo apt-get install -y tmux &>/dev/null
    if command -v tmux &> /dev/null; then
        print_ok "tmux installed successfully ($(tmux -V))"
    else
        print_error "tmux installation failed. Please install it manually."
        exit 1
    fi
else
    print_ok "tmux already installed ($(tmux -V))"
fi

# ─── Step 2: Create ~/bin if needed ───────────────────────────────────────────
print_step "Ensuring ~/bin exists..."
if [ ! -d "$HOME/bin" ]; then
    mkdir -p "$HOME/bin"
    print_ok "Created ~/bin"
else
    print_skip "~/bin already exists"
fi

# ─── Step 3: Copy quad.sh ─────────────────────────────────────────────────────
print_step "Installing quad.sh -> ~/bin/quad.sh..."
cp "$REPO_DIR/quad.sh" "$HOME/bin/quad.sh"
chmod +x "$HOME/bin/quad.sh"
print_ok "Copied and made executable: ~/bin/quad.sh"

# ─── Step 4: Install .tmux.conf ───────────────────────────────────────────────
print_step "Installing ~/.tmux.conf..."
if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    print_warn "Existing ~/.tmux.conf backed up to ~/.tmux.conf.bak"
fi
cp "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
print_ok "Installed ~/.tmux.conf"
echo -e "     ${DIM}-> Ctrl+Arrow keys to switch panes (no prefix needed)${RESET}"

# ─── Step 5: Add ~/bin to PATH in .bashrc ─────────────────────────────────────
print_step "Checking ~/.bashrc for ~/bin in PATH..."
BASHRC="$HOME/.bashrc"
MARKER="# quad: ~/bin in PATH"

if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    print_skip "~/bin PATH entry already in ~/.bashrc"
else
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo 'export PATH="$HOME/bin:$PATH"' >> "$BASHRC"
    print_ok "Added ~/bin to PATH in ~/.bashrc"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
print_done
