#!/usr/bin/env bash
# ============================================================
#  Android Studio – auto-detect URL, download, install
#  Target : KDE Plasma on X11, Debian 13 Trixie (amd64)
# ============================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
section() { echo -e "\n${CYAN}══════════════════════════════════════${NC}"; \
            echo -e "${CYAN}  $*${NC}"; \
            echo -e "${CYAN}══════════════════════════════════════${NC}"; }

# ── Paths ────────────────────────────────────────────────────
DOWNLOADS="$HOME/Downloads"
AS_DEST="/opt/android-studio"
AS_BIN="$AS_DEST/bin/studio.sh"
SDK_DIR="$HOME/Android/Sdk"
APPS_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$APPS_DIR/android-studio.desktop"
PLASMA_DESKTOP="$HOME/Desktop"

# Known-good fallback URL (Panda 2 / 2025.3.2.6)
FALLBACK_URL="https://dl.google.com/dl/android/studio/ide-zips/2025.3.2.6/android-studio-panda2-linux.tar.gz"

# ╔══════════════════════════════════════════════════════════╗
# ║  1. DEPENDENCIES                                        ║
# ╚══════════════════════════════════════════════════════════╝
section "Installing system dependencies"

sudo apt update -qq
sudo apt install -y \
    openjdk-21-jdk curl wget git unzip \
    libc6:amd64 libstdc++6:amd64 libz1:amd64 \
    libncurses6 libbz2-1.0 \
    libxext6 libxrender1 libxtst6 libxi6 libfreetype6 \
    libxrandr2 libxcomposite1 libxcursor1 libxdamage1 \
    libfontconfig1 libglib2.0-0 libdbus-1-3 \
    libpulse0 libnss3 libxss1 libgbm1 libdrm2

info "Enabling i386 multiarch for Android build tools..."
sudo dpkg --add-architecture i386
sudo apt update -qq
sudo apt install -y \
    lib32z1 lib32stdc++6 \
    libc6:i386 libncurses6:i386 libstdc++6:i386 libbz2-1.0:i386

info "Installing KVM for emulator acceleration..."
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients
if getent group kvm &>/dev/null; then
    sudo usermod -aG kvm "$USER"
    info "Added $USER to kvm group."
fi

# ╔══════════════════════════════════════════════════════════╗
# ║  2. RESOLVE DOWNLOAD URL                                ║
# ╚══════════════════════════════════════════════════════════╝
section "Resolving latest Android Studio download URL"

# Try to scrape the real URL from Google's releases JSON feed
AS_URL=""
info "Querying Google's release feed..."
RELEASE_JSON=$(curl -sf \
    "https://jb.gg/android-studio-releases-list.xml" \
    --max-time 15 2>/dev/null || true)

if [[ -n "$RELEASE_JSON" ]]; then
    # Extract the first linux tar.gz URL from the feed
    AS_URL=$(echo "$RELEASE_JSON" \
        | grep -oP 'https://dl\.google\.com/dl/android/studio/ide-zips/[^"<>]+linux\.tar\.gz' \
        | head -n1 || true)
fi

# Second attempt: parse the developer.android.com/studio page
if [[ -z "$AS_URL" ]]; then
    info "Trying developer.android.com/studio..."
    PAGE=$(curl -sL "https://developer.android.com/studio" \
        --max-time 20 \
        -A "Mozilla/5.0 (X11; Linux x86_64)" 2>/dev/null || true)
    AS_URL=$(echo "$PAGE" \
        | grep -oP 'https://dl\.google\.com/dl/android/studio/ide-zips/[^"]+linux\.tar\.gz' \
        | head -n1 || true)
fi

# Third attempt: known Panda 2 URL directly
if [[ -z "$AS_URL" ]]; then
    warn "Could not auto-detect URL — verifying known Panda 2 URL..."
    HTTP_CODE=$(curl -o /dev/null -sI -w "%{http_code}" \
        --max-time 10 "$FALLBACK_URL" || echo "000")
    if [[ "$HTTP_CODE" == "200" ]]; then
        AS_URL="$FALLBACK_URL"
        info "Fallback URL confirmed live (HTTP 200)."
    else
        error "All URL detection methods failed (HTTP $HTTP_CODE).
Please manually download from https://developer.android.com/studio
and place the .tar.gz in ~/Downloads, then re-run this script."
    fi
fi

info "Download URL: $AS_URL"
TARBALL_NAME=$(basename "$AS_URL")
TARBALL="$DOWNLOADS/$TARBALL_NAME"

# ╔══════════════════════════════════════════════════════════╗
# ║  3. DOWNLOAD                                            ║
# ╚══════════════════════════════════════════════════════════╝
section "Downloading $TARBALL_NAME"

# Check for any existing AS tarball in ~/Downloads first
EXISTING=$(find "$DOWNLOADS" -maxdepth 1 -name "android-studio-*-linux.tar.gz" 2>/dev/null | head -n1 || true)

if [[ -n "$EXISTING" ]]; then
    warn "Found existing tarball: $EXISTING"
    warn "Verifying integrity..."
    if file "$EXISTING" | grep -q "gzip compressed"; then
        TARBALL="$EXISTING"
        TARBALL_NAME=$(basename "$TARBALL")
        info "Existing tarball is valid — skipping download."
    else
        warn "Existing tarball is corrupt — removing and re-downloading."
        rm -f "$EXISTING"
    fi
fi

if [[ ! -f "$TARBALL" ]]; then
    info "Downloading from Google CDN..."
    curl -L \
        --progress-bar \
        --retry 5 \
        --retry-delay 3 \
        --retry-connrefused \
        --output "$TARBALL" \
        "$AS_URL" \
    || error "Download failed. Check your connection."

    # Verify the download
    file "$TARBALL" | grep -q "gzip compressed" \
        || error "Downloaded file is not valid gzip. URL may have changed.
Manually download from https://developer.android.com/studio"

    info "Download verified OK: $TARBALL"
fi

# ╔══════════════════════════════════════════════════════════╗
# ║  4. EXTRACT                                             ║
# ╚══════════════════════════════════════════════════════════╝
section "Extracting archive"

# Clean up any previous partial extraction
[[ -d "$DOWNLOADS/android-studio" ]] && rm -rf "$DOWNLOADS/android-studio"

info "Extracting to $DOWNLOADS ..."
tar -xzf "$TARBALL" -C "$DOWNLOADS"

AS_SRC="$DOWNLOADS/android-studio"
[[ -d "$AS_SRC" ]]               || error "Expected $AS_SRC after extraction — not found."
[[ -f "$AS_SRC/bin/studio.sh" ]] || error "studio.sh missing inside $AS_SRC — archive may be corrupt."
info "Extraction OK."

# ╔══════════════════════════════════════════════════════════╗
# ║  5. INSTALL TO /opt                                     ║
# ╚══════════════════════════════════════════════════════════╝
section "Installing to /opt"

if [[ -d "$AS_DEST" ]]; then
    warn "Removing previous installation at $AS_DEST ..."
    sudo rm -rf "$AS_DEST"
fi

sudo mv "$AS_SRC" "$AS_DEST"
sudo chown -R root:root "$AS_DEST"
sudo chmod -R 755 "$AS_DEST"
sudo chmod +x "$AS_BIN"
info "Installed: $AS_DEST"

# Symlink
[[ -L /usr/local/bin/studio ]] && sudo rm /usr/local/bin/studio
sudo ln -s "$AS_BIN" /usr/local/bin/studio
info "Symlink: studio → $AS_BIN"

# ╔══════════════════════════════════════════════════════════╗
# ║  6. RESOLVE ICON                                        ║
# ╚══════════════════════════════════════════════════════════╝
section "Resolving icon"

AS_ICON=$(find "$AS_DEST/bin" -maxdepth 1 \
    \( -name "studio.svg" -o -name "studio.png" \) 2>/dev/null | head -n1 || true)

# Wider fallback search if not in bin/
if [[ -z "$AS_ICON" ]]; then
    AS_ICON=$(find "$AS_DEST" -maxdepth 4 \
        \( -name "*.svg" -o -name "*.png" \) 2>/dev/null | head -n1 || true)
fi

[[ -n "$AS_ICON" ]] \
    && info "Icon resolved: $AS_ICON" \
    || warn "No icon found — .desktop entry will have no icon."

# ╔══════════════════════════════════════════════════════════╗
# ║  7. .desktop ENTRIES                                    ║
# ╚══════════════════════════════════════════════════════════╝
section "Writing .desktop entries"

mkdir -p "$APPS_DIR"

cat > "$DESKTOP_FILE" <<EOF
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
Keywords=android;kotlin;java;ide;mobile;jetbrains;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=$AS_BIN
EOF

chmod 644 "$DESKTOP_FILE"
sudo cp "$DESKTOP_FILE" /usr/share/applications/android-studio.desktop
sudo chmod 644 /usr/share/applications/android-studio.desktop
info "User .desktop:   $DESKTOP_FILE"
info "System .desktop: /usr/share/applications/android-studio.desktop"

# ╔══════════════════════════════════════════════════════════╗
# ║  8. KDE DESKTOP ICON (trusted)                         ║
# ╚══════════════════════════════════════════════════════════╝
if [[ -d "$PLASMA_DESKTOP" ]]; then
    cp "$DESKTOP_FILE" "$PLASMA_DESKTOP/android-studio.desktop"
    chmod +x "$PLASMA_DESKTOP/android-studio.desktop"
    gio set "$PLASMA_DESKTOP/android-studio.desktop" \
        metadata::trusted true 2>/dev/null \
        && info "Desktop icon marked trusted." \
        || warn "gio unavailable — right-click icon → 'Allow Launching' after install."
else
    warn "~/Desktop not found — skipping desktop icon."
fi

# ╔══════════════════════════════════════════════════════════╗
# ║  9. KDE CACHE REFRESH                                   ║
# ╚══════════════════════════════════════════════════════════╝
section "Refreshing KDE Plasma"

update-desktop-database "$APPS_DIR" 2>/dev/null || true
sudo update-desktop-database /usr/share/applications 2>/dev/null || true

if command -v kbuildsycoca6 &>/dev/null; then
    kbuildsycoca6 --noincremental 2>/dev/null \
        && info "kbuildsycoca6 cache rebuilt." || true
elif command -v kbuildsycoca5 &>/dev/null; then
    kbuildsycoca5 --noincremental 2>/dev/null \
        && info "kbuildsycoca5 cache rebuilt." || true
fi

qdbus org.kde.plasmashell /PlasmaShell \
    org.kde.PlasmaShell.refreshCurrentShell 2>/dev/null \
    && info "Plasma shell refreshed." || true

# ╔══════════════════════════════════════════════════════════╗
# ║  10. ENV VARS                                           ║
# ╚══════════════════════════════════════════════════════════╝
section "Writing environment variables"

mkdir -p "$SDK_DIR"

for RC in "$HOME/.bashrc" "$HOME/.profile"; do
    if ! grep -q "ANDROID_HOME" "$RC" 2>/dev/null; then
        cat >> "$RC" <<'ENVBLOCK'

# ── Android SDK ──────────────────────────────────────────────
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
ENVBLOCK
        info "Env vars written to $RC"
    else
        warn "ANDROID_HOME already present in $RC — skipping."
    fi
done

# ╔══════════════════════════════════════════════════════════╗
# ║  DONE                                                   ║
# ╚══════════════════════════════════════════════════════════╝
section "All done!"
echo -e "
  ${GREEN}Android Studio${NC} installed from: ${CYAN}$TARBALL_NAME${NC}

  Run from terminal  : ${YELLOW}studio${NC}
  App menu           : ${YELLOW}Applications → Development → Android Studio${NC}
  Desktop icon       : ${YELLOW}~/Desktop/android-studio.desktop${NC}
  SDK location       : ${YELLOW}$SDK_DIR${NC}

  ${CYAN}First launch steps:${NC}
    1. The Setup Wizard will run — let it download SDK components.
    2. Tools → SDK Manager  to install platform + build tools.
    3. Tools → Device Manager to create an AVD emulator image.

  ${YELLOW}⚠  Required actions:${NC}
    • Apply env vars now (no reboot needed):
      ${CYAN}source ~/.bashrc${NC}
    • KVM group takes effect on next login/reboot.
    • If desktop icon appears untrusted:
      right-click → 'Allow Launching'
"
