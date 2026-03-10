#!/usr/bin/env bash
# ============================================================
#  Nmap + Zenmap – installer
#  Target: Ubuntu 24.04 LTS (Noble Numbat)
#  Note: Zenmap may require manual installation via snap or
#        building from source on newer Ubuntu versions
# ============================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

info "Updating package list..."
sudo apt update -y

# Install nmap from official Ubuntu repositories
info "Installing nmap..."
sudo apt install -y nmap
nmap --version

# Check if zenmap is available in repos (may not be in newer Ubuntu)
info "Attempting to install zenmap..."
if apt-cache show zenmap &>/dev/null; then
    sudo apt install -y zenmap
    info "Zenmap installed from repository."
else
    warn "Zenmap not available in Ubuntu 24.04 repositories."
    info "Attempting snap installation..."
    
    # Try snap as alternative
    if command -v snap &>/dev/null; then
        if sudo snap install zenmap 2>/dev/null; then
            info "Zenmap installed via snap."
        else
            warn "Snap installation failed. Trying flatpak..."
            # Try flatpak as fallback
            if command -v flatpak &>/dev/null; then
                if flatpak install -y flathub org.nmap.Zenmap 2>/dev/null; then
                    info "Zenmap installed via flatpak."
                else
                    warn "Flatpak installation failed."
                fi
            fi
        fi
    fi
    
    # Manual download option
    warn "If zenmap is still not installed, you can:"
    echo "  1. Download the .deb from https://nmap.org/download.html"
    echo "  2. Install with: sudo dpkg -i zenmap-*.deb && sudo apt -f install"
    echo "  3. Or use the official AppImage from the nmap website"
fi

# Install additional nmap tools
info "Installing additional nmap utilities..."
sudo apt install -y ncat ndiff 2>/dev/null || true

info "Installation complete!"
nmap --version
