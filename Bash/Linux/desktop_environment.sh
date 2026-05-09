  #region Desktop_Environment
    ## @description Purge Cinnamon DE and its config files, reconfigure GDM3.
    ## @flag --keep-config  Keep ~/.cinnamon and ~/.config/cinnamon-session
    remove_cinnamon() {
      local keep_cfg=0
      while [[ "${1:-}" == --* ]]; do
        case "$1" in
          --keep-config) keep_cfg=1; shift ;;
          --help|-h) echo -e "📖 \033[1mremove-cinnamon\033[0m [--keep-config]"; return 0 ;;
          *) echo -e "❌ Unknown flag: $1"; return 1 ;;
        esac
      done
      echo -e "🗑️  \033[1;36m══ Removing Cinnamon ══\033[0m"
      echo -e "⚠️  \033[1;33mThis will purge Cinnamon DE packages.\033[0m"
      read -rp "   Continue? [y/N]: " ans
      [[ "$ans" =~ ^[Yy] ]] || { echo "Aborted."; return 0; }
      sudo apt purge -y cinnamon-desktop-environment cinnamon-session cinnamon-screensaver cinnamon cinnamon-common muffin 2>/dev/null || true
      sudo apt autoremove --purge -y
      sudo dpkg-reconfigure gdm3 2>/dev/null || true
      if (( ! keep_cfg )); then
        rm -vrf ~/.cinnamon 2>/dev/null || true
        rm -rf ~/.config/cinnamon-session 2>/dev/null || true
      fi
      echo -e "✅ \033[1;32mCinnamon removed.\033[0m"
    }
    alias remove-cinnamon='remove_cinnamon'
    ## @description Set Nautilus as default file manager (replaces Thunar/other).
    ## @flag --help  Show usage
    set_nautilus_default() {
      if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        echo -e "📖 \033[1mset-nautilus-default\033[0m"
        echo "Sets Nautilus as default file manager for directories and file:// scheme."
        echo "Also updates XFCE helpers and rebuilds MIME cache."
        return 0
      fi
      echo -e "📁 \033[1;36m══ Setting Nautilus as Default File Manager ══\033[0m"

      # 1. Set Nautilus as default for directories
      xdg-mime default org.gnome.Nautilus.desktop inode/directory
      echo -e "  ✓ Set Nautilus for inode/directory"

      # 2. Set Nautilus as file:// scheme handler
      xdg-mime default org.gnome.Nautilus.desktop x-scheme-handler/file
      echo -e "  ✓ Set Nautilus for x-scheme-handler/file"

      # 3. Fix XFCE helpers config
      mkdir -p ~/.config/xfce4
      echo -e "WebBrowser=brave-browser\nFileManager=nautilus" > ~/.config/xfce4/helpers.rc
      echo -e "  ✓ Updated XFCE helpers.rc"

      # 4. Replace mousepad with GNOME Text Editor for zero-size files (optional)
      if [ -f ~/.config/mimeapps.list ]; then
        sed -i 's|application/x-zerosize=org.xfce.mousepad.desktop|application/x-zerosize=org.gnome.TextEditor.desktop|' ~/.config/mimeapps.list
        echo -e "  ✓ Updated zero-size file handler"
      fi

      # 5. Rebuild MIME cache
      update-desktop-database ~/.local/share/applications/ 2>/dev/null
      echo -e "  ✓ Rebuilt MIME cache"

      echo -e "✅ \033[1;32mNautilus is now the default file manager.\033[0m"
    }
    alias set-nautilus-default='set_nautilus_default'
    ## @description Hide Thunar from MIME associations (user-level override).
    ## @flag --help  Show usage
    hide_thunar_mime() {
      if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        echo -e "📖 \033[1mhide-thunar-mime\033[0m"
        echo "Creates a user-level override to hide Thunar from file associations."
        return 0
      fi
      echo -e "🙈 \033[1;36m══ Hiding Thunar from MIME Associations ══\033[0m"

      mkdir -p ~/.local/share/applications

      if [ -f /usr/share/applications/thunar.desktop ]; then
        cp /usr/share/applications/thunar.desktop ~/.local/share/applications/
        echo "NoDisplay=true" >> ~/.local/share/applications/thunar.desktop
        echo "MimeType=" >> ~/.local/share/applications/thunar.desktop
        echo -e "  ✓ Created user thunar.desktop override"
      else
        echo -e "  ⚠️  /usr/share/applications/thunar.desktop not found"
      fi

      update-desktop-database ~/.local/share/applications/
      echo -e "  ✓ Rebuilt MIME cache"

      echo -e "✅ \033[1;32mThunar hidden from MIME associations.\033[0m"
    }
    alias hide-thunar-mime='hide_thunar_mime'
    ## @description List running compositor/window manager processes.
    alias ps-compositors='ps aux | grep -E "(gnome-shell|xfwm4|mutter|kwin|compositor)" | grep -v grep'
    ## @description Show Mutter experimental features.
    alias get-mutter-features='gsettings get org.gnome.mutter experimental-features 2>/dev/null || echo "Mutter settings not available"'
    ## @description Reset Mutter experimental features to empty (with confirmation).
    reset_mutter_features() {
      echo -e "\033[1;33m⚠️  This will reset org.gnome.mutter experimental-features to []\033[0m"
      local current
      current=$(gsettings get org.gnome.mutter experimental-features 2>/dev/null)
      echo "  Current value: ${current:-unknown}"
      read -rp "Proceed? (y/N): " confirm
      if [[ ! "$confirm" =~ ^[yY] ]]; then
        echo "Aborted."
        return 0
      fi
      gsettings set org.gnome.mutter experimental-features "[]"
      echo -e "✅ \033[1;32mMutter experimental features reset.\033[0m"
    }
    alias reset-mutter-features='reset_mutter_features'
    ## @description Show root window geometry (width, height, depth).
    alias xwin-root-info='xwininfo -root 2>/dev/null | grep -E "(Width|Height|Depth)"'
    ## @description List connected monitors via xrandr.
    alias ls-monitors='xrandr --listmonitors 2>/dev/null'
    ## @description Detect connected monitors via EDID and audit panel technology (IPS/VA/TN/OLED) by hardware ID.
    detect_and_audit_monitors() {
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║          MONITOR PANEL TECHNOLOGY AUDIT                   ║"
        echo "║          Generated: $(date '+%Y-%m-%d %H:%M:%S')                      ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo ""
        
        # Extract EDID data and parse manufacturer + product codes
        local raw_data=$(xrandr --verbose 2>/dev/null | awk '
            /EDID:/ { 
                in_edid = 1
                edid_lines = 0
                next
            }
            in_edid {
                if ($0 ~ /^[[:space:]]*$/) {
                    in_edid = 0
                    next
                }
                # Remove all whitespace and concatenate
                gsub(/[[:space:]]/, "")
                edid_hex = edid_hex $0
                edid_lines++
                if (edid_lines >= 8) {
                    # Extract bytes 8-11 (manufacturer ID and product code)
                    # Manufacturer: bytes 8-9 (big-endian)
                    # Product Code: bytes 10-11 (little-endian, needs swap)
                    mfr = substr(edid_hex, 17, 4)
                    prod_low = substr(edid_hex, 21, 2)
                    prod_high = substr(edid_hex, 23, 2)
                    # Construct hardware signature
                    print mfr prod_high prod_low
                    in_edid = 0
                    edid_hex = ""
                    edid_lines = 0
                }
            }
        ')
        
        if [ -z "$raw_data" ]; then
            echo "❌ ERROR: No EDID data detected"
            echo "   Possible causes:"
            echo "   • No monitors connected"
            echo "   • GPU driver blocking DDC/CI"
            echo "   • xrandr not available"
            return 1
        fi
        
        local monitor_num=0
        
        echo "┌────────────────────────────────────────────────────────────┐"
        printf "│ %-5s │ %-12s │ %-35s │\n" "PORT" "HARDWARE_ID" "PANEL TECHNOLOGY"
        echo "├────────────────────────────────────────────────────────────┤"
        
        # Get display port names for context
        local ports=$(xrandr | grep " connected" | awk '{print $1}')
        local port_array=($ports)
        
        for hw_id in $raw_data; do
            local port="${port_array[$monitor_num]:-UNKNOWN}"
            monitor_num=$((monitor_num + 1))
            
            printf "│ %-5s │ %-12s │ " "$port" "$hw_id"
            
            case "$hw_id" in
                #============================================================
                # DELL - Professional/Gaming Monitors
                #============================================================
                "10ac423d") echo "✓ IPS Panel (Dell P2423D Professional)" ;;
                "10ac423c") echo "✓ IPS Panel (Dell P2723D Professional)" ;;
                "10ac411a") echo "✓ IPS Panel (Dell S2421HGF Gaming)" ;;
                "10ac4110") echo "⚠ TN Panel (Dell E2020H Essential)" ;;
                "10ac40b3") echo "✓ IPS Panel (Dell UltraSharp U2722DE)" ;;
                "10aca1af") echo "★ QD-OLED (Alienware AW3423DW)" ;;
                "10aca1b3") echo "★ QD-OLED (Alienware AW3423DWF)" ;;
                "10ac41b9") echo "✓ IPS Panel (Dell S2722DGM)" ;;
                
                #============================================================
                # LG - UltraGear Gaming / UltraWide
                #============================================================
                "1e6d5bee") echo "✓ IPS Panel (LG 24GS60F UltraGear 180Hz)" ;;
                "1e6d5b3e") echo "✓ IPS Panel (LG 24GN600 144Hz)" ;;
                "1e6d5b5c") echo "✓ IPS Panel (LG 29WP500 UltraWide)" ;;
                "1e6d5acd") echo "⚠ TN Panel (LG 20MK400H Budget)" ;;
                "1e6d5c"*)  echo "★ OLED Panel (LG OLED Series)" ;;
                "1e6d5e"*)  echo "✓ IPS Panel (LG UltraFine Series)" ;;
                "1e6d77"*)  echo "✓ IPS Panel (LG UltraGear High-End)" ;;
                
                #============================================================
                # SAMSUNG - Odyssey Gaming / Professional
                #============================================================
                "4c2d0d2c") echo "⚙ VA Panel (Samsung Odyssey G3 FHD)" ;;
                "4c2d0d2a") echo "✓ IPS Panel (Samsung T350 FHD)" ;;
                "4c2d0c"*)  echo "⚙ VA Panel (Samsung Odyssey Gaming)" ;;
                "4c2d0e"*)  echo "✓ IPS Panel (Samsung Professional)" ;;
                "4c2d06"*)  echo "★ QLED Panel (Samsung High-End)" ;;
                
                #============================================================
                # AOC - Gaming/Budget
                #============================================================
                "05e324g2") echo "✓ IPS Panel (AOC 24G2 Hero)" ;;
                "05e32590") echo "⚠ TN Panel (AOC G2590FX Speed)" ;;
                "05e327"*)  echo "✓ IPS Panel (AOC 27G2 Series)" ;;
                "05e325"*)  echo "⚙ VA Panel (AOC Curved Series)" ;;
                
                #============================================================
                # ASUS - ROG/TUF Gaming
                #============================================================
                "06b3"*)    echo "✓ IPS Panel (ASUS ROG/TUF Series)" ;;
                
                #============================================================
                # BenQ - Gaming/Professional
                #============================================================
                "09d1"*)    echo "✓ IPS Panel (BenQ Professional)" ;;
                
                #============================================================
                # ViewSonic - Professional/Gaming
                #============================================================
                "5a63"*)    echo "✓ IPS Panel (ViewSonic Professional)" ;;
                
                #============================================================
                # ACER/Predator
                #============================================================
                "4c7"*)     echo "✓ IPS Panel (Acer/Predator)" ;;
                
                #============================================================
                # WHITE LABEL / OEM PANELS (Brazilian Market Common)
                #============================================================
                "09e5"*)    echo "≈ IPS-like (BOE Factory - Mancer/Acer OEM)" ;;
                "1224"*)    echo "≈ VA-like (HKC Factory - Concórdia/Curved)" ;;
                "0dae"*)    echo "≈ IPS-like (Innolux Panel - Pichau/Mancer)" ;;
                "3dae"*)    echo "≈ VA-like (Panda Panel - Budget Import)" ;;
                "30e4"*)    echo "≈ IPS-like (LG Display OEM)" ;;
                "4dd9"*)    echo "≈ VA-like (Sharp OEM Panel)" ;;
                "22f0"*)    echo "≈ IPS-like (AUO Panel - Generic)" ;;
                
                #============================================================
                # UNKNOWN / UNRECOGNIZED
                #============================================================
                *)          echo "⚠ UNKNOWN (Hardware ID not in database)" ;;
            esac
            echo "│"
        done
        
        echo "└────────────────────────────────────────────────────────────┘"
        echo ""
        echo "LEGEND:"
        echo "  ✓ IPS   = Wide viewing angles, accurate colors (Premium)"
        echo "  ⚙ VA    = High contrast, curved options (Mid-range)"
        echo "  ⚠ TN    = Fast response, narrow angles (Budget/Esports)"
        echo "  ★ OLED  = Perfect blacks, premium quality (High-end)"
        echo "  ≈       = OEM panel (technology estimated from signature)"
        echo ""
        echo "Total monitors detected: $monitor_num"
    }
    ## @description Alias for detect_and_audit_monitors.
    alias audit-monitors='detect_and_audit_monitors'
    ## @description Alias for detect_and_audit_monitors.
    alias ls-display-techs='detect_and_audit_monitors'
    ## @description Check availability of DE-related programs (KDE/GNOME/XFCE).
    check_de_programs() {
      local programs=(
        "plasma-systemmonitor"
        "gnome-system-monitor"
        "plasma-discover"
        "system-config-printer"
        "plasma-interactiveconsole"
        "plasma-emojier"
        "plasma-open-settings"
        "ksystemstats"
      )
      for prog in "${programs[@]}"; do
        echo -e "\033[1;36m=== $prog ===\033[0m"
        if command -v "$prog" &>/dev/null; then
          echo -e "  \033[1;32m✓\033[0m $(which "$prog")"
        else
          echo -e "  \033[1;31m✗\033[0m not found"
        fi
        echo ""
      done
    }
    alias check-de-programs='check_de_programs'
    ## @description Mark a .desktop file as trusted for GNOME/DI NG.
    ## @param $1 {string} filename or path - Desktop entry file to trust
    trust_desktop_entry() {
      local input="$1"
      if [[ -z "$input" ]]; then
        echo "Usage: trust_desktop_entry <filename|path>" >&2
        return 1
      fi
      local desktop_file
      if [[ "$input" == "$HOME/Desktop/"* ]]; then
        desktop_file="$input"
      else
        desktop_file="$HOME/Desktop/$(basename "$input")"
      fi
      if [[ ! -f "$desktop_file" ]]; then
        echo "Error: '$(basename "$desktop_file")' not found on the Desktop ($desktop_file)." >&2
        return 1
      fi
      if [[ "$desktop_file" != *.desktop ]]; then
        echo "Warning: '$(basename "$desktop_file")' does not have a .desktop extension." >&2
      fi
      local desktop_dir_perms
      desktop_dir_perms=$(stat -c "%a" "$HOME/Desktop" 2>/dev/null)
      if [[ "${desktop_dir_perms: -1}" =~ [2367] ]]; then
        echo "Warning: ~/Desktop is world-writable (mode $desktop_dir_perms). DING will still reject the file as untrusted." >&2
        echo "         Fix with: chmod o-w \"$HOME/Desktop\"" >&2
      fi
      chmod 755 "$desktop_file"
      gio set "$desktop_file" metadata::trusted true
      echo "✓ '$(basename "$desktop_file")' marked trusted with 755 permissions."
      local distro_id distro_ver
      distro_id=$(. /etc/os-release 2>/dev/null && echo "${ID:-unknown}")
      distro_ver=$(. /etc/os-release 2>/dev/null && echo "${VERSION_ID:-0}")
      case "${distro_id}:${distro_ver}" in

        ubuntu:25.*)
          if pgrep -f 'ding@rastersoft' > /dev/null 2>&1; then
            kill "$(pgrep -f 'ding@rastersoft')" 2>/dev/null
            echo "✓ DING restarted (Ubuntu 25)."
          else
            echo "Info: DING process not found on Ubuntu 25 — no restart needed."
          fi
          ;;

        ubuntu:24.*)
          if pgrep -f 'ding@rastersoft' > /dev/null 2>&1; then
            kill "$(pgrep -f 'ding@rastersoft')" 2>/dev/null
            sleep 1
            echo "✓ DING restarted (Ubuntu 24)."
          else
            echo "Info: DING process not found on Ubuntu 24 — no restart needed."
          fi
          ;;

        debian:13)
          if pgrep -f 'ding@rastersoft' > /dev/null 2>&1; then
            kill "$(pgrep -f 'ding@rastersoft')" 2>/dev/null
            echo "✓ DING restarted (Debian 13)."
          elif [[ -d "$HOME/.local/share/gnome-shell/extensions/ding@rastersoft.com" ]] || \
              [[ -d "/usr/share/gnome-shell/extensions/ding@rastersoft.com" ]]; then
            echo "Info: DING extension found but not running on Debian 13." >&2
            echo "      Enable it with: gnome-extensions enable ding@rastersoft.com" >&2
          else
            echo "Info: DING not installed — trust metadata was set, but desktop icons" >&2
            echo "      may be managed directly by Nautilus on Debian 13." >&2
          fi
          ;;

        *)
          echo "Warning: unrecognised distro '${distro_id} ${distro_ver}', attempting generic DING restart." >&2
          if pgrep -f 'ding@rastersoft' > /dev/null 2>&1; then
            kill "$(pgrep -f 'ding@rastersoft')" 2>/dev/null
            echo "✓ DING restarted (generic)."
          else
            echo "Info: DING process not found — no restart needed."
          fi
          ;;

      esac
    }
    ## @description Mark desktop entry as trusted.
    alias trust-desktop='trust_desktop_entry'
    ## @description Install essential KDE packages for GTK integration and productivity.
    install_kde_apt_packages() {
      echo -e "📦 \033[1;36mInstalling KDE packages...\033[0m"
      sudo apt update && sudo apt install -y \
        kde-config-gtk-style \
        kde-config-gtk-style-preview \
        plasma-discover-backend-flatpak \
        kdeconnect \
        dolphin-plugins \
        okular
      echo -e "✅ \033[1;32mKDE packages installed.\033[0m"
    }
    alias install-kde-pkgs='install_kde_apt_packages'
    ## @description Ensure ~/Templates directory and "Empty File" template exist.
    ensure_templates_dir() {
      [[ -d "$HOME/Templates" ]] || mkdir -p "$HOME/Templates"
      [[ -f "$HOME/Templates/Empty File" ]] || touch "$HOME/Templates/Empty File"
      echo -e "✅ \033[1;32m~/Templates and 'Empty File' template ensured.\033[0m"
    }
    alias ensure-templates='ensure_templates_dir'
    ## @description Install Nautilus extensions and ensure Templates directory.
    install_nautilus_extensions() {
      echo -e "📦 \033[1;36mInstalling Nautilus extensions...\033[0m"
      sudo apt update && sudo apt install -y \
        nautilus-extension-gnome-terminal \
        nautilus-admin \
        nautilus-image-converter
      ensure_templates_dir
      echo -e "✅ \033[1;32mNautilus extensions installed.\033[0m"
    }
    alias install-nautilus-ext='install_nautilus_extensions'
    ## @description Create a Nautilus script for creating new files via Zenity dialog.
    create_nautilus_newfile_script() {
      local script_dir="$HOME/.local/share/nautilus/scripts"
      local script_path="$script_dir/New File"
      mkdir -p "$script_dir"
      cat > "$script_path" << 'EOF'
#!/bin/bash
# Nautilus script: Create New File with Zenity dialog

uri_decode() {
  printf '%b' "${1//%/\\x}"
}

# Resolve current directory: prefer URI, fallback to selected file's dir, then PWD
if [ -n "$NAUTILUS_SCRIPT_CURRENT_URI" ]; then
    CURRENT_DIR=$(uri_decode "${NAUTILUS_SCRIPT_CURRENT_URI#file://}")
elif [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    CURRENT_DIR=$(dirname "$(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | head -n1)")
else
    CURRENT_DIR="$PWD"
fi

FILENAME=$(zenity --entry --text="Enter filename:" --title="Create New File" 2>/dev/null)
if [ -n "$FILENAME" ]; then
    FULL_PATH="$CURRENT_DIR/$FILENAME"
    if touch "$FULL_PATH"; then
        zenity --info --text="Created: $FULL_PATH" --title="Done" 2>/dev/null
    else
        zenity --error --text="Failed to create file in:\n$CURRENT_DIR" --title="Error" 2>/dev/null
    fi
fi
EOF
      chmod +x "$script_path"
      echo -e "✅ \033[1;32mNautilus 'New File' script created at:\033[0m $script_path"
    }
    alias create-nautilus-newfile='create_nautilus_newfile_script'
    ## @description Install Docker and comprehensive dev tools on Debian 13 Trixie only.
    ## @note Uses bookworm Docker repo; installs NVM, Node 24, PHP 8.4, Brave, and many CLI tools.
    install_debian_trixie_devtools() {
      local distro_id distro_codename
      distro_id=$(. /etc/os-release 2>/dev/null && echo "${ID:-}")
      distro_codename=$(. /etc/os-release 2>/dev/null && echo "${VERSION_CODENAME:-}")

      if [[ "$distro_id" != "debian" ]] || [[ "$distro_codename" != "trixie" ]]; then
        echo -e "❌ \033[1;31mThis function is only for Debian 13 (Trixie).\033[0m"
        echo -e "   Detected: $distro_id $distro_codename"
        return 1
      fi

      echo -e "🚀 \033[1;36mStarting Debian Trixie devtools installation...\033[0m"

      sudo apt-get update && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ca-certificates curl gnupg lsb-release apt-transport-https && \
      sudo mkdir -p /etc/apt/keyrings && \
      sudo rm -f /etc/apt/keyrings/docker.gpg && \
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
      sudo apt-get update && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential curl wget git htop tmux openssh-server linux-headers-$(uname -r) \
        apt-transport-https ca-certificates lsb-release gcc g++ gdb clang llvm make cmake \
        python3 python3-pip python3-venv python3-dev openjdk-21-jdk maven gradle golang-go \
        rustc cargo ruby-full perl cpanminus lua5.4 luarocks autoconf automake libtool \
        pkg-config meson ninja-build bison flex gettext patchelf gitk git-gui subversion \
        mercurial gh meld valgrind strace ltrace linux-perf heaptrack massif-visualizer \
        sqlite3 libsqlite3-dev postgresql postgresql-client libpq-dev mariadb-server \
        mariadb-client libmariadb-dev redis-server nginx apache2 haproxy squid podman \
        buildah skopeo net-tools iproute2 nmap tcpdump wireshark httpie jq vim neovim \
        nano emacs zsh fish fonts-powerline fzf ripgrep fd-find bat tree tldr-py man-db \
        manpages-dev texlive pandoc doxygen graphviz python3-sphinx libssl-dev libreadline-dev \
        zlib1g-dev libbz2-dev libffi-dev libncurses-dev libxml2-dev libxslt1-dev libyaml-dev \
        unzip zip rsync sshfs screenfetch ack silversearcher-ag shellcheck shfmt moreutils \
        parallel docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
      curl -fsS https://dl.brave.com/install.sh | sh && \
      /bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.4)" && \
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && \
      export NVM_DIR="$HOME/.nvm" && \
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
      nvm install 24 && \
      sudo systemctl start docker && \
      sudo systemctl enable docker && \
      sudo usermod -aG docker "$USER" && \
      echo -e "\\n✅ \033[1;32mInstallation complete!\033[0m" && \
      echo -e "   Docker: $(docker --version)" && \
      echo -e "   PHP: $(php -v | head -n1)" && \
      echo -e "   Composer: $(composer --version 2>/dev/null || echo 'run newgrp docker first')" && \
      echo -e "   Node: $(node -v)" && \
      echo -e "   npm: $(npm -v)"
    }
    alias install-trixie-devtools='install_debian_trixie_devtools'
    ## @description Show recent journal entries related to screen recording, PipeWire, and desktop portals.
    ## @param $1 {int} tail_lines - Number of tail lines to show per section (default: 50)
    show_journal_screens() {
      local tail_lines="${1:-50}"
      echo -e "📰 \033[1;36mShowing recent journal entries related to screen recording and desktop portals...\033[0m"
      journalctl --user -b | grep -iE 'pipewire|screencast|gnome-shell.*screencast|desktop-portal|mutter' | tail -n "$tail_lines"
      sleep 2
      echo -e "\n🔍 \033[1;36mFiltering for screencast-related entries...\033[0m"
      sleep 2
      journalctl --user -b -u gnome-shell | grep -i screencast | tail -n "$tail_lines"
      sleep 2
        printf "[*] Checking %s...\n" "for"
      journalctl --user -u gnome-shell -n 100 --no-pager | grep -i -E "(screencast|error|warning|fail|crash)" | tail -n "$tail_lines"
      sleep 2
      echo -e "\n👀 \033[1;36mListing relevant active processes...\033[0m"
      sleep 5
      ps aux | grep -iE 'pipewire|wireplumber|screencast|desktop-portal' | grep -v grep
    }
    alias show-journal-screens='show_journal_screens'
    alias ls-journal-screens='show-journal-screens'
    alias echo-journal-screens='show-journal-screens'

    _require_gnome_desktop() {
      if [[ ! "${XDG_CURRENT_DESKTOP,,}" =~ gnome ]]; then
        printf "Error: Desktop environment is not GNOME (current: %s).\n" "${XDG_CURRENT_DESKTOP:-unset}" >&2
        return 1
      fi
    }

    ## @description Set the default GNOME application for a MIME type via xdg-mime default.
    ## @param $1 {string} app - GNOME application name (e.g., Nautilus, TextEditor). Must exist as org.gnome.<app>.desktop
    ## @param $2 {string} mimetype - MIME type to associate (e.g., inode/directory, text/plain)
    def_gnome_xmime() {
      _require_gnome_desktop || return 1
      local app="${1:?Usage: def-org-gnome-xmime <app> <mimetype>}"
      local mimetype="${2:?Usage: def-org-gnome-xmime <app> <mimetype>}"
      local desktop_file="org.gnome.${app}.desktop"
      if [[ ! -f "/usr/share/applications/${desktop_file}" && ! -f "${HOME}/.local/share/applications/${desktop_file}" ]]; then
        printf "Error: Desktop file '%s' not found in /usr/share/applications/ or ~/.local/share/applications/.\n" "$desktop_file" >&2
        printf "Available org.gnome .desktop files:\n" >&2
        ls /usr/share/applications/org.gnome.*.desktop ~/.local/share/applications/org.gnome.*.desktop 2>/dev/null | sed 's|.*/||' >&2
        return 1
      fi
      xdg-mime default "$desktop_file" "$mimetype" && update-desktop-database ~/.local/share/applications/ 2>/dev/null
    }
    alias def-org-gnome-xmime='def_gnome_xmime'
    ## @description Query the default application for a MIME type via xdg-mime query default.
    ## @param $1 {string} mimetype - MIME type to query (e.g., inode/directory, text/plain, application/pdf)
    get_gnome_xmime() {
      _require_gnome_desktop || return 1
      local mimetype="${1:?Usage: get-org-gnome-xmime <mimetype>}"
      xdg-mime query default "$mimetype"
    }
    alias get-org-gnome-xmime='get_gnome_xmime'
    ## @description Set the default GNOME application for a MIME type (alias for def-org-gnome-xmime).
    ## @param $1 {string} app - GNOME application name (e.g., Nautilus, TextEditor)
    ## @param $2 {string} mimetype - MIME type to associate (e.g., inode/directory, text/plain)
    set_gnome_xmime() {
      def_gnome_xmime "$@"
    }
    alias set-org-gnome-xmime='set_gnome_xmime'
    ## @description Reset a GNOME gsettings key to its default value via gsettings reset.
    ## @param $1 {string} schema_suffix - Schema suffix after org.gnome. (e.g., desktop.interface, shell)
    ## @param $2 {string} key - Key name to reset (e.g., gtk-theme, color-scheme)
    def_gnome_gset() {
      _require_gnome_desktop || return 1
      local schema_suffix="${1:?Usage: def-org-gnome-gset <schema_suffix> <key>}"
      local key="${2:?Usage: def-org-gnome-gset <schema_suffix> <key>}"
      local schema="org.gnome.${schema_suffix}"
      if ! gsettings list-keys "$schema" &>/dev/null; then
        printf "Error: Schema '%s' not found.\nAvailable org.gnome schemas:\n" "$schema" >&2
        gsettings list-schemas 2>/dev/null | grep '^org\.gnome\.' | sort >&2
        return 1
      fi
      if ! gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
        printf "Error: Key '%s' not found in schema '%s'.\nAvailable keys:\n" "$key" "$schema" >&2
        gsettings list-keys "$schema" 2>/dev/null >&2
        return 1
      fi
      gsettings reset "$schema" "$key"
    }
    alias def-org-gnome-gset='def_gnome_gset'
    ## @description Get a GNOME gsettings value via gsettings get.
    ## @param $1 {string} schema_suffix - Schema suffix after org.gnome. (e.g., desktop.interface, shell)
    ## @param $2 {string} key - Key name to get (e.g., gtk-theme, color-scheme)
    get_gnome_gset() {
      _require_gnome_desktop || return 1
      local schema_suffix="${1:?Usage: get-org-gnome-gset <schema_suffix> <key>}"
      local key="${2:?Usage: get-org-gnome-gset <schema_suffix> <key>}"
      local schema="org.gnome.${schema_suffix}"
      if ! gsettings list-keys "$schema" &>/dev/null; then
        printf "Error: Schema '%s' not found.\nAvailable org.gnome schemas:\n" "$schema" >&2
        gsettings list-schemas 2>/dev/null | grep '^org\.gnome\.' | sort >&2
        return 1
      fi
      if ! gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
        printf "Error: Key '%s' not found in schema '%s'.\nAvailable keys:\n" "$key" "$schema" >&2
        gsettings list-keys "$schema" 2>/dev/null >&2
        return 1
      fi
      gsettings get "$schema" "$key"
    }
    alias get-org-gnome-gset='get_gnome_gset'
    ## @description Set a GNOME gsettings value via gsettings set, with schema/key/value validation.
    ## @param $1 {string} schema_suffix - Schema suffix after org.gnome. (e.g., desktop.interface, shell)
    ## @param $2 {string} key - Key name to set (e.g., gtk-theme, color-scheme)
    ## @param $3 {string} value - Value to set (must match the key's type/range)
    set_gnome_gset() {
      _require_gnome_desktop || return 1
      local schema_suffix="${1:?Usage: set-org-gnome-gset <schema_suffix> <key> <value>}"
      local key="${2:?Usage: set-org-gnome-gset <schema_suffix> <key> <value>}"
      local value="${3:?Usage: set-org-gnome-gset <schema_suffix> <key> <value>}"
      local schema="org.gnome.${schema_suffix}"
      if ! gsettings list-keys "$schema" &>/dev/null; then
        printf "Error: Schema '%s' not found.\nAvailable org.gnome schemas:\n" "$schema" >&2
        gsettings list-schemas 2>/dev/null | grep '^org\.gnome\.' | sort >&2
        return 1
      fi
      if ! gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
        printf "Error: Key '%s' not found in schema '%s'.\nAvailable keys:\n" "$key" "$schema" >&2
        gsettings list-keys "$schema" 2>/dev/null >&2
        return 1
      fi
      if ! gsettings writable "$schema" "$key" 2>/dev/null | grep -q true; then
        printf "Error: Key '%s' in schema '%s' is not writable.\n" "$key" "$schema" >&2
        return 1
      fi
      local range_info
      range_info=$(gsettings range "$schema" "$key" 2>/dev/null)
      if [[ "$range_info" == enum* ]]; then
        local allowed
        allowed=$(echo "$range_info" | tail -n +2 | tr -d "'")
        if ! echo "$allowed" | grep -qx "$value"; then
          printf "Error: Value '%s' is not valid for key '%s'.\nAllowed values:\n%s\n" "$value" "$key" "$allowed" >&2
          return 1
        fi
      fi
      gsettings set "$schema" "$key" "$value"
    }
    alias set-org-gnome-gset='set_gnome_gset'
    ## @description Apply dark theme for GTK4/GTK3 (Nautilus / Mutter-managed windows).
    ##   Ensures org.gnome.desktop.interface color-scheme=prefer-dark via gsettings
    ##   and gtk-application-prefer-dark-theme=true in both gtk-4.0 and gtk-3.0 settings.ini.
    ##   KDE's kde-gtk-config can silently reset these; run this function to restore them.
    ## @flag --check   Check current state without applying any changes
    ## @flag --help    Show usage
    apply_gtk_dark_theme() {
      local check_only=0

      while [[ "${1:-}" == --* ]]; do
        case "$1" in
          --check)  check_only=1; shift ;;
          --help|-h)
            printf "📖 \033[1mapply-gtk-dark-theme\033[0m [--check]\n"
            printf "   Applies dark theme for GTK4/GTK3 (Nautilus / Mutter windows).\n"
            printf "   --check   Only report current state — do not modify anything.\n"
            printf "\n"
            printf "   Affected settings:\n"
            printf "     • gsettings org.gnome.desktop.interface color-scheme  → 'prefer-dark'\n"
            printf "     • ~/.config/gtk-4.0/settings.ini  gtk-application-prefer-dark-theme → true\n"
            printf "     • ~/.config/gtk-3.0/settings.ini  gtk-application-prefer-dark-theme → true\n"
            return 0 ;;
          *)
            printf "❌ Unknown flag: %s\n" "$1" >&2
            return 1 ;;
        esac
      done

      local errors=0
      local GTK4_CFG="$HOME/.config/gtk-4.0/settings.ini"
      local GTK3_CFG="$HOME/.config/gtk-3.0/settings.ini"
      local mode_label; (( check_only )) && mode_label="Check" || mode_label="Apply"

      printf "\033[1;36m── GTK Dark Theme %s (%s) ──\033[0m\n" "$mode_label" "$(date '+%H:%M:%S')"

      # ── helper: check/fix one GTK ini file ─────────────────────────────
      _gtk_dark_fix_ini() {
        local cfg="$1"
        local label="$2"

        if [[ ! -f "$cfg" ]]; then
          printf "  \033[1;31m✗\033[0m  %s — file not found\n" "$label"
          if (( ! check_only )); then
            if mkdir -p "$(dirname "$cfg")" && printf '[Settings]\ngtk-application-prefer-dark-theme=true\n' > "$cfg"; then
              printf "    \033[1;32m→ Created\033[0m %s with prefer-dark=true\n" "$cfg"
            else
              printf "    \033[1;31m→ Failed to create %s\033[0m\n" "$cfg" >&2
              (( errors++ )) || true
            fi
          fi
          return
        fi

        local current_val
        current_val=$(grep "^gtk-application-prefer-dark-theme=" "$cfg" 2>/dev/null \
                      | cut -d= -f2 | tr -d '[:space:]')

        if [[ "$current_val" == "true" ]]; then
          printf "  \033[1;32m✓\033[0m  %s → prefer-dark=true\n" "$label"
          return
        fi

        printf "  \033[1;31m✗\033[0m  %s → prefer-dark=%s (expected true)\n" \
          "$label" "${current_val:-<missing>}"

        (( check_only )) && return

        local ok=0
        if [[ -n "$current_val" ]]; then
          # Key exists but has wrong value — replace it
          sed -i 's/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=true/' "$cfg" && ok=1
        elif grep -q "^\[Settings\]" "$cfg" 2>/dev/null; then
          # [Settings] section exists but key is absent — insert after the header
          sed -i '/^\[Settings\]/a gtk-application-prefer-dark-theme=true' "$cfg" && ok=1
        else
          # File has no [Settings] section — prepend it
          local tmp; tmp=$(mktemp)
          { printf '[Settings]\ngtk-application-prefer-dark-theme=true\n'; cat "$cfg"; } > "$tmp" \
            && mv "$tmp" "$cfg" && ok=1
        fi

        if (( ok )); then
          local new_val
          new_val=$(grep "^gtk-application-prefer-dark-theme=" "$cfg" 2>/dev/null \
                    | cut -d= -f2 | tr -d '[:space:]')
          if [[ "$new_val" == "true" ]]; then
            printf "    \033[1;32m→ Fixed\033[0m %s\n" "$cfg"
          else
            printf "    \033[1;31m→ Write succeeded but value still wrong in %s\033[0m\n" "$cfg" >&2
            (( errors++ )) || true
          fi
        else
          printf "    \033[1;31m→ Failed to patch %s\033[0m\n" "$cfg" >&2
          (( errors++ )) || true
        fi
      }
      # ── 1. GTK4 ini ────────────────────────────────────────────────────
      _gtk_dark_fix_ini "$GTK4_CFG" "gtk-4.0/settings.ini"
      # ── 2. GTK3 ini ────────────────────────────────────────────────────
      _gtk_dark_fix_ini "$GTK3_CFG" "gtk-3.0/settings.ini"

      unset -f _gtk_dark_fix_ini

      # ── 3. gsettings color-scheme ──────────────────────────────────────
      if ! command -v gsettings &>/dev/null; then
        printf "  \033[1;33m⚠\033[0m   gsettings not found — DConf color-scheme not checked.\n"
      else
        local current_scheme
        current_scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || true)

        if [[ "$current_scheme" == "'prefer-dark'" ]]; then
          printf "  \033[1;32m✓\033[0m  gsettings color-scheme = prefer-dark\n"
        else
          printf "  \033[1;31m✗\033[0m  gsettings color-scheme = %s (expected 'prefer-dark')\n" \
            "${current_scheme:-<unset>}"
          if (( ! check_only )); then
            if gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null; then
              printf "    \033[1;32m→ Fixed\033[0m gsettings color-scheme = prefer-dark\n"
            else
              printf "    \033[1;31m→ Failed to set gsettings color-scheme\033[0m\n" >&2
              (( errors++ )) || true
            fi
          fi
        fi
        
        # ── 3b. GNOME Text Editor specific override ──────────────────────
        local gte_scheme
        gte_scheme=$(gsettings get org.gnome.TextEditor style-variant 2>/dev/null || true)
        if [[ -n "$gte_scheme" ]]; then
          if [[ "$gte_scheme" == "'dark'" ]]; then
            printf "  \033[1;32m✓\033[0m  org.gnome.TextEditor style-variant = 'dark'\n"
          else
            printf "  \033[1;31m✗\033[0m  org.gnome.TextEditor style-variant = %s (expected 'dark')\n" "$gte_scheme"
            if (( ! check_only )); then
              if gsettings set org.gnome.TextEditor style-variant 'dark' 2>/dev/null; then
                printf "    \033[1;32m→ Fixed\033[0m GNOME Text Editor style-variant = 'dark'\n"
              else
                printf "    \033[1;31m→ Failed to set GNOME Text Editor style-variant\033[0m\n" >&2
                (( errors++ )) || true
              fi
            fi
          fi
        fi

        # Informational — current gtk-theme (not modified by this function)
        local current_gtk_theme
        current_gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || true)
        printf "  \033[0;37mℹ\033[0m   gsettings gtk-theme = %s\n" "${current_gtk_theme:-<unset>}"
      fi

      # ── 4. XDG Desktop Portal (fixes libadwaita/Nautilus) ──────────────
      local portal_conf="$HOME/.config/xdg-desktop-portal/portals.conf"
      if [[ ! -f "$portal_conf" ]] || ! grep -q "default=gnome" "$portal_conf" 2>/dev/null; then
        printf "  \033[1;31m✗\033[0m  xdg-desktop-portal explicit GNOME config missing\n"
        if (( ! check_only )); then
          mkdir -p "$(dirname "$portal_conf")"
          printf "[preferred]\ndefault=gnome;gtk;\n" > "$portal_conf"
          printf "    \033[1;32m→ Created\033[0m %s\n" "$portal_conf"
          local _portal_backends="xdg-desktop-portal"
          [[ "${XDG_CURRENT_DESKTOP,,}" == *gnome* ]] && _portal_backends="$_portal_backends xdg-desktop-portal-gnome xdg-desktop-portal-gtk"
          # shellcheck disable=SC2086
          systemctl --user restart $_portal_backends 2>/dev/null || true
          printf "    \033[1;32m→ Restarted\033[0m %s\n" "$_portal_backends"
        fi
      else
        printf "  \033[1;32m✓\033[0m  xdg-desktop-portal GNOME config present\n"
      fi

      # ── Summary ────────────────────────────────────────────────────────
      printf "\n"
      if (( check_only )); then
        printf "\033[1;36mℹ️  Check-only mode — no changes were made.\033[0m\n"
      elif (( errors > 0 )); then
        printf "\033[1;31m⚠️  Completed with %d error(s). Some settings may not have applied.\033[0m\n" \
          "$errors" >&2
        return 1
      else
        # Kill nautilus process to force it to reload the theme
        killall nautilus 2>/dev/null || true
        printf "\033[1;32m✅ Dark theme settings applied.\033[0m\n"
        printf "   Nautilus has been restarted in the background to apply changes.\n"
      fi
    }
    alias apply-gtk-dark='apply_gtk_dark_theme'
    alias fix-gtk-dark='apply_gtk_dark_theme'
    alias check-gtk-dark='apply_gtk_dark_theme --check'

    ## @description Installs (or force-overwrites) the GNOME autostart entry that
    ##   restarts xdg-desktop-portal-gnome and xdg-desktop-portal-gtk 6 seconds
    ##   after login, fixing the libadwaita / Nautilus light-mode race condition.
    ## @flag --check   Print the current file content (if any) without writing
    ## @flag --remove  Delete the autostart entry
    ## @flag --help    Show usage
    install_portal_dark_autostart() {
      local dest="$HOME/.config/autostart/restart-xdg-portals.desktop"
      local mode="apply"

      while [[ "${1:-}" == --* ]]; do
        case "$1" in
          --check)  mode="check";  shift ;;
          --remove) mode="remove"; shift ;;
          --help|-h)
            printf "📖 \033[1minstall-portal-dark-autostart\033[0m [--check | --remove]\n"
            printf "   Writes a GNOME autostart .desktop entry that restarts\n"
            printf "   xdg-desktop-portal* ~6 s after login so libadwaita apps\n"
            printf "   (Nautilus, GNOME Text Editor) honour the dark-mode setting.\n"
            printf "\n"
            printf "   Target: %s\n" "$dest"
            printf "   --check   Show current file content without modifying it.\n"
            printf "   --remove  Delete the autostart entry.\n"
            return 0 ;;
          *)
            printf "❌ Unknown flag: %s\n" "$1" >&2
            return 1 ;;
        esac
      done

      case "$mode" in
        check)
          if [[ -f "$dest" ]]; then
            printf "\033[1;36m── %s ──\033[0m\n" "$dest"
            cat "$dest"
          else
            printf "ℹ️  Autostart entry not found: %s\n" "$dest"
          fi
          return 0 ;;
        remove)
          if [[ -f "$dest" ]]; then
            rm -f "$dest" && printf "🗑️  Removed: %s\n" "$dest" || {
              printf "❌ Failed to remove: %s\n" "$dest" >&2; return 1
            }
          else
            printf "ℹ️  Nothing to remove — file not found: %s\n" "$dest"
          fi
          return 0 ;;
      esac

      # ── apply / overwrite ──────────────────────────────────────────────
      if ! mkdir -p "$(dirname "$dest")" 2>/dev/null; then
        printf "❌ Cannot create directory: %s\n" "$(dirname "$dest")" >&2
        return 1
      fi

      cat > "$dest" << 'DESKTOP_ENTRY'
[Desktop Entry]
Type=Application
Name=Restart XDG Desktop Portals
Comment=Fixes libadwaita dark mode timing issue on GNOME startup
Exec=bash -c 'sleep 6 && BACKENDS="xdg-desktop-portal"; case "${XDG_CURRENT_DESKTOP,,}" in *gnome*) BACKENDS="$BACKENDS xdg-desktop-portal-gnome xdg-desktop-portal-gtk" ;; esac; systemctl --user restart $BACKENDS'
X-GNOME-Autostart-enabled=true
Hidden=false
NoDisplay=false
DESKTOP_ENTRY

      if [[ $? -ne 0 ]]; then
        printf "❌ Failed to write: %s\n" "$dest" >&2
        return 1
      fi

      chmod +x "$dest"
      printf "\033[1;32m✅ Autostart entry written:\033[0m %s\n" "$dest"
      printf "   It will run automatically at the next GNOME login.\n"
      printf "   To apply this session without rebooting, run: \033[1mapply-gtk-dark\033[0m\n"
    }
    alias install-portal-dark-autostart='install_portal_dark_autostart'
    alias check-portal-dark-autostart='install_portal_dark_autostart --check'
    alias remove-portal-dark-autostart='install_portal_dark_autostart --remove'
    ## @description Kill a list of common desktop applications and power off immediately.
    shutdown_now() {
        local kill_procs=(
            code code-insiders codium cursor
            sublime_text sublime-text subl
            atom brackets
            eclipse idea pycharm webstorm phpstorm
            clion goland rider rubymine datagrip
            android-studio studio netbeans
            geany kdevelop gnome-builder
            monodevelop qtcreator
            zed lapce lite-xl
            bluefish bluej
            gedit kate kwrite mousepad
            pluma xed xedit
            featherpad leafpad notepadqq
            gvim emacs emacs-gtk emacs-nox
            l3afpad tea focuswriter
            ghostwriter manuskript
            gnome-text-editor
            anydesk teamviewer remmina
            vinagre xfreerdp wlfreerdp
            rustdesk nxplayer nxclient
            parsec x2goclient krdc
            tigervnc vncviewer
            xrdp xrdp-sesman
            gnome-remote-desktop
            nautilus thunar dolphin
            pcmanfm pcmanfm-qt
            nemo caja spacefm
            krusader konqueror
            doublecmd ranger mc
            sunflower polo-file-manager
            brave brave-browser firefox chromium
            gnome-software update-notifier
            gnome-calendar gnome-shell-calendar
            evolution evolution-calendar-factory
            evolution-source-registry evolution-alarm-notify
            evolution-addressbook-factory
            alarm-clock-applet
            totem rhythmbox eog gimp gimp-3.0
            gnome-control-center gnome-characters
            blueman-applet blueman-tray
            gsd-media-keys gsd-power
        )
        for prog in "${kill_procs[@]}"; do
            if ! pgrep -x "$prog" &>/dev/null; then
                continue
            fi
            killall "$prog" 2>/dev/null || true
            pkill -x "$prog" 2>/dev/null || true
            pgrep -x "$prog" 2>/dev/null | xargs -r kill -9 2>/dev/null || true
        done
        if command -v gnome-session-quit &>/dev/null; then
            gnome-session-quit --no-prompt --power-off 2>/dev/null &
        fi
        sleep 2
        for job_id in $(atq 2>/dev/null | awk '{print $1}'); do
            atrm "$job_id" 2>/dev/null || true
        done
        shutdown -c 2>/dev/null || true
        shutdown -h now 2>/dev/null || true
        sleep 5
        systemctl poweroff --ignore-inhibitors 2>/dev/null || true
        sleep 5
        systemctl poweroff --force 2>/dev/null || true
    }
    alias shutdown-now='shutdown_now'
    alias shutdown_now='shutdown_now'
    ## @description Schedule a kill sequence for common desktop applications at a given time using at(1).
    ## @param $1 {string} start_time - Time in HH:MM format.
    schedule_kill_sequence() {
        local start_time="${1?Usage: schedule_kill_sequence HH:MM}"
        if [[ -z "$start_time" ]]; then
            echo "Usage: schedule_kill_sequence HH:MM"
            return 1
        fi
        if ! command -v at &>/dev/null; then
            echo "Error: 'at' command not found. Please install 'at' (e.g., sudo apt install at)."
            return 1
        fi
        if ! [[ "$start_time" =~ ^[0-9]{1,2}:[0-9]{2}$ ]]; then
            echo "Error: Invalid time format. Use HH:MM (e.g., 04:45)."
            return 1
        fi
        IFS=: read -r hour minute <<< "$start_time"
        hour=$((10#$hour))
        minute=$((10#$minute))
        if (( hour < 0 || hour > 23 || minute < 0 || minute > 59 )); then
            echo "Error: Invalid hour or minute."
            return 1
        fi
        local tmpscript
        tmpscript=$(mktemp /tmp/kill_sequence_XXXXXX.sh)
        chmod 700 "$tmpscript"
        cat > "$tmpscript" <<'KILL_SCRIPT_EOF'
#!/usr/bin/env bash
uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
if (( uptime_seconds < 900 )); then
    for job_id in $(atq 2>/dev/null | awk '{print $1}'); do
        atrm "$job_id" 2>/dev/null || true
    done
    shutdown -c 2>/dev/null || true
    rm -f "$0"
    exit 0
fi
ignore_inhibitors=false
kill_procs=(
    code code-insiders codium cursor
    sublime_text sublime-text subl
    atom brackets
    eclipse idea pycharm webstorm phpstorm
    clion goland rider rubymine datagrip
    android-studio studio netbeans
    geany kdevelop gnome-builder
    monodevelop qtcreator
    zed lapce lite-xl
    bluefish bluej
    gedit kate kwrite mousepad
    pluma xed xedit
    featherpad leafpad notepadqq
    gvim emacs emacs-gtk emacs-nox
    l3afpad tea focuswriter
    ghostwriter manuskript
    gnome-text-editor
    anydesk teamviewer remmina
    vinagre xfreerdp wlfreerdp
    rustdesk nxplayer nxclient
    parsec x2goclient krdc
    tigervnc vncviewer
    xrdp xrdp-sesman
    gnome-remote-desktop
    nautilus thunar dolphin
    pcmanfm pcmanfm-qt
    nemo caja spacefm
    krusader konqueror
    doublecmd ranger mc
    sunflower polo-file-manager
    brave brave-browser firefox chromium
    gnome-software update-notifier
    gnome-calendar gnome-shell-calendar
    evolution evolution-calendar-factory
    evolution-source-registry evolution-alarm-notify
    evolution-addressbook-factory
    alarm-clock-applet
    totem rhythmbox eog gimp gimp-3.0
    gnome-control-center gnome-characters
    blueman-applet blueman-tray
    gsd-media-keys gsd-power
)
for prog in "${kill_procs[@]}"; do
    if ! pgrep -x "$prog" &>/dev/null && ! ps -C "$prog" --no-headers 2>/dev/null | grep -q .; then
        continue
    fi
    killall "$prog" 2>/dev/null || true
    sleep 30
    if ! pgrep -x "$prog" &>/dev/null && ! ps -C "$prog" --no-headers 2>/dev/null | grep -q .; then
        continue
    fi
    pgrep -x "$prog" 2>/dev/null | xargs -r kill -9 2>/dev/null || true
    sleep 30
    if ! pgrep -x "$prog" &>/dev/null && ! ps -C "$prog" --no-headers 2>/dev/null | grep -q .; then
        continue
    fi
    pkill -9 -x "$prog" 2>/dev/null || true
    sleep 30
    if pgrep -x "$prog" &>/dev/null || ps -C "$prog" --no-headers 2>/dev/null | grep -q .; then
        ignore_inhibitors=true
    fi
done
for job_id in $(atq 2>/dev/null | awk '{print $1}'); do
    atrm "$job_id" 2>/dev/null || true
done
shutdown -c 2>/dev/null || true
shutdown -h now 2>/dev/null || true
sleep 120
if [[ "$ignore_inhibitors" == true ]]; then
    systemctl poweroff --ignore-inhibitors 2>/dev/null || true
else
    systemctl poweroff 2>/dev/null || true
fi
sleep 120
systemctl poweroff --force 2>/dev/null || true
rm -f "$0"
KILL_SCRIPT_EOF
        echo "Scheduling kill sequence at $start_time"
        echo "bash \"$tmpscript\"" | at "$start_time" 2>/dev/null
        if [[ $? -ne 0 ]]; then
            rm -f "$tmpscript"
            echo "Failed to schedule kill sequence at $start_time"
            return 1
        fi
        echo "Kill sequence scheduled successfully at $start_time"
    }
    alias schedule-kill-sequence='schedule_kill_sequence'
    ## @description Waits for any running rsync or find processes to complete, then terminates a list of common applications and finally powers off the system after a delay.
    wait_sync_and_terminate() {
        printf "\033[1;33mWaiting for rsync and find processes to complete...\033[0m\n"
        
        while true; do
            local has_rsync=false has_find=false
            pgrep -x "rsync" > /dev/null 2>&1 && has_rsync=true
            pgrep -x "find" > /dev/null 2>&1 && has_find=true
            
            if [[ "$has_rsync" == true ]] || [[ "$has_find" == true ]]; then
                local status="$([[ "$has_rsync" == true ]] && echo "rsync ")$([[ "$has_find" == true ]] && echo "find")"
                printf "  \033[1;36m%s\033[0m still running. Waiting...\n" "${status% }"
                sleep 20
            else
                break
            fi
        done
        
        echo "rsync and find processes completed. Terminating applications in 120 seconds..."
        sleep 120
        
        local apps=(
            "code" "vscodium" "cursor" "pycharm" "webstorm" "intellij" "goland" "clion" "phpstorm" "rubymine" "sublime_text" "atom" "zed"
            "vim" "nvim" "emacs" "gedit" "kate" "leafpad" "mousepad" "pluma" "gnome-text-editor" "nano"
            "nautilus" "nemo" "thunar" "dolphin" "pcmanfm" "caja" "konqueror" "ranger"
            "gnome-terminal" "konsole" "alacritty" "kitty" "wezterm" "xterm" "urxvt" "tilix" "terminator" "xfce4-terminal" "guake" "tilda"
            "firefox" "chrome" "google-chrome" "chromium" "brave" "opera" "vivaldi" "mamba" "epiphany" "falkon" "midori" "tor-browser"
            "remmina" "anydesk" "teamviewer" "freerdp" "wlfreerdp" "xfreerdp" "rdpclient"
        )
        
        for app in "${apps[@]}"; do
            if pgrep -x "$app" > /dev/null 2>&1; then
                echo "Terminating $app (SIGTERM)..."
                pkill -x "$app" 2>/dev/null || true
                sleep 2
                
                if pgrep -x "$app" > /dev/null 2>&1; then
                    echo "  → Force killing $app (SIGKILL)..."
                    pkill -9 -x "$app" 2>/dev/null || true
                fi
            fi
        done
        
        printf "\033[1;31mAll specified applications terminated.\033[0m\n"
        echo "System will power off in 120 seconds. Save any remaining work."
        sleep 120
        
        printf "\033[1;31mPowering off now...\033[0m\n"
        systemctl poweroff --force 2>/dev/null || sudo systemctl poweroff --force || shutdown -h now
    }
    alias wait-sync-and-terminate='wait_sync_and_terminate'
    function _check_ps_exists() {
        local pid="${1?Usage: _check_ps_exists <pid>}"
        if [[ -z $(ps -aux | awk '{print $2}' | grep -w "$pid") ]]; then
            echo "Error: No process found with PID $pid."
            return 1
        fi
        return 0
    }
    function set_ps_critical() {
        local pid="${1?Usage: set-ps-critical <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n -20 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to critical priority."
    }
    alias set-ps-critical='set_ps_critical'
    function set_ps_very_important() {
        local pid="${1?Usage: set-ps-very-important <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n -15 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to very important priority."
    }
    alias set-ps-very-important='set_ps_very_important'
    function set_ps_important() {
        local pid="${1?Usage: set-ps-important <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n -10 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to important priority."
    }
    alias set-ps-important='set_ps_important'
    function set_ps_normal() {
        local pid="${1?Usage: set-ps-normal <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n 0 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to normal priority."
    }
    alias set-ps-normal='set_ps_normal'
    function set_ps_low() {
        local pid="${1?Usage: set-ps-low <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n +10 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to low priority."
    }
    alias set-ps-low='set_ps_low'
    function set_ps_very_low() {
        local pid="${1?Usage: set-ps-very-low <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n +15 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to very low priority."
    }
    alias set-ps-very-low='set_ps_very_low'
    function set_ps_irrelevant() {
        local pid="${1?Usage: set-ps-irrelevant <pid>}"
        if ! _check_ps_exists "$pid"; then
            return 1
        fi
      sudo renice -n +19 -p "${pid}" 2>/dev/null || echo "Failed to set process ${pid} to irrelevant priority."
    }
    alias set-ps-irrelevant='set_ps_irrelevant'
    alias dbus-asses-desktop-portal='dbus-send --session --dest=org.freedesktop.portal.Desktop --type=method_call --print-reply /org/freedesktop/portal/desktop org.freedesktop.DBus.Introspectable.Introspect'
    alias dbus-asses-xdg-desktop-introspect-portal='dbus-send --session --dest=org.freedesktop.portal.Desktop --type=method_call --print-reply /org/freedesktop/portal/desktop org.freedesktop.DBus.Introspectable.Introspect'
    alias dbus-asses-xdg-desktop-portal='dbus-send --print-reply=literal --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:"org.freedesktop.appearance" string:"color-scheme"'
    alias dbus-asses-portal='dbus-send --session --dest=org.freedesktop.portal.Desktop --type=method_call --print-reply /org/freedesktop/portal/desktop org.freedesktop.DBus.Introspectable.Introspect'
#endregion Desktop_Environment

