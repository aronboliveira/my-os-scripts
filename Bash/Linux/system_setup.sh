  #region System_Setup
    ## @description Enable software GL rendering (Mesa llvmpipe), persist to bashrc,
    ##   optionally disable X11 compositing. No args needed.
    ## @flag --no-persist   Skip writing env vars to ~/.bashrc
    ## @flag --no-composite Skip disabling XFWM4 compositing
    setup_software_gl() {
      local persist=1 composite=1
      while [[ "${1:-}" == --* ]]; do
        case "$1" in
          --no-persist)   persist=0; shift ;;
          --no-composite) composite=0; shift ;;
          --help|-h) echo -e "📖 \033[1msetup-software-gl\033[0m [--no-persist] [--no-composite]"; return 0 ;;
          *) echo -e "❌ Unknown flag: $1"; return 1 ;;
        esac
      done
      local vars='export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export MESA_GL_VERSION_OVERRIDE=3.3'
      if (( persist )); then
        if ! grep -q "LIBGL_ALWAYS_SOFTWARE" ~/.bashrc; then
          printf '\n%s\n' "$vars" >> ~/.bashrc
          echo -e "✅ \033[1;32mAdded software rendering env vars to ~/.bashrc\033[0m"
        else
          echo -e "ℹ️  Software rendering vars already present in ~/.bashrc"
        fi
      fi
      export LIBGL_ALWAYS_SOFTWARE=1
      export GALLIUM_DRIVER=llvmpipe
      export MESA_GL_VERSION_OVERRIDE=3.3
      if (( composite )) && [ "${XDG_SESSION_TYPE:-}" = "x11" ] && command -v xfconf-query >/dev/null 2>&1; then
        xfconf-query -c xfwm4 -p /general/use_compositing -s false
        echo -e "🖥️  Disabled XFWM4 compositing"
      fi
      echo -e "✅ \033[1;32mSoftware GL rendering active.\033[0m"
    }
    alias setup-software-gl='setup_software_gl'
    ## @description List all environment variables (env), sorted alphabetically.
    alias show-all-env-vars='env | grep -v "^$" | sort'
    alias ls-all-env-vars='show-all-env-vars'
    ## @description List all exported variables (printenv), sorted alphabetically.
    alias show-all-printenv-vars='printenv | grep -v "^$" | sort'
    alias ls-all-printenv-vars='show-all-printenv-vars'
    ## @description List all shell variables (set -o posix; set), sorted alphabetically.
    alias show-all-sh-vars='( set -o posix; set ) | grep -v "^$" | sort'
    alias ls-all-sh-vars='show-all-sh-vars'
    ## @description Show current display session type (x11 or wayland).
    alias show-display-session="echo \$XDG_SESSION_TYPE"
    alias ls-display-session='show-display-session'
    alias echo-display-session='show-display-session'
    ## @description Show current desktop session name (e.g., gnome, plasma).
    alias show-desktop-session="echo \$XDG_SESSION_DESKTOP"
    alias ls-desktop-session='show-desktop-session'
    alias echo-desktop-session='show-desktop-session'
    ## @description Show XDG data directories path list.
    alias show-datadirs-session="echo \$XDG_DATA_DIRS"
    alias ls-datadirs-session='show-datadirs-session'
    alias echo-datadirs-session='show-datadirs-session'
    ## @description Show host machine type (e.g., x86_64).
    alias show-hosttype="echo \$HOSTTYPE"
    alias ls-hosttype='show-hosttype'
    alias echo-hosttype='show-hosttype'
    ## @description Show current user's home directory path.
    alias show-home="echo \$HOME"
    alias ls-home='show-home'
    alias echo-home='show-home'
    ## @description Show current username.
    alias show-user="echo \$USER"
    alias ls-user='show-user'
    alias echo-user='show-user'
    ## @description Show current shell binary path.
    alias show-shell="echo \$SHELL"
    alias ls-shell='show-shell'
    alias echo-shell='show-shell'
    ## @description Show current working directory (alias for pwd).
    alias show-wrkdir="echo \$PWD"
    alias ls-wrkdir='show-wrkdir'
    alias echo-wrkdir='show-wrkdir'
    ## @description Show current user directories config content (from ~/.config/user-dirs.dirs).
    alias show-user-dirs='cat ~/.config/user-dirs.dirs 2>/dev/null || printf "[-] No user-dirs config found\n"'
    alias ls-user-dirs='show-user-dirs'
    ## @description Show display server type code (x11 or wayland).
    alias show-display-server-code="echo \$XDG_SESSION_TYPE"
    alias ls-display-server-code='show-display-server-code'
    alias echo-display-server-code='show-display-server-code'
    ## @description Show human-readable description of the current display server.
    show_display_server() {
      local display="${DISPLAY:-unset}"
      
      case "$display" in
        unset)
          echo "No display server - headless environment or TTY"
          ;;
        :0)
          echo "X11 server on local machine (primary display)"
          ;;
        :0.0)
          echo "X11 server on local machine, screen 0"
          ;;
        :1)
          echo "Second X11 server"
          ;;
        :1.0)
          echo "Second X11 server, screen 0"
          ;;
        :2)
          echo "Third X11 server"
          ;;
        :10|:11|:20|:30|:99)
          echo "Nested X server or virtual display"
          ;;
        *)
          echo "Display: $display (custom or remote X server)"
          ;;
      esac
    }

    ## @description Show human-readable display server info.
    alias show-display-server='show_display_server'
    alias ls-display-server='show-display-server'
    alias echo-display-server='show-display-server'
    ## @description Show D-Bus session bus address.
    alias show-dbus-addr="echo \$DBUS_SESSION_BUS_ADDRESS"
    alias ls-dbus-addr='show-dbus-addr'
    alias echo-dbus-addr='show-dbus-addr'
    ## @description Show the active display manager service unit name.
    alias show-display-manager='systemctl show -p Id display-manager.service'
    alias ls-display-manager='show-display-manager'
    ## @description Show the default display manager binary from X11 config.
    alias show-display-manager-x11='sudo cat /etc/X11/default-display-manager'
    alias ls-display-manager-x11='show-display-manager-x11'
    ## @description Show the current desktop environment identifier.
    alias show-current-de="echo \$XDG_CURRENT_DESKTOP"
    alias ls-current-de='show-current-de'
    alias echo-current-de='show-current-de'
    ## @description Show available version of Desktop Environment based on XFCE to be used in session load
    alias show-av-xde='cat ~/.xsession'
    alias ls-av-xde='show-av-xde'
    alias echo-av-xde='show-av-xde'
    alias show-available-xde='show-av-xde'
    alias ls-available-xde='show-av-xde'
    alias echo-available-xde='show-av-xde'
    alias show-available-xdesktop='show-av-xde'
    alias ls-available-xdesktop='show-av-xde'
    alias echo-available-xdesktop='show-av-xde'
    ## @description Show current desktop environment identifier (alias for show-current-de).
    alias show-desktop-env="echo \$XDG_CURRENT_DESKTOP"
    alias ls-desktop-env='show-desktop-env'
    alias echo-desktop-env='show-desktop-env'
    ## @description Detect the active display manager and show its greeter
    ##   configuration. Supports LightDM, GDM3, SDDM, LXDM, XDM, and SLiM.
    show_greeter_verbose() {
      local dm
      dm=$(cat /etc/X11/default-display-manager 2>/dev/null | xargs basename)

      if [[ -z "$dm" ]]; then
        dm=$(systemctl status display-manager 2>/dev/null | grep -oP '(?<=Loaded: loaded \().*?(?=;)' | xargs basename)
      fi

      case "$dm" in
        lightdm)
          grep -r "greeter-session" /etc/lightdm/ 2>/dev/null | grep -v "^#"
          ;;
        gdm3|gdm)
          echo "=== GDM3 Display Manager ==="
          echo "Greeter: GNOME Shell (built-in, no separate process)"
          echo ""
          echo "=== GDM Daemon Config ==="
          cat /etc/gdm3/daemon.conf 2>/dev/null
          echo ""
          echo "=== GDM Custom Config ==="
          cat /etc/gdm3/custom.conf 2>/dev/null
          ;;
        sddm)
          grep -i "theme\|greeter" /etc/sddm.conf /etc/sddm.conf.d/*.conf 2>/dev/null | grep -v "^#"
          ;;
        lxdm)
          grep -i "theme\|greeter" /etc/lxdm/lxdm.conf 2>/dev/null | grep -v "^#"
          ;;
        xdm)
          echo "XDM: built-in greeter, config at /etc/X11/xdm/"
          ls /etc/X11/xdm/ 2>/dev/null
          ;;
        slim)
          grep -i "theme\|greeter" /etc/slim.conf 2>/dev/null | grep -v "^#"
          ;;
        *)
          echo "Unknown or undetected display manager: '$dm'"
          echo "Hint: try 'systemctl status display-manager'"
          ;;
      esac
    }
    ## @description Show verbose greeter/display-manager configuration.
    alias show-greeter-verbose='show_greeter_verbose'
    alias ls-greeter-verbose='show-greeter-verbose'
    alias echo-greeter-verbose='show-greeter-verbose'
    ## @description Show only the greeter line from display-manager config.
    alias show-greeter='show-greeter-verbose | grep "Greeter:"'
    alias ls-greeter='show-greeter'
    alias echo-greeter='show-greeter'
    ## @description Show SDDM KDE settings from /etc/sddm.conf.d/kde_settings.conf.
    alias cat-kde-settings='sudo cat /etc/sddm.conf.d/kde_settings.conf 2>/dev/null || echo "No KDE settings found"'
    ## @description Alias for cat-kde-settings.
    alias ls-kde-settings='sudo cat /etc/sddm.conf.d/kde_settings.conf 2>/dev/null || echo "No KDE settings found"'
    ## @description Alias for cat-kde-settings.
    alias show-kde-settings='sudo cat /etc/sddm.conf.d/kde_settings.conf 2>/dev/null || echo "No KDE settings found"'
    ## @description Show GDM3 main config from /etc/gdm3/gdm3.conf.
    alias cat-gdm3-conf='sudo cat /etc/gdm3/gdm3.conf 2>/dev/null || echo "No GDM3 config found"'
    ## @description Alias for cat-gdm3-conf.
    alias ls-gdm3-conf='sudo cat /etc/gdm3/gdm3.conf 2>/dev/null || echo "No GDM3 config found"'
    ## @description Alias for cat-gdm3-conf.
    alias show-gdm3-conf='sudo cat /etc/gdm3/gdm3.conf 2>/dev/null || echo "No GDM3 config found"'
    ## @description Show GDM3 daemon config from /etc/gdm3/daemon.conf.
    alias cat-gdm3-daemon='sudo cat /etc/gdm3/daemon.conf 2>/dev/null || echo "No GDM3 daemon config found"'
    ## @description Alias for cat-gdm3-daemon.
    alias ls-gdm3-daemon='sudo cat /etc/gdm3/daemon.conf 2>/dev/null || echo "No GDM3 daemon config found"'
    ## @description Alias for cat-gdm3-daemon.
    alias show-gdm3-daemon='sudo cat /etc/gdm3/daemon.conf 2>/dev/null || echo "No GDM3 daemon config found"'
    ## @description Show GDM3 custom config from /etc/gdm3/custom.conf.
    alias cat-gdm3-custom='sudo cat /etc/gdm3/custom.conf 2>/dev/null || echo "No GDM3 custom config found"'
    ## @description Alias for cat-gdm3-custom.
    alias ls-gdm3-custom='sudo cat /etc/gdm3/custom.conf 2>/dev/null || echo "No GDM3 custom config found"'
    ## @description Alias for cat-gdm3-custom.
    alias show-gdm3-custom='sudo cat /etc/gdm3/custom.conf 2>/dev/null || echo "No GDM3 custom config found"'
    ## @description Install wmctrl and show window manager info via wmctrl -m.
    alias show-win-mng-m='sudo apt install -y wmctrl 2>/dev/null && wmctrl -m || echo "wmctrl not available"'
    alias ls-win-mng-m='show-win-mng-m'
    alias echo-win-mng-m='show-win-mng-m'
    ## @description Detect which window manager is running by scanning process
    ##   list against a comprehensive list of known X11/Wayland WMs.
    show_win_mng() {
      local WM_PATTERN='openbox|fluxbox|icewm|jwm|fvwm3|compiz|blackbox|metacity|mutter|kwin|xfwm4|afterstep|windowmaker|enlightenment|ctwm|9wm|aewm\+\+|amiwm|evilwm|flwm|lwm|marco|muffin|pekwm|ratpoison|subtle|twm|ukwm|windowlab|wm2|i3|awesome|bspwm|herbstluftwm|spectrwm|qtile|river|niri|dwm|xmonad|stumpwm|sawfish|wmii|notion|sway|weston|labwc|wayfire|hyprland|cage|phoc|cosmic-comp'
      ps aux | grep -E "$WM_PATTERN" | grep -v grep | awk '{print $11}' | xargs -I{} basename {}
    }
    alias show-win-mng='show_win_mng'
    alias show-window-manager='show_win_mng'
    alias ls-window-manager='show_win_mng'
    alias ls-win-mng='show-win-mng'
    ## @description Show running screen compositor processes (picom, compton, kwin, etc.).
    alias show-screen-compositor='ps aux | grep -E "picom|compton|kwin|mutter|xfwm|wayfire" | grep -v grep'
    alias ls-screen-compositor='show-screen-compositor'
    ## @description Show running screen locker processes (xscreensaver, swaylock, i3lock, etc.).
    alias show-screen-locker='ps aux | grep -E "xscreensaver|light-locker|swaylock|i3lock|gnome-screensaver" | grep -v grep'
    alias ls-screen-locker='show-screen-locker'
    ## @description Show comprehensive display environment info (session, DM, greeter, compositor, WM).
    alias show-full-display-info='show-desktop && show-display-session && show-display-manager && show-greeter && show-screen-compositor && show-win-mng'
    alias ls-full-display-info='show-full-display-info'
    alias echo-full-display-info='show-full-display-info'
    ## @description Show compact desktop environment summary.
    alias show-desktop="show-display-session; show-display-server; show-desktop-session; show-desktop-env; show-display-manager; show-win-mng"
    alias ls-desktop='show-desktop'
    alias echo-desktop='show-desktop'
    ## @description List installed GUI toolkit runtime libraries (GTK and Qt).
    alias show-installed-tks='dpkg -l | grep -E "libgtk|libqt" | grep -v dev'
    alias ls-installed-tks='show-installed-tks'

    alias install-plasma-backends='sudo apt install -y plasma-discover-backend-flatpak plasma-discover-backend-snap'
    ## @description Install Stremio (optimized for GNOME/X11), handling Flatpak dependencies.
    install_stremio_gnome() {
      if [[ ! "${XDG_CURRENT_DESKTOP,,}" =~ gnome ]]; then
        echo -e "⚠️  \033[1;33mWarning: This installer is tailored for GNOME. Current DE: ${XDG_CURRENT_DESKTOP:-Unknown}\033[0m"
        echo -e "It may not work properly on other environments."
      fi

      if ! command -v flatpak &>/dev/null; then
        echo -e "❌ \033[1;31mFlatpak not found.\033[0m Install with: sudo apt install flatpak"
        return 1
      fi

      echo -e "📦 \033[1;36mInstalling Stremio via Flatpak...\033[0m"
      sudo apt install gnome-software-plugin-flatpak -y

      local display_server_code="${DISPLAY:-:0}"
      if [[ "${XDG_SESSION_TYPE,,}" == "wayland" || "$display_server_code" != ":0" ]]; then
        echo -e "⚠️  \033[1;33mDisplay server that is not purely local X11 detected.\033[0m"
        echo -e "Stremio may have issues with screen sharing and hardware acceleration under these."
        echo -e "Consider switching to an X11 session (Display Server Code :0) for better compatibility."
        read -r -p "Do you want to proceed with the installation still? [y/N]: " ans
        [[ "$ans" =~ ^[Yy] ]] || { echo "Aborted."; return 0; }
      else
        echo -e "✅ \033[1;32mLocal X11 display detected. Stremio should work properly.\033[0m"
        xhost +SI:localuser:root 2>/dev/null || true
      fi

      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install flathub com.stremio.Stremio -y

      read -r -p "Do you want to run Stremio now? [Y/N]: " ans
      [[ "$ans" =~ ^[Yy] ]] || { echo "Installation complete."; return 0; }
      
      echo -e "🚀 \033[1;32mStarting Stremio...\033[0m"
      flatpak run com.stremio.Stremio &
    }
    alias install-stremio-gnome='install_stremio_gnome'
    install_protonvpn_deb_13() {
      echo -e "🔐 \033[1;36mInstalling ProtonVPN DEB package and configuring repository...\033[0m"
      sudo wget -O /usr/share/keyrings/protonvpn-stable-release.gpg https://repo.protonvpn.com/debian/public_key.asc 2>/dev/null || { echo -e "❌ \033[1;31mFailed to download GPG key.\033[0m"; return 1; }
      echo -e "🔑 \033[1;36mProtonVPN GPG key added to keyrings.\033[0m"
      sleep 2
      sudo apt update -y
      sleep 2
      echo -e "📥 \033[1;36mDownloading ProtonVPN DEB package...\033[0m"
      wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb 2>/dev/null || { echo -e "❌ \033[1;31mFailed to download DEB package.\033[0m"; return 1; }
      sleep 1
      echo -e "📦 \033[1;36mInstalling ProtonVPN DEB package...\033[0m"
      sudo dpkg -i ./protonvpn-stable-release_1.0.8_all.deb 2>/dev/null || { echo -e "⚠️  \033[1;33mdpkg reported issues, attempting to fix with apt...\033[0m"; return 1; }
      echo -e "✅ \033[1;32mProtonVPN DEB package installed.\033[0m"
      sudo apt update -y
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/protonvpn-stable-release.gpg] https://repo.protonvpn.com/debian stable main" | sudo tee /etc/apt/sources.list.d/protonvpn-stable.list || { echo -e "❌ \033[1;31mFailed to add ProtonVPN repository.\033[0m"; return 1; }
      sudo apt update -y
      echo -e "📥 \033[1;36mInstalling ProtonVPN GTK app...\033[0m"
      sudo apt install proton-vpn-gtk-app -y 2>/dev/null || { echo -e "❌ \033[1;31mFailed to install ProtonVPN GTK app.\033[0m"; return 1; }
      sudo apt update -y
      echo -e "✅ \033[1;32mProtonVPN DEB package installed and repository configured.\033[0m"
    }
    ## @description Show environment variables, exported variables, shell variables, aliases, and functions.
    ls_env_profile() {
      echo -e "\n\033[1;34m── 📋 ENVIRONMENT VARIABLES (env) ──\033[0m\n"
      show-all-env-vars
      echo -e "\n\033[1;34m── 💾 EXPORTED VARIABLES (printenv) ──\033[0m\n"
      show-all-printenv-vars
      echo -e "\n\033[1;34m── 🐚 SHELL VARIABLES (set) ──\033[0m\n"
      show-all-sh-vars
      sleep 3
      echo -e "\n\033[1;34m── 📂 SHELL ALIASES ──\033[0m\n"
      alias | sort
      echo -e "\n\033[1;34m── ⚡ SHELL FUNCTIONS ──\033[0m\n"
      declare -F | awk '{print $3}' | sort -u
    }
    ## @description Alias for ls-env-profile.
    alias ls-env-profile='ls_env_profile'
    ## @description Alias for ls-env-profile.
    alias show-env-profile='ls_env_profile'
    ## @description Short alias for ls-env-profile.
    alias ls-env-prof='ls_env_profile'
    ## @description Short alias for ls-env-profile.
    alias show-env-prof='ls_env_profile'
    ## @description Show fstab and crypttab contents.
    ls_tabs_profile() {
      echo -e "\n\033[1;34m── 🗂️  FSTAB ──\033[0m\n"
      sudo cat /etc/fstab 2>/dev/null || echo -e "❌ \033[1;31mNo fstab file found or permission denied\033[0m"
      if [[ -f /etc/crypttab ]]; then
        echo -e "\n\033[1;34m── 🔐 CRYPTTAB ──\033[0m\n"
        sudo cat /etc/crypttab 2>/dev/null || echo -e "❌ \033[1;31mNo crypttab file found or permission denied\033[0m"
      fi
    }
    ## @description Alias for ls-tabs-profile.
    alias ls-tabs-profile='ls_tabs_profile'
    ## @description Alias for ls-tabs-profile.
    alias show-tabs-profile='ls_tabs_profile'
    ## @description Alias for ls-tabs-profile.
    alias ls-fstab-profile='ls_tabs_profile'
    ## @description Alias for ls-tabs-profile.
    alias show-fstab-profile='ls_tabs_profile'
    ## @description Show sudo/admin groups, sudoers, MOTD, /etc/profile, chrony config, and APT keyrings.
    ls_rbac_profile() {
      echo -e "\n\033[1;34m── 👥 USER GROUPS ──\033[0m\n"
      sudo getent group 2>/dev/null | grep -E "sudo|adm|wheel|admin" || echo -e "❌ \033[1;31mNo sudo/admin groups found\033[0m"
      echo -e "\n\033[1;34m── 📜 SUDOERS ──\033[0m\n"
      sudo cat /etc/sudoers 2>/dev/null || echo -e "❌ \033[1;31mNo sudoers file found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 📢 MOTD ──\033[0m\n"
      sudo cat /etc/motd 2>/dev/null || echo -e "❌ \033[1;31mNo MOTD file found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 🧾 /ETC/PROFILE ──\033[0m\n"
      sudo cat /etc/profile 2>/dev/null || echo -e "❌ \033[1;31mNo profile file found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 🕐 CHRONY CONFIG ──\033[0m\n"
      sudo cat /etc/chrony/chrony.conf 2>/dev/null || sudo cat /etc/chrony.conf 2>/dev/null || echo -e "❌ \033[1;31mNo Chrony config found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 🔑 APT KEYRINGS ──\033[0m\n"
      sudo find /etc/apt/keyrings -type f \( -name "*.gpg" -o -name "*.asc" \) -exec sh -c 'echo -e "\033[1;34m── {} ──\033[0m"; sudo strings "$1" 2>/dev/null || echo "No GPG key found or permission denied for {}"; echo ""' _ {} \;
    }
    ## @description Alias for ls-rbac-profile.
    alias ls-rbac-profile='ls_rbac_profile'
    ## @description Alias for ls-rbac-profile.
    alias show-rbac-profile='ls_rbac_profile'
    ## @description Short alias for ls-rbac-profile.
    alias ls-rbac-prof='ls_rbac_profile'
    ## @description Short alias for ls-rbac-profile.
    alias show-rbac-prof='ls_rbac_profile'
    ## @description Show SLiM display manager config.
    ls_dm_slim() {
      echo -e "\n\033[1;34m── 🖥️  SLiM CONFIG ──\033[0m\n"
      sudo cat /etc/slim.conf 2>/dev/null || echo -e "❌ \033[1;31mNo SLiM config found or permission denied\033[0m"
    }
    ## @description Alias for ls-dm-slim.
    alias ls-dm-slim='ls_dm_slim'
    ## @description Alias for ls-dm-slim.
    alias show-dm-slim='ls_dm_slim'
    ## @description Show SDDM display manager config and drop-in files.
    ls_dm_sddm() {
      echo -e "\n\033[1;34m── 🖥️  SDDM CONFIG ──\033[0m\n"
      sudo cat /etc/sddm.conf 2>/dev/null || echo -e "❌ \033[1;31mNo SDDM config found or permission denied\033[0m"
      if [[ -d /etc/sddm.conf.d ]]; then
        echo -e "\n\033[1;34m── 📁 SDDM DROP-IN CONFIGS ──\033[0m\n"
        sudo find /etc/sddm.conf.d -type f -name "*.conf" -exec sh -c 'echo -e "\033[1;34m── {} ──\033[0m"; cat "$1" 2>/dev/null; echo ""' _ {} \;
      fi
    }
    ## @description Alias for ls-dm-sddm.
    alias ls-dm-sddm='ls_dm_sddm'
    ## @description Alias for ls-dm-sddm.
    alias show-dm-sddm='ls_dm_sddm'
    ## @description Show GDM3 display manager configs.
    ls_dm_gdm3() {
      if [[ -d /etc/gdm3 ]]; then
        echo -e "\n\033[1;34m── 🖥️  GDM3 CONFIGS ──\033[0m\n"
        for conf in /etc/gdm3/daemon.conf /etc/gdm3/custom.conf /etc/gdm3/gdm3.conf; do
          if [[ -f "$conf" ]]; then
            echo -e "\033[1;34m── $conf ──\033[0m\n"
            sudo cat "$conf" 2>/dev/null || echo -e "❌ \033[1;31mPermission denied for $conf\033[0m"
            echo ""
          fi
        done
      else
        echo -e "❌ \033[1;31mNo GDM3 config directory found\033[0m"
      fi
    }
    ## @description Alias for ls-dm-gdm3.
    alias ls-dm-gdm3='ls_dm_gdm3'
    ## @description Alias for ls-dm-gdm3.
    alias show-dm-gdm3='ls_dm_gdm3'
    ## @description Alias for ls-dm-gdm3.
    alias ls-dm-gdm='ls_dm_gdm3'
    ## @description Alias for ls-dm-gdm3.
    alias show-dm-gdm='ls_dm_gdm3'
    ## @description Show LightDM display manager configs.
    ls_dm_lightdm() {
      if [[ -d /etc/lightdm ]]; then
        echo -e "\n\033[1;34m── 🖥️  LightDM CONFIGS ──\033[0m\n"
        sudo find /etc/lightdm -type f -name "*.conf" -exec sh -c 'echo -e "\033[1;34m── {} ──\033[0m"; cat "$1" 2>/dev/null; echo ""' _ {} \;
      else
        echo -e "❌ \033[1;31mNo LightDM config directory found\033[0m"
      fi
    }
    ## @description Alias for ls-dm-lightdm.
    alias ls-dm-lightdm='ls_dm_lightdm'
    ## @description Alias for ls-dm-lightdm.
    alias show-dm-lightdm='ls_dm_lightdm'
    ## @description Show LXDM display manager config.
    ls_dm_lxdm() {
      if [[ -d /etc/lxdm ]]; then
        echo -e "\n\033[1;34m── 🖥️  LXDM CONFIG ──\033[0m\n"
        sudo cat /etc/lxdm/lxdm.conf 2>/dev/null || echo -e "❌ \033[1;31mPermission denied for /etc/lxdm/lxdm.conf\033[0m"
      else
        echo -e "❌ \033[1;31mNo LXDM config directory found\033[0m"
      fi
    }
    ## @description Alias for ls-dm-lxdm.
    alias ls-dm-lxdm='ls_dm_lxdm'
    ## @description Alias for ls-dm-lxdm.
    alias show-dm-lxdm='ls_dm_lxdm'
    ## @description Show X11/XDM display config and default display manager.
    ls_dm_x11() {
      if [[ -d /etc/X11/ ]]; then
        echo -e "\n\033[1;34m── 🖥️  X11 CONFIGS ──\033[0m\n"
        echo -e "\033[1;34m── 🏷️  DEFAULT DISPLAY MANAGER ──\033[0m\n"
        sudo cat /etc/X11/default-display-manager 2>/dev/null || echo -e "❌ \033[1;31mNo default-display-manager file found or permission denied\033[0m"
        sudo find /etc/X11 -type f -name "*.conf" -exec sh -c '
          echo -e "\033[1;34m── {} ──\033[0m"
          if file -b --mime-encoding "$1" 2>/dev/null | grep -qi "binary"; then
            echo -e "⚠️  \033[1;33m(binary — showing printable strings)\033[0m"
            strings "$1" 2>/dev/null
          else
            cat "$1" 2>/dev/null
          fi
          echo ""
        ' _ {} \;
        if [[ -d /etc/X11/xdm ]]; then
          echo -e "\n\033[1;34m── 📂 XDM NON-CONFIG FILES ──\033[0m\n"
          sudo find /etc/X11/xdm -type f ! -name "*.conf" -exec sh -c '
            echo -e "\033[1;34m── {} ──\033[0m"
            if file -b --mime-encoding "$1" 2>/dev/null | grep -qi "binary"; then
              echo -e "⚠️  \033[1;33m(binary — showing printable strings)\033[0m"
              strings "$1" 2>/dev/null
            else
              cat "$1" 2>/dev/null
            fi
            echo ""
          ' _ {} \;
        fi
      else
        echo -e "❌ \033[1;31mNo X11 config directory found\033[0m"
      fi
    }
    ## @description Alias for ls-dm-x11.
    alias ls-dm-x11='ls_dm_x11'
    ## @description Alias for ls-dm-x11.
    alias show-dm-x11='ls_dm_x11'
    ## @description Alias for ls-dm-x11.
    alias ls-x11-config='ls_dm_x11'
    ## @description Alias for ls-dm-x11.
    alias show-x11-config='ls_dm_x11'
    ## @description Aggregated display manager profile: SLiM, SDDM, GDM3, LightDM, LXDM, X11.
    ls_full_display_profile() {
      echo -e "\n\033[1;36m══════════ 🖥️  DISPLAY MANAGER PROFILE ══════════\033[0m\n"
      ls_dm_slim
      sleep 1
      ls_dm_sddm
      sleep 1
      ls_dm_gdm3
      sleep 1
      ls_dm_lightdm
      sleep 1
      ls_dm_lxdm
      sleep 1
      ls_dm_x11
    }
    ## @description Alias for ls-full-display-profile.
    alias ls-full-display-profile='ls_full_display_profile'
    ## @description Alias for ls-full-display-profile.
    alias show-full-display-profile='ls_full_display_profile'
    ## @description Alias for ls-full-display-profile.
    alias ls-dm-profile='ls_full_display_profile'
    ## @description Alias for ls-full-display-profile.
    alias show-dm-profile='ls_full_display_profile'
  #endregion System_Setup

