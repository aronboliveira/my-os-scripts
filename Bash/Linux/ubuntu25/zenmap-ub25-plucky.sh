#!/usr/bin/env bash
# ============================================================
#  Nmap + Zenmap – installer
#  Target: Ubuntu 25.04 (Plucky Puffin)
#  Note: Zenmap may require snap/flatpak or manual installation
#        on newer Ubuntu versions as it's been removed from
#        official repositories due to Python 2 dependency
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

# Check if zenmap is available in repos (unlikely in Ubuntu 25)
info "Attempting to install zenmap..."
if apt-cache show zenmap &>/dev/null; then
    sudo apt install -y zenmap
    info "Zenmap installed from repository."
else
    warn "Zenmap not available in Ubuntu 25.04 repositories."
    info "Attempting alternative installations..."
    
    # Try snap as alternative
    if command -v snap &>/dev/null; then
        info "Trying snap installation..."
        if sudo snap install zenmap 2>/dev/null; then
            info "Zenmap installed via snap."
        else
            warn "Snap installation failed."
        fi
    fi
    
    # Try flatpak as fallback
    if ! command -v zenmap &>/dev/null; then
        if command -v flatpak &>/dev/null; then
            info "Trying flatpak installation..."
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
            if flatpak install -y flathub org.nmap.Zenmap 2>/dev/null; then
                info "Zenmap installed via flatpak."
            else
                warn "Flatpak installation failed."
            fi
        fi
    fi
    
    # Manual download option
    if ! command -v zenmap &>/dev/null; then
        warn "Automatic zenmap installation was not successful."
        echo ""
        echo "  ${YELLOW}Manual installation options:${NC}"
        echo "  1. Download the latest .deb/.rpm from https://nmap.org/download.html"
        echo "  2. Install with: sudo dpkg -i zenmap-*.deb && sudo apt -f install"
        echo "  3. Use the official AppImage from the nmap website"
        echo "  4. Install from source: https://github.com/nmap/nmap"
        echo ""
    fi
fi

# Install additional nmap tools
info "Installing additional nmap utilities..."
sudo apt install -y ncat ndiff 2>/dev/null || warn "Some nmap utilities may not be available."

info "Installation complete!"
nmap --version
