#!/usr/bin/env bash
# ============================================================
#  Postman + Android Studio – installer & desktop shortcut
#  Target : KDE Plasma on X11, Ubuntu 25.04 (Plucky Puffin)
#  Author : generated for aronboliveira
# ============================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
section() { echo -e "\n${CYAN}══════════════════════════════════════${NC}"; echo -e "${CYAN}  $*${NC}"; echo -e "${CYAN}══════════════════════════════════════${NC}"; }

DOWNLOADS="$HOME/Downloads"
PLASMA_DESKTOP="$HOME/Desktop"
APPS_DIR="$HOME/.local/share/applications"

# ╔══════════════════════════════════════════════════════════╗
# ║  HELPER: register .desktop with KDE                     ║
# ╚══════════════════════════════════════════════════════════╝
register_kde() {
    local desktop_file="$1"
    update-desktop-database "$APPS_DIR" 2>/dev/null || true
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
    if command -v kbuildsycoca6 &>/dev/null; then
        kbuildsycoca6 --noincremental 2>/dev/null || true
    elif command -v kbuildsycoca5 &>/dev/null; then
        kbuildsycoca5 --noincremental 2>/dev/null || true
    fi
    if [[ -d "$PLASMA_DESKTOP" ]]; then
        cp "$desktop_file" "$PLASMA_DESKTOP/$(basename "$desktop_file")"
        chmod +x "$PLASMA_DESKTOP/$(basename "$desktop_file")"
        gio set "$PLASMA_DESKTOP/$(basename "$desktop_file")" metadata::trusted true 2>/dev/null || true
    fi
}

# ╔══════════════════════════════════════════════════════════╗
# ║  1. SYSTEM DEPENDENCIES                                 ║
# ╚══════════════════════════════════════════════════════════╝
section "Installing system dependencies"

info "Updating package list..."
sudo apt update -qq

# Java (Android Studio needs JDK; bundled JBR covers AS itself,
# but sdkmanager/gradle need a system JDK)
# Ubuntu 25 should have OpenJDK 21 or newer
info "Installing OpenJDK 21..."
sudo apt install -y openjdk-21-jdk || sudo apt install -y openjdk-23-jdk

# Android Studio / KDE / X11 required libs
info "Installing Android Studio required libs..."
sudo apt install -y \
    libc6:amd64 libstdc++6:amd64 \
    zlib1g:amd64 \
    libncurses6 \
    lib32z1 lib32ncurses6 lib32stdc++6 \
    libbz2-1.0 \
    libxext6 libxrender1 libxtst6 libxi6 libfreetype6 \
    libxrandr2 libxcomposite1 libxcursor1 libxdamage1 \
    libfontconfig1 libglib2.0-0t64 \
    libdbus-1-3 \
    libpulse0 \
    libnss3 \
    libxss1 \
    libgbm1 \
    libdrm2 \
    wget curl git unzip

# Enable i386 multiarch (needed for 32-bit Android build tools)
info "Enabling i386 multiarch..."
sudo dpkg --add-architecture i386
sudo apt update -qq

# KVM for Android emulator (optional but strongly recommended)
info "Installing KVM / QEMU for Android emulator acceleration..."
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
if getent group kvm > /dev/null; then
    sudo usermod -aG kvm "$USER"
    info "Added $USER to kvm group."
fi

# ╔══════════════════════════════════════════════════════════╗
# ║  2. POSTMAN                                             ║
# ╚══════════════════════════════════════════════════════════╝
section "Installing Postman"

POSTMAN_SRC=$(find "$DOWNLOADS" -maxdepth 2 -type d -name "Postman" 2>/dev/null | head -n1)
POSTMAN_TARBALL=$(find "$DOWNLOADS" -maxdepth 1 -type f -name "Postman-linux*.tar.gz" 2>/dev/null | head -n1)
POSTMAN_DEST="/opt/Postman"
POSTMAN_BIN="$POSTMAN_DEST/Postman"
POSTMAN_ICON="$POSTMAN_DEST/app/icons/icon_128x128.png"

# Download if neither tarball nor extracted dir found
if [[ -z "$POSTMAN_SRC" && -z "$POSTMAN_TARBALL" ]]; then
    warn "Postman not found in ~/Downloads — downloading now..."
    wget -q --show-progress -O "$DOWNLOADS/Postman-linux-x64.tar.gz" \
        "https://dl.pstmn.io/download/latest/linux64"
    POSTMAN_TARBALL="$DOWNLOADS/Postman-linux-x64.tar.gz"
fi

# Extract if needed
if [[ -z "$POSTMAN_SRC" && -n "$POSTMAN_TARBALL" ]]; then
    info "Extracting $POSTMAN_TARBALL ..."
    tar -xzf "$POSTMAN_TARBALL" -C "$DOWNLOADS"
    POSTMAN_SRC=$(find "$DOWNLOADS" -maxdepth 2 -type d -name "Postman" | head -n1)
fi

[[ -d "$POSTMAN_SRC" ]] || error "Could not locate extracted Postman directory."

# Move to /opt
if [[ ! -d "$POSTMAN_DEST" ]]; then
    info "Moving Postman to /opt ..."
    sudo mv "$POSTMAN_SRC" "$POSTMAN_DEST"
    sudo chown -R root:root "$POSTMAN_DEST"
    sudo chmod -R 755 "$POSTMAN_DEST"
else
    warn "$POSTMAN_DEST already exists, skipping move."
fi

sudo chmod +x "$POSTMAN_BIN"

# Symlink
[[ ! -L /usr/local/bin/postman ]] && sudo ln -s "$POSTMAN_BIN" /usr/local/bin/postman
info "Symlink created: postman → $POSTMAN_BIN"

# .desktop
mkdir -p "$APPS_DIR"
POSTMAN_DESKTOP="$APPS_DIR/postman.desktop"
cat > "$POSTMAN_DESKTOP" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman
GenericName=API Client
Comment=Build, test and document your APIs
Exec=$POSTMAN_BIN
Icon=$POSTMAN_ICON
Terminal=false
StartupNotify=true
StartupWMClass=postman
Categories=Development;Network;WebDevelopment;
Keywords=api;rest;http;graphql;postman;
EOF
chmod 644 "$POSTMAN_DESKTOP"
sudo cp "$POSTMAN_DESKTOP" /usr/share/applications/postman.desktop
register_kde "$POSTMAN_DESKTOP"
info "Postman installed ✔"

# ╔══════════════════════════════════════════════════════════╗
# ║  3. ANDROID STUDIO                                      ║
# ╚══════════════════════════════════════════════════════════╝
section "Installing Android Studio"

AS_SRC=$(find "$DOWNLOADS" -maxdepth 2 -type d -name "android-studio" 2>/dev/null | head -n1)
AS_TARBALL=$(find "$DOWNLOADS" -maxdepth 1 -type f -name "android-studio-*.tar.gz" 2>/dev/null | head -n1)
AS_DEST="/opt/android-studio"
AS_BIN="$AS_DEST/bin/studio.sh"
AS_ICON="$AS_DEST/bin/studio.svg"
SDK_DIR="$HOME/Android/Sdk"

# Download if missing (fetches latest stable redirect)
if [[ -z "$AS_SRC" && -z "$AS_TARBALL" ]]; then
    warn "Android Studio tarball not found in ~/Downloads — downloading now..."
    AS_DL_URL=$(curl -s "https://developer.android.com/studio" \
        | grep -oP 'https://redirector\.gvt1\.com/edgedl/android/studio/ide-zips/[^"]+linux\.tar\.gz' \
        | head -n1)
    if [[ -z "$AS_DL_URL" ]]; then
        error "Could not auto-detect Android Studio download URL. Please download it manually from https://developer.android.com/studio and place the .tar.gz in ~/Downloads, then re-run."
    fi
    wget -q --show-progress -O "$DOWNLOADS/android-studio-linux.tar.gz" "$AS_DL_URL"
    AS_TARBALL="$DOWNLOADS/android-studio-linux.tar.gz"
fi

# Extract if needed
if [[ -z "$AS_SRC" && -n "$AS_TARBALL" ]]; then
    info "Extracting $AS_TARBALL ..."
    tar -xzf "$AS_TARBALL" -C "$DOWNLOADS"
    AS_SRC=$(find "$DOWNLOADS" -maxdepth 2 -type d -name "android-studio" | head -n1)
fi

[[ -d "$AS_SRC" ]] || error "Could not locate extracted Android Studio directory."
[[ -f "$AS_SRC/bin/studio.sh" ]] || error "studio.sh not found inside $AS_SRC"

# Move to /opt
if [[ ! -d "$AS_DEST" ]]; then
    info "Moving Android Studio to /opt ..."
    sudo mv "$AS_SRC" "$AS_DEST"
    sudo chown -R root:root "$AS_DEST"
    sudo chmod -R 755 "$AS_DEST"
else
    warn "$AS_DEST already exists, skipping move."
fi

sudo chmod +x "$AS_BIN"

# Symlink
[[ ! -L /usr/local/bin/studio ]] && sudo ln -s "$AS_BIN" /usr/local/bin/studio
info "Symlink created: studio → $AS_BIN"

# SDK dir
mkdir -p "$SDK_DIR"
info "Android SDK directory ready: $SDK_DIR"

# JAVA_HOME + ANDROID_HOME in ~/.bashrc and ~/.profile
for RC in "$HOME/.bashrc" "$HOME/.profile"; do
    if ! grep -q "ANDROID_HOME" "$RC" 2>/dev/null; then
        cat >> "$RC" <<EOF

# ── Android SDK ──────────────────────────────────────────────
export JAVA_HOME=\$(dirname \$(dirname \$(readlink -f \$(which java))))
export ANDROID_HOME=\$HOME/Android/Sdk
export ANDROID_SDK_ROOT=\$ANDROID_HOME
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
EOF
        info "Android env vars written to $RC"
    else
        warn "ANDROID_HOME already set in $RC, skipping."
    fi
done

# .desktop
AS_DESKTOP="$APPS_DIR/android-studio.desktop"
cat > "$AS_DESKTOP" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
GenericName=Android IDE
Comment=IDE for Android app development
Exec=$AS_BIN %f
Icon=$AS_ICON
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-studio
Categories=Development;IDE;
Keywords=android;kotlin;java;ide;mobile;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=$AS_BIN
EOF
chmod 644 "$AS_DESKTOP"
sudo cp "$AS_DESKTOP" /usr/share/applications/android-studio.desktop
register_kde "$AS_DESKTOP"
info "Android Studio installed ✔"

# ╔══════════════════════════════════════════════════════════╗
# ║  4. SUMMARY                                             ║
# ╚══════════════════════════════════════════════════════════╝
section "All done!"
echo -e "
  ${GREEN}Postman${NC}
    Run : ${YELLOW}postman${NC}
    Menu: Applications → Development → Postman

  ${GREEN}Android Studio${NC}
    Run : ${YELLOW}studio${NC}
    Menu: Applications → Development → Android Studio
    SDK : ${YELLOW}$SDK_DIR${NC}
    Note: On first launch, use the SDK Manager to download
          platform tools, build tools and an emulator image.

  ${YELLOW}⚠  Actions required before rebooting:${NC}
    1. Log out and back in (or reboot) for KVM group + env vars to take effect.
    2. If desktop icons show as untrusted → right-click → 'Allow Launching'.
    3. Source your shell now if you want env vars immediately:
       ${CYAN}source ~/.bashrc${NC}
"
