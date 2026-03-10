#!/usr/bin/env bash
# ============================================================
#  IntelliJ IDEA – Desktop & App Menu shortcut installer
#  Target: KDE Plasma on X11, Debian Trixie
# ============================================================

set -euo pipefail

# ── Config ───────────────────────────────────────────────────
IDEA_SRC="/home/aronboliveira/Downloads/idea-IU-253.31033.145"
IDEA_DEST="/opt/idea-IU-253.31033.145"
IDEA_BIN="$IDEA_DEST/bin/idea.sh"
IDEA_ICON="$IDEA_DEST/bin/idea.svg"
DESKTOP_FILE_USER="$HOME/.local/share/applications/jetbrains-idea.desktop"
DESKTOP_FILE_SYSTEM="/usr/share/applications/jetbrains-idea.desktop"
SYMLINK="/usr/local/bin/idea"

# ── Colours ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ── 1. Validate source ───────────────────────────────────────
info "Checking source directory..."
[[ -d "$IDEA_SRC" ]] || error "Source not found: $IDEA_SRC"
[[ -f "$IDEA_SRC/bin/idea.sh" ]] || error "idea.sh not found inside $IDEA_SRC — is the archive fully extracted?"

# ── 2. Move to /opt (requires sudo) ─────────────────────────
if [[ ! -d "$IDEA_DEST" ]]; then
    info "Moving IntelliJ IDEA to /opt ..."
    sudo mv "$IDEA_SRC" "$IDEA_DEST"
    sudo chown -R root:root "$IDEA_DEST"
    sudo chmod -R 755 "$IDEA_DEST"
else
    warn "$IDEA_DEST already exists, skipping move."
fi

# ── 3. Make idea.sh executable ───────────────────────────────
sudo chmod +x "$IDEA_BIN"

# ── 4. Create /usr/local/bin symlink ────────────────────────
if [[ ! -L "$SYMLINK" ]]; then
    info "Creating symlink: $SYMLINK -> $IDEA_BIN"
    sudo ln -s "$IDEA_BIN" "$SYMLINK"
else
    warn "Symlink $SYMLINK already exists, skipping."
fi

# ── 5. Write .desktop file (user scope) ─────────────────────
info "Writing .desktop entry for current user..."
mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE_USER" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Ultimate
GenericName=Java IDE
Comment=Capable and Ergonomic IDE for JVM
Exec=$IDEA_BIN %f
Icon=$IDEA_ICON
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-idea
Categories=Development;IDE;Java;
MimeType=text/x-java;application/x-java-archive;
Keywords=java;kotlin;ide;jvm;intellij;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=$IDEA_BIN
EOF

chmod 644 "$DESKTOP_FILE_USER"
info "User .desktop written: $DESKTOP_FILE_USER"

# ── 6. Write .desktop file (system-wide, optional) ──────────
info "Writing system-wide .desktop entry..."
sudo tee "$DESKTOP_FILE_SYSTEM" > /dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Ultimate
GenericName=Java IDE
Comment=Capable and Ergonomic IDE for JVM
Exec=$IDEA_BIN %f
Icon=$IDEA_ICON
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-idea
Categories=Development;IDE;Java;
MimeType=text/x-java;application/x-java-archive;
Keywords=java;kotlin;ide;jvm;intellij;
Actions=NewWindow;

[Desktop Action NewWindow]
Name=New Window
Exec=$IDEA_BIN
EOF

sudo chmod 644 "$DESKTOP_FILE_SYSTEM"
info "System .desktop written: $DESKTOP_FILE_SYSTEM"

# ── 7. Register with KDE / XDG ──────────────────────────────
info "Refreshing KDE application database..."
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
sudo update-desktop-database /usr/share/applications 2>/dev/null || true

# Notify KDE Plasma specifically
if command -v kbuildsycoca6 &>/dev/null; then
    kbuildsycoca6 --noincremental 2>/dev/null || true
elif command -v kbuildsycoca5 &>/dev/null; then
    kbuildsycoca5 --noincremental 2>/dev/null || true
fi

# ── 8. Create Desktop icon (KDE Plasma) ─────────────────────
PLASMA_DESKTOP="$HOME/Desktop"
if [[ -d "$PLASMA_DESKTOP" ]]; then
    info "Creating clickable desktop icon..."
    cp "$DESKTOP_FILE_USER" "$PLASMA_DESKTOP/jetbrains-idea.desktop"
    # KDE requires the file to be marked as trusted
    chmod +x "$PLASMA_DESKTOP/jetbrains-idea.desktop"
    gio set "$PLASMA_DESKTOP/jetbrains-idea.desktop" metadata::trusted true 2>/dev/null || \
        kwriteconfig6 --file "$PLASMA_DESKTOP/jetbrains-idea.desktop" --group "Desktop Entry" --key X-KDE-Protocols "" 2>/dev/null || true
else
    warn "~/Desktop not found — skipping desktop icon (app menu entry still created)."
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✔ IntelliJ IDEA installed successfully!${NC}"
echo -e "  Run from terminal : ${YELLOW}idea${NC}"
echo -e "  App menu          : ${YELLOW}Applications → Development → IntelliJ IDEA Ultimate${NC}"
echo -e "  Desktop icon      : ${YELLOW}~/Desktop/jetbrains-idea.desktop${NC}"
echo ""
warn "If the desktop icon shows as untrusted, right-click it → 'Allow Launching'."
