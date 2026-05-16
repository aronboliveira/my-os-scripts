### * START OF PUBLICABLE CODE * ###
#region PUBLICABLE_CODE
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

  #region Network_Procedures
    ## @description Probe a network host with ARP, ping, netcat, and route lookup.
    ## @param $1 {string} ip   - Target IP address (required)
    ## @param $2 {number} port - Target port for netcat (optional)
    ## @flag --gateway  Probe the default gateway automatically
    ## @flag --local    Probe 192.168.1.1:22 (common local router + SSH)
    net_probe() {
      local ip="" port=""
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --gateway)
            ip=$(ip route | awk '/default/{print $3; exit}')
            echo -e "🌐 \033[1;33mUsing gateway: $ip\033[0m"; shift ;;
          --local)
            ip="192.168.1.1"; port="22"
            echo -e "🏠 \033[1;33mUsing local defaults: $ip:$port\033[0m"; shift ;;
          --help|-h) echo -e "📖 \033[1mnet-probe\033[0m <ip> [port] | --gateway | --local"; return 0 ;;
          -*) echo -e "❌ Unknown flag: $1"; return 1 ;;
          *)
            if [ -z "$ip" ]; then ip="$1"; else port="$1"; fi; shift ;;
        esac
      done
      [ -z "$ip" ] && { echo -e "❌ Usage: net-probe <ip> [port] | --gateway | --local"; return 1; }
      echo -e "\033[1;34m── 📡 ARP Table ──\033[0m"
      arp -a 2>/dev/null || true
      echo ""
      echo -e "\033[1;34m── 🏓 Ping ($ip) ──\033[0m"
      ping -c 4 "$ip" || true
      echo ""
      if [ -n "$port" ]; then
        echo -e "\033[1;34m── 🔌 Netcat ($ip:$port) ──\033[0m"
        nc -vz "$ip" "$port" 2>&1 || true
        echo ""
      fi
      echo -e "\033[1;34m── 🗺️  IP Route ──\033[0m"
      ip route get "$ip" 2>/dev/null || true
    }
    alias net-probe='net_probe'
    ## @description Show /proc/net/tcp, tcp6, and IPv4 TCP config files.
    ls_tcp_proc_config() {
      echo -e "\n\033[1;34m── 📁 NET PROCESS FILES ──\033[0m\n"
      sleep 1
      echo -e "\033[1;34m── 🌐 TCP IPv4 ──\033[0m\n"
      sudo cat /proc/net/tcp 2>/dev/null || echo -e "❌ \033[1;31mNo TCP IPv4 info\033[0m"
      sleep 1
      echo -e "\033[1;34m── 🌐 TCP IPv6 ──\033[0m\n"
      sudo cat /proc/net/tcp6 2>/dev/null || echo -e "❌ \033[1;31mNo TCP IPv6 info\033[0m"
      sleep 1
      if [[ -d /proc/sys/net/ipv4/conf ]]; then
        echo -e "\033[1;34m── ⚙️  TCP CONFIG FILES ──\033[0m\n"
        sudo find /proc/sys/net/ipv4/conf -type f -name "tcp_*" -exec sh -c 'echo -e "\033[1;34m── {} ──\033[0m"; cat "$1" 2>/dev/null; echo ""' _ {} \;
      fi
    }
    ## @description Alias for ls-tcp-proc-config.
    alias ls-tcp-proc-config='ls_tcp_proc_config'
    ## @description Alias for ls-tcp-proc-config.
    alias ls-tcp-config-proc='ls_tcp_proc_config'
    ## @description Alias for ls-tcp-proc-config.
    alias ls-tcp-conf-proc='ls_tcp_proc_config'
    ## @description Alias for ls-tcp-proc-config.
    alias ls-tcp-proc-conf='ls_tcp_proc_config'
    ## @description Show IPv4 and IPv6 socket statistics from /proc/net/sockstat.
    ls_net_sockstats() {
      echo -e "\n\033[1;34m── 📊 SOCKSTAT INFO ──\033[0m\n"
      sleep 1
      echo -e "\033[1;34m── 🌐 SOCKSTAT IPv4 ──\033[0m\n"
      sudo cat /proc/net/sockstat 2>/dev/null || echo -e "❌ \033[1;31mNo IPv4 sockstat info\033[0m"
      sleep 1
      echo -e "\033[1;34m── 🌐 SOCKSTAT IPv6 ──\033[0m\n"
      sudo cat /proc/net/sockstat6 2>/dev/null || echo -e "❌ \033[1;31mNo IPv6 sockstat info\033[0m"
    }
    ## @description Alias for ls-net-sockstats.
    alias ls-net-sockstats='ls_net_sockstats'
    ## @description Alias for ls-net-sockstats.
    alias ls-sockstats='ls_net_sockstats'
    ## @description Alias for ls-net-sockstats.
    alias ls-sock-statistics='ls_net_sockstats'
    ## @description Show SNMP TCP statistics from /proc/net/snmp and snmp6.
    ls_net_snmp() {
      echo -e "\n\033[1;34m── 📊 SNMP INFO ──\033[0m\n"
      sleep 1
      echo -e "\033[1;34m── 🌐 SNMP TCP IPv4 ──\033[0m\n"
      sudo cat /proc/net/snmp 2>/dev/null | grep -A10 "Tcp:" || echo -e "❌ \033[1;31mNo SNMP TCP info\033[0m"
      sleep 1
      echo -e "\033[1;34m── 🌐 SNMP TCP IPv6 ──\033[0m\n"
      sudo cat /proc/net/snmp6 2>/dev/null | grep -A10 "Tcp:" || echo -e "❌ \033[1;31mNo SNMP TCP6 info\033[0m"
    }
    ## @description Alias for ls-net-snmp.
    alias ls-net-snmp='ls_net_snmp'
    ## @description Alias for ls-net-snmp.
    alias ls-snmp='ls_net_snmp'
    ## @description Show iptables rules filtered for TCP across filter, nat, and raw tables.
    ls_tcp_iptables_rules() {
      echo -e "\n\033[1;34m── 🔒 ALL IPTABLES RULES FOR TCP ──\033[0m\n"
      sleep 3
      sudo iptables -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo iptables rules for TCP or iptables not available\033[0m"
      sleep 2
      echo -e "\n\033[1;34m── 🔒 NAT IPTABLES RULES FOR TCP ──\033[0m\n"
      sudo iptables -t nat -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo NAT iptables rules for TCP or iptables not available\033[0m"
      sleep 2
      echo -e "\n\033[1;34m── 🔒 RAW IPTABLES FOR TCP ──\033[0m\n"
      sudo iptables -t raw -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo RAW iptables rules for TCP or iptables not available\033[0m"
    }
    ## @description Alias for ls-tcp-iptables.
    alias ls-tcp-iptables='ls_tcp_iptables_rules'
    ## @description Alias for ls-tcp-iptables.
    alias ls-iptables-tcp='ls_tcp_iptables_rules'
    ## @description Alias for ls-tcp-iptables.
    alias ls-tcp-iptables-rules='ls_tcp_iptables_rules'
    ## @description Show TCP congestion control algorithm and available algorithms.
    ls_sys_tcp_v4_congestion_control() {
      echo -e "\n\033[1;34m── ⚙️  TCP CONGESTION CONTROL CONFIGS ──\033[0m\n"
      sudo sysctl net.ipv4.tcp_available_congestion_control 2>/dev/null || echo -e "❌ \033[1;31mtcp_available_congestion_control sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_congestion_control 2>/dev/null || echo -e "❌ \033[1;31mtcp_congestion_control sysctl not available\033[0m"
    }
    ## @description Alias for ls-sys-tcp-v4-congestion-control.
    alias ls-sys-tcp-v4-congestion-control='ls_sys_tcp_v4_congestion_control'
    ## @description Alias for ls-sys-tcp-v4-congestion-control.
    alias ls-sysctl-tcp-v4-congestion-control='ls_sys_tcp_v4_congestion_control'
    ## @description Alias for ls-sys-tcp-v4-congestion-control.
    alias ls-tcp-sysctl-v4-congestion-control='ls_sys_tcp_v4_congestion_control'
    ## @description Alias for ls-sys-tcp-v4-congestion-control.
    alias ls-sys-tcp-congestion-control='ls_sys_tcp_v4_congestion_control'
    ## @description Short alias for ls-sys-tcp-v4-congestion-control.
    alias ls-sys-tcp-cgt-ctrl='ls_sys_tcp_v4_congestion_control'
    ## @description Short alias for ls-sys-tcp-v4-congestion-control.
    alias ls-sysctl-tcp-cgt-ctrl='ls_sys_tcp_v4_congestion_control'
    ## @description Show alias for ls-sysctl-tcp-cgt-ctrl.
    alias show-sys-tcp-v4-congestion-control='ls_sys_tcp_v4_congestion_control'
    ## @description Show alias for ls-sysctl-tcp-cgt-ctrl.
    alias show-sys-tcp-cgt-ctrl='ls_sys_tcp_v4_congestion_control'
    ## @description Show TCP keepalive, timeout, and retry sysctl parameters.
    ls_sys_tcp_v4_time_control() {
      echo -e "\n\033[1;34m── ⏱️  TCP TIME CONTROL CONFIGS ──\033[0m\n"
      sudo sysctl net.ipv4.tcp_keepalive_time 2>/dev/null || echo -e "❌ \033[1;31mtcp_keepalive_time sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_fin_timeout 2>/dev/null || echo -e "❌ \033[1;31mtcp_fin_timeout sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_retries1 2>/dev/null || echo -e "❌ \033[1;31mtcp_retries1 sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_retries2 2>/dev/null || echo -e "❌ \033[1;31mtcp_retries2 sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_synack_retries 2>/dev/null || echo -e "❌ \033[1;31mtcp_synack_retries sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_syn_retries 2>/dev/null || echo -e "❌ \033[1;31mtcp_syn_retries sysctl not available\033[0m"
    }
    ## @description Alias for ls-sys-tcp-v4-time-control.
    alias ls-sys-tcp-v4-time-control='ls_sys_tcp_v4_time_control'
    ## @description Alias for ls-sys-tcp-v4-time-control.
    alias ls-sysctl-tcp-v4-time-control='ls_sys_tcp_v4_time_control'
    ## @description Alias for ls-sys-tcp-v4-time-control.
    alias ls-tcp-sysctl-v4-time-control='ls_sys_tcp_v4_time_control'
    ## @description Alias for ls-sys-tcp-v4-time-control.
    alias ls-tcp-sys-time-control='ls_sys_tcp_v4_time_control'
    ## @description Show alias for ls-tcp-sys-time-control.
    alias show-sys-tcp-v4-time-control='ls_sys_tcp_v4_time_control'
    ## @description Show TCP backlog, orphan, and TIME_WAIT bucket limits.
    ls_sys_tcp_v4_limits() {
      echo -e "\n\033[1;34m── 📏 TCP LIMIT CONFIGS ──\033[0m\n"
      sudo sysctl net.ipv4.tcp_max_syn_backlog 2>/dev/null || echo -e "❌ \033[1;31mtcp_max_syn_backlog sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_max_tw_buckets 2>/dev/null || echo -e "❌ \033[1;31mtcp_max_tw_buckets sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_max_orphans 2>/dev/null || echo -e "❌ \033[1;31mtcp_max_orphans sysctl not available\033[0m"
    }
    ## @description Alias for ls-sys-tcp-v4-limits.
    alias ls-sys-tcp-v4-limits='ls_sys_tcp_v4_limits'
    ## @description Alias for ls-sys-tcp-v4-limits.
    alias ls-sysctl-tcp-v4-limits='ls_sys_tcp_v4_limits'
    ## @description Alias for ls-sys-tcp-v4-limits.
    alias ls-tcp-sysctl-v4-limits='ls_sys_tcp_v4_limits'
    ## @description Alias for ls-sys-tcp-v4-limits.
    alias ls-tcp-sys-limits='ls_sys_tcp_v4_limits'
    ## @description Show alias for ls-tcp-sys-limits.
    alias show-sys-tcp-v4-limits='ls_sys_tcp_v4_limits'
    ## @description Show TCP base MSS and MTU probing sysctl settings.
    ls_sys_tcp_v4_mtu() {
      echo -e "\n\033[1;34m── 📐 TCP MTU CONFIGS ──\033[0m\n"
      sudo sysctl net.ipv4.tcp_base_mss 2>/dev/null || echo -e "❌ \033[1;31mtcp_base_mss sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_mtu_probing 2>/dev/null || echo -e "❌ \033[1;31mtcp_mtu_probing sysctl not available\033[0m"
    }
    ## @description Alias for ls-sys-tcp-v4-mtu.
    alias ls-sys-tcp-v4-mtu='ls_sys_tcp_v4_mtu'
    ## @description Alias for ls-sys-tcp-v4-mtu.
    alias ls-sysctl-tcp-v4-mtu='ls_sys_tcp_v4_mtu'
    ## @description Alias for ls-sys-tcp-v4-mtu.
    alias ls-tcp-sysctl-v4-mtu='ls_sys_tcp_v4_mtu'
    ## @description Show alias for ls-tcp-sysctl-v4-mtu.
    alias show-sys-tcp-v4-mtu='ls_sys_tcp_v4_mtu'
    ## @description Show TCP buffer sizes, fast open, and syncookies sysctl settings.
    ls_sys_tcp_v4_base_config() {
      echo -e "\n\033[1;34m── 🔧 BASE TCP CONFIGS ──\033[0m\n"
      sudo sysctl net.ipv4.tcp_rmem 2>/dev/null || echo -e "❌ \033[1;31mtcp_rmem sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_wmem 2>/dev/null || echo -e "❌ \033[1;31mtcp_wmem sysctl not available\033[0m"
      sudo sysctl net.core.rmem_default 2>/dev/null || echo -e "❌ \033[1;31mcore rmem_default sysctl not available\033[0m"
      sudo sysctl net.core.wmem_default 2>/dev/null || echo -e "❌ \033[1;31mcore wmem_default sysctl not available\033[0m"
      sudo sysctl net.core.rmem_max 2>/dev/null || echo -e "❌ \033[1;31mcore rmem_max sysctl not available\033[0m"
      sudo sysctl net.core.wmem_max 2>/dev/null || echo -e "❌ \033[1;31mcore wmem_max sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_fastopen 2>/dev/null || echo -e "❌ \033[1;31mtcp_fastopen sysctl not available\033[0m"
      sudo sysctl net.ipv4.tcp_syncookies 2>/dev/null || echo -e "❌ \033[1;31mtcp_syncookies sysctl not available\033[0m"
    }
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-tcp-sys-base-v4-config='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-tcp-sysctl-base-v4-config='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-tcp-sysctl-base-v4-conf='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-tcp-sys-tcp-base-v4-conf='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-sys-base-v4-config='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-sysctl-base-v4-config='ls_sys_tcp_v4_base_config'
    ## @description Alias for ls-tcp-sys-base-v4-config.
    alias ls-sys-tcp-base-config='ls_sys_tcp_v4_base_config'
    ## @description Show alias for ls-tcp-sys-base-v4-config.
    alias show-tcp-sys-base-v4-config='ls_sys_tcp_v4_base_config'
    ## @description Show alias for ls-tcp-sys-base-v4-config.
    alias show-sys-tcp-base-config='ls_sys_tcp_v4_base_config'
    ## @description Aggregated view of all IPv4 TCP sysctl settings.
    ls_sys_tcp_v4() {
      echo -e "\n\033[1;34m── 📊 SYSCTL CONFIGS FOR IPv4 ──\033[0m\n"
      ls_sys_tcp_v4_congestion_control
      sleep 2
      ls_sys_tcp_v4_time_control
      sleep 2
      ls_sys_tcp_v4_limits
      sleep 2
      ls_sys_tcp_v4_mtu
      sleep 2
      ls_sys_tcp_v4_base_config
    }
    ## @description Alias for ls-sys-tcp-v4.
    alias ls-sys-tcp-v4='ls_sys_tcp_v4'
    ## @description Alias for ls-sys-tcp-v4.
    alias ls-sysctl-tcp-v4='ls_sys_tcp_v4'
    ## @description Alias for ls-sys-tcp-v4.
    alias ls-tcp-sysctl-v4='ls_sys_tcp_v4'
    ## @description Alias for ls-sys-tcp-v4.
    alias ls-sys-tcp='ls_sys_tcp_v4'
    ## @description Alias for ls-sys-tcp-v4.
    alias ls-tcp-sys='ls_sys_tcp_v4'
    ## @description Show alias for ls-sys-tcp-v4.
    alias show-sys-tcp-v4='ls_sys_tcp_v4'
    ## @description Show alias for ls-sys-tcp-v4.
    alias show-sysctl-tcp-v4='ls_sys_tcp_v4'
    ## @description Show alias for ls-sys-tcp-v4.
    alias show-sys-tcp='ls_sys_tcp_v4'
    ## @description Show listening TCP ports via lsof.
    ls_tcp_listening_ports() {
      echo -e "\n\033[1;34m── 👂 Listening TCP Ports ──\033[0m\n"
      sudo lsof -i TCP -s TCP:LISTEN 2>/dev/null || echo -e "❌ \033[1;31mNo listening TCP ports or lsof not available\033[0m"
    }
    ## @description Alias for ls-tcp-listening-ports.
    alias ls-tcp-listening-ports='ls_tcp_listening_ports'
    ## @description Alias for ls-tcp-listening-ports.
    alias ls-tcp-listen-ports='ls_tcp_listening_ports'
    ## @description Short alias for ls-tcp-listening-ports.
    alias ls-tcp-lp='ls_tcp_listening_ports'
    ## @description Show established TCP connections via lsof.
    ls_tcp_established_connections() {
      echo -e "\n\033[1;34m── 🔗 Established TCP Connections ──\033[0m\n"
      sudo lsof -i TCP -s TCP:ESTABLISHED 2>/dev/null || echo -e "❌ \033[1;31mNo established TCP connections or lsof not available\033[0m"
    }
    ## @description Alias for ls-tcp-established-connections.
    alias ls-tcp-established-connections='ls_tcp_established_connections'
    ## @description Alias for ls-tcp-established-connections.
    alias ls-tcp-established-conns='ls_tcp_established_connections'
    ## @description Alias for ls-tcp-established-connections.
    alias ls-tcp-est-conns='ls_tcp_established_connections'
    ## @description Alias for ls-tcp-established-connections.
    alias ls-tcp-est-connections='ls_tcp_established_connections'
    ## @description Show all active TCP connections, listening ports, and established connections.
    ls_tcp_active_connections() {
      echo -e "\n\033[1;34m── 🔌 All Active TCP Connections ──\033[0m\n"
      sleep 3
      sudo lsof -i TCP -nP 2>/dev/null || echo -e "❌ \033[1;31mNo active TCP connections or lsof not available\033[0m"
      sleep 2
      ls_tcp_listening_ports
      sleep 2
      ls_tcp_established_connections
    }
    ## @description Alias for ls-tcp-active-connections.
    alias ls-tcp-active-connections='ls_tcp_active_connections'
    ## @description Alias for ls-tcp-active-connections.
    alias ls-tcp-active-conns='ls_tcp_active_connections'
    ## @description Alias for ls-tcp-active-connections.
    alias ls-tcp-act-conns='ls_tcp_active_connections'
    ## @description Show TCP sockets via ss and netstat (with deprecation warning for netstat).
    ls_active_tcp_net_sockets() {
      echo -e "\n\033[1;34m── 📡 SS OUTPUT ──\033[0m\n"
      if command -v ss &>/dev/null; then
        sudo ss -tlnp 2>/dev/null || echo -e "❌ \033[1;31mss command not available\033[0m"
      fi
      sleep 3
      echo -e "\n\033[1;34m── 📡 NETSTAT OUTPUT ──\033[0m\n"
      if command -v netstat &>/dev/null; then
        echo -e "⚠️  \033[1;33mWarning: netstat is deprecated. Consider using ss instead.\033[0m"
        sudo netstat -tlnp 2>/dev/null || echo -e "❌ \033[1;31mnetstat command not available\033[0m"
      fi
    }
    ## @description Alias for ls-active-tcp-net-sockets.
    alias ls-active-tcp-net-sockets='ls_active_tcp_net_sockets'
    ## @description Alias for ls-active-tcp-net-sockets.
    alias ls-active-tcp-sockets='ls_active_tcp_net_sockets'
    ## @description Alias for ls-active-tcp-net-sockets.
    alias ls-act-tcp-sockets='ls_active_tcp_net_sockets'
    ## @description Alias for ls-active-tcp-net-sockets.
    alias ls-act-tcp-net-sockets='ls_active_tcp_net_sockets'
    ## @description Short alias for ls-active-tcp-net-sockets.
    alias ls-act-tcp-s='ls_active_tcp_net_sockets'
    ## @description Short alias for ls-active-tcp-net-sockets.
    alias ls-act-tcp-ns='ls_active_tcp_net_sockets'
    ## @description Short alias for ls-active-tcp-net-sockets.
    alias ls-act-tcp-net-s='ls_active_tcp_net_sockets'
    ## @description Full TCP diagnostic: proc files, sockstats, SNMP, iptables, sysctl, connections, and sockets.
    ls_tcp_config() {
      echo -e "\n\033[1;36m══════════ 🌐 TCP CONFIGURATION ══════════\033[0m\n"
      sleep 2
      ls_tcp_proc_config
      sleep 2
      ls_net_sockstats
      sleep 2
      ls_net_snmp
      sleep 1
      ls_tcp_iptables_rules
      sleep 1
      ls_sys_tcp_v4
      sleep 3
      ls_tcp_active_connections
      sleep 3
      ls_active_tcp_net_sockets
    }
    ## @description Alias for ls-tcp-config.
    alias ls-tcp-config='ls_tcp_config'
    ## @description Alias for ls-tcp-config.
    alias ls-tcp-conf='ls_tcp_config'
    ## @description Alias for ls-tcp-config.
    alias ls-tcp-all='ls_tcp_config'
    ## @description Show DNS config, hostname, and IP addresses.
    ls_net_dns_info() {
      echo -e "\n\033[1;34m── 🔎 RESOLV.CONF ──\033[0m\n"
      sudo cat /etc/resolv.conf 2>/dev/null || echo -e "❌ \033[1;31mNo resolv.conf found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 🏷️  HOSTNAME ──\033[0m\n"
      sudo cat /etc/hostname 2>/dev/null || echo -e "❌ \033[1;31mNo hostname file found or permission denied\033[0m"
      echo ""
      hostname -I 2>/dev/null || echo -e "❌ \033[1;31mUnable to retrieve IP addresses\033[0m"
    }
    ## @description Alias for ls-net-dns.
    alias ls-net-dns='ls_net_dns_info'
    ## @description Alias for ls-net-dns.
    alias show-net-dns='ls_net_dns_info'
    ## @description Alias for ls-net-dns.
    alias ls-dns-info='ls_net_dns_info'
    ## @description Alias for ls-net-dns.
    alias show-dns-info='ls_net_dns_info'
    ## @description Show public IP address via curl ifconfig.me (IPv4 and IPv6).
    ls_net_public_ip() {
      if [ -x "$(command -v curl)" ]; then
        echo -e "\n\033[1;34m── 🌍 PUBLIC IP (curl ifconfig.me) ──\033[0m\n"
        echo -e "\033[1;33mNote: This may not work if the system is behind a NAT or firewall that blocks outgoing HTTP requests.\033[0m\n"
        echo -e "\n\nIPv6\n"
        echo -e "(IPv6 may not be shown if the system prefers IPv4 or if IPv6 connectivity is unavailable)\n"
        curl ifconfig.me
        echo -e "\n\nIPv4\n"
        curl -4 ifconfig.me
        echo ""
      else
        echo -e "❌ \033[1;31m'curl' command not found, could not show public IP\033[0m"
      fi
    }
    ## @description Alias for ls-net-public-ip.
    alias ls-net-public-ip='ls_net_public_ip'
    ## @description Alias for ls-net-public-ip.
    alias show-net-public-ip='ls_net_public_ip'
    ## @description Alias for ls-net-public-ip.
    alias ls-public-ip='ls_net_public_ip'
    ## @description Alias for ls-net-public-ip.
    alias show-public-ip='ls_net_public_ip'
    ## @description Show IP addresses via ip addr and ifconfig.
    ls_net_ip_addrs() {
      if [ -x "$(command -v ip)" ]; then
        echo -e "\n\033[1;34m── 📡 IP ADDRESSES (ip addr) ──\033[0m\n"
        ip addr 2>/dev/null || echo -e "❌ \033[1;31mUnable to run 'ip addr' or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'ip' command not found, cannot show IP addresses\033[0m"
      fi
      if [ -x "$(command -v ifconfig)" ]; then
        echo -e "\n\033[1;34m── 📟 IP ADDRESSES (ifconfig) ──\033[0m\n"
        ifconfig 2>/dev/null || echo -e "❌ \033[1;31mUnable to run 'ifconfig' or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'ifconfig' command not found, cannot show IP addresses with ifconfig\033[0m"
      fi
    }
    ## @description Alias for ls-net-ip-addrs.
    alias ls-net-ip-addrs='ls_net_ip_addrs'
    ## @description Alias for ls-net-ip-addrs.
    alias show-net-ip-addrs='ls_net_ip_addrs'
    ## @description Alias for ls-net-ip-addrs.
    alias ls-ip-addrs='ls_net_ip_addrs'
    ## @description Alias for ls-net-ip-addrs.
    alias show-ip-addrs='ls_net_ip_addrs'
    ## @description Show /etc/hosts and /etc/network/interfaces.
    ls_net_hosts_info() {
      echo -e "\n\033[1;34m── 🗃️  HOSTS ──\033[0m\n"
      sudo cat /etc/hosts 2>/dev/null || echo -e "❌ \033[1;31mNo hosts file found or permission denied\033[0m"
      echo -e "\n\033[1;34m── 🔌 NETWORK INTERFACES ──\033[0m\n"
      sudo cat /etc/network/interfaces 2>/dev/null || echo -e "❌ \033[1;31mNo /etc/network/interfaces file found or permission denied\033[0m"
    }
    ## @description Alias for ls-net-hosts.
    alias ls-net-hosts='ls_net_hosts_info'
    ## @description Alias for ls-net-hosts.
    alias show-net-hosts='ls_net_hosts_info'
    ## @description Alias for ls-net-hosts.
    alias ls-hosts-info='ls_net_hosts_info'
    ## @description Alias for ls-net-hosts.
    alias show-hosts-info='ls_net_hosts_info'
    ## @description Show NetworkManager connections and service status.
    ls_net_nm_status() {
      if [ -x "$(command -v nmcli)" ]; then
        echo -e "\n\033[1;34m── 📶 NetworkManager Connections (nmcli) ──\033[0m\n"
        nmcli connection show 2>/dev/null || echo -e "❌ \033[1;31mUnable to run 'nmcli connection show' or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'nmcli' command not found, cannot show NetworkManager connections\033[0m"
      fi
      if [ -x "$(command -v systemctl)" ]; then
        echo -e "\n\033[1;34m── 🔄 NetworkManager Service Status (systemctl) ──\033[0m\n"
        systemctl status NetworkManager 2>/dev/null || echo -e "❌ \033[1;31mUnable to check NetworkManager service status or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'systemctl' command not found, cannot check NetworkManager service status\033[0m"
      fi
    }
    ## @description Alias for ls-net-nm-status.
    alias ls-net-nm-status='ls_net_nm_status'
    ## @description Alias for ls-net-nm-status.
    alias show-net-nm-status='ls_net_nm_status'
    ## @description Alias for ls-net-nm-status.
    alias ls-nm-status='ls_net_nm_status'
    ## @description Alias for ls-net-nm-status.
    alias show-nm-status='ls_net_nm_status'
    ## @description Show iptables and ufw firewall rules.
    ls_net_firewall() {
      if [ -x "$(command -v iptables)" ]; then
        echo -e "\n\033[1;34m── 🔒 IPTABLES RULES ──\033[0m\n"
        sudo iptables -L -n -v 2>/dev/null || echo -e "❌ \033[1;31mUnable to run 'iptables' or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'iptables' command not found, cannot show firewall rules\033[0m"
      fi
      if [ -x "$(command -v ufw)" ]; then
        echo -e "\n\033[1;34m── 🛡️  UFW STATUS ──\033[0m\n"
        sudo ufw status verbose 2>/dev/null || echo -e "❌ \033[1;31mUnable to run 'ufw' or permission denied\033[0m"
      else
        echo -e "❌ \033[1;31m'ufw' command not found, cannot show UFW firewall status\033[0m"
      fi
    }
    ## @description Alias for ls-net-firewall.
    alias ls-net-firewall='ls_net_firewall'
    ## @description Alias for ls-net-firewall.
    alias show-net-firewall='ls_net_firewall'
    ## @description Alias for ls-net-firewall.
    alias ls-firewall='ls_net_firewall'
    ## @description Alias for ls-net-firewall.
    alias show-firewall='ls_net_firewall'
    ## @description Aggregated network profile: DNS, public IP, sysctl, IP addresses, hosts, NetworkManager, firewall.
    ls_net_profile() {
      echo -e "\n\033[1;36m══════════ 🌐 NETWORK PROFILE ══════════\033[0m\n"
      ls_net_dns_info
      sleep 3
      ls_net_public_ip
      sleep 3
      if [ -x "$(command -v sysctl)" ]; then
        echo -e "\n\033[1;34m── 📊 SYSCTL NETWORK CONFIGS FOR IPv4 ──\033[0m\n"
        ls_sys_tcp_v4
      else
        echo -e "❌ \033[1;31m'sysctl' command not found, cannot show sysctl network configs\033[0m"
      fi
      sleep 3
      ls_net_ip_addrs
      sleep 3
      ls_net_hosts_info
      sleep 3
      ls_net_nm_status
      sleep 3
      ls_net_firewall
    }
    ## @description Alias for ls-net-profile.
    alias ls-net-profile='ls_net_profile'
    ## @description Alias for ls-net-profile.
    alias show-net-profile='ls_net_profile'
    ## @description Alias for ls-net-profile.
    alias ls-network-profile='ls_net_profile'
    ## @description Alias for ls-net-profile.
    alias show-network-profile='ls_net_profile'
    ## @description Show dconf user config (binary), loginctl sessions/user info, and home directory listing.
    ls_home_profile() {
      echo -e "\n\033[1;34m── 🏠 DCONF USER CONFIG ──\033[0m\n"
      if [[ -f ~/.config/dconf/user ]]; then
        echo -e "⚠️  \033[1;33m(binary GVariant database — showing printable strings)\033[0m"
        strings ~/.config/dconf/user 2>/dev/null || echo -e "❌ \033[1;31mUnable to read dconf user config\033[0m"
      else
        echo -e "❌ \033[1;31mdconf user config not found\033[0m"
      fi
      sleep 2

      echo -e "\n\033[1;34m── 🗂️  LISTED SESSIONS ──\033[0m\n"
      loginctl list-sessions 2>/dev/null || echo -e "❌ \033[1;31mUnable to list sessions with loginctl\033[0m"
      sleep 2

      echo -e "\n\033[1;34m── 🏷️  CURRENT SESSION ID ──\033[0m\n"
      if [[ -n "$XDG_SESSION_ID" ]]; then
        echo "$XDG_SESSION_ID"
      else
        echo -e "❌ \033[1;31mXDG_SESSION_ID environment variable not set\033[0m"
      fi
      echo -e "\n\033[1;34m── ⚙️  CURRENT SESSION INFO ──\033[0m\n"
      loginctl show-session "${XDG_SESSION_ID}" 2>/dev/null || echo -e "❌ \033[1;31mUnable to show current session info with loginctl\033[0m"
      sleep 2

      echo -e "\n\033[1;34m── 👤 CURRENT USER INFO ──\033[0m\n"
      loginctl show-user "${USER}" 2>/dev/null || echo -e "❌ \033[1;31mUnable to show current user info with loginctl\033[0m"
      sleep 2

      echo -e "\n\033[1;34m── 📁 HOME DIRECTORY ──\033[0m\n"
      echo "$HOME"
      ls -lAh --color=auto "$HOME" 2>/dev/null || echo -e "❌ \033[1;31mUnable to list home directory contents\033[0m"
    }
    ## @description Alias for ls-home-profile.
    alias ls-home-profile='ls_home_profile'
    ## @description Alias for ls-home-profile.
    alias show-home-profile='ls_home_profile'
    ## @description Alias for ls-home-profile.
    alias ls-dconf-profile='ls_home_profile'
    ## @description Alias for ls-home-profile.
    alias show-dconf-profile='ls_home_profile'
    ## @description Full system profile: env, fstab, RBAC, display managers, network, and home config.
    ls_full_profile() {
      echo -e "\n\033[1;36m══════════ 📦 FULL SYSTEM PROFILE ══════════\033[0m\n"
      ls_env_profile
      sleep 3
      ls_tabs_profile
      sleep 3
      ls_rbac_profile
      sleep 3
      ls_full_display_profile
      sleep 3
      ls_net_profile
      sleep 3
      ls_home_profile
    }
    ## @description Alias for ls-full-profile.
    alias ls-full-profile='ls_full_profile'
    ## @description Alias for ls-full-profile.
    alias show-full-profile='ls_full_profile'
    ## @description Alias for ls-full-profile.
    alias ls-all-profiles='ls_full_profile'
    ## @description Alias for ls-full-profile.
    alias show-all-profiles='ls_full_profile'

    ## @description Run powerstat (RAPL) and tee output to a timestamped log,
    ##   with the Watts column moved from last to second position.
    ## @param $1 {number} duration - Recording duration in seconds (default: 3600)
    ## @param $2 {number} tick     - Sampling interval in seconds (default: 1)
    track_power_usage() {
      local duration=${1:-3600}
      local tick=${2:-1}
      if ! command -v powerstat &>/dev/null; then
        echo -e "❌ \033[1;31mpowerstat not found.\033[0m Install with: sudo apt install powerstat"
        return 1
      fi
      mkdir -p "$HOME/.logs/powerstat"
      local log="$HOME/.logs/powerstat/powerstat-$(date +%Y-%m-%d_%H-%M-%S).log"
      echo -e "⚡ \033[1;36mRecording power stats for ${duration}s (tick: ${tick}s) → $log\033[0m"
      sudo stdbuf -oL powerstat -R "$tick" "$duration" | tee "$log"
    }
    alias track-power-usage='track_power_usage'
    ## @description Like cat_band but tee the bandwidth result to a timestamped
    ##   log file in ~/.logs/cat-band/.
    cat_band_tee() {
      mkdir -p "$HOME/.logs/cat-band"
      local log="$HOME/.logs/cat-band/$(date +%Y%m%d_%H%M%S)"
      echo -e "📡 \033[1;36mCapturing bandwidth... Press Enter to stop.\033[0m"
      local init fin
      init="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
      read -r _
      fin="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
      local result
      result=$(printf "%4sB of bandwidth used.\n" "$(numfmt --to=iec $(( fin - init )))")
      echo "$result" | tee "$log"
      echo -e "\033[2;37mSaved to $log\033[0m"
    }
    alias cat-band-tee='cat_band_tee'
    ## @description Like cat_band_tee but with an automatic duration (in seconds)
    ##   instead of waiting for Enter. Samples rx_bytes at start, sleeps for
    ##   the given duration, then samples again and tees the result.
    ## @param $1 {number} seconds - Duration to track (default: 60)
    cat_band_tee_d() {
      local secs=${1:-60}
      mkdir -p "$HOME/.logs/cat-band"
      local log="$HOME/.logs/cat-band/$(date +%Y%m%d_%H%M%S)"
      echo -e "📡 \033[1;36mTracking bandwidth for ${secs}s...\033[0m"
      local init fin
      init="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
      sleep "$secs"
      fin="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
      local result
      result=$(printf "%4sB of bandwidth used in %ss.\n" "$(numfmt --to=iec $(( fin - init )))" "$secs")
      echo "$result" | tee "$log"
      echo -e "\033[2;37mSaved to $log\033[0m"
    }
    alias cat-band-tee-d='cat_band_tee_d'
#endregion Network_Procedures

  #region User_Management
    ## @description Create a new user and add them to the sudo group.
    ## @param $1 {string} username - New username (required)
    add_sudo_user() {
      local username="${1:-}"
      if [ -z "$username" ]; then
        echo -e "📖 \033[1mUsage:\033[0m add-sudo-user <username>"
        return 1
      fi
      echo -e "👤 \033[1;36mCreating user '$username'...\033[0m"
      sudo adduser "$username"
      sudo usermod -aG sudo "$username"
      echo -e "✅ \033[1;32mUser '$username' created and added to sudo group.\033[0m"
    }
    alias add-sudo-user='add_sudo_user'
    ## @description Display sudoers file content (requires permissions).
    alias cat-sudoers='cat /etc/sudoers 2>/dev/null || echo "Cannot read sudoers file"'
    ## @description Alias for cat-sudoers.
    alias ls-sudoers='cat /etc/sudoers 2>/dev/null || echo "Cannot read sudoers file"'
    ## @description Alias for cat-sudoers.
    alias show-sudoers='cat /etc/sudoers 2>/dev/null || echo "Cannot read sudoers file"'
    ## @description Scan sudo health: validates timestamp, shows TTY, sudo sessions, environment vars, and sudoers content.
    alias scan-sudo-health='sudo -v 2>&1; echo "Timestamp: $(sudo -v 2>&1 && echo valid || echo expired)"; echo "---TTY---"; tty; echo "---SUDO SESSION---"; sudo ls /run/sudo/ts/ 2>/dev/null && sudo ls -la /run/sudo/ts/ 2>/dev/null; echo "---ENV---"; echo "TERM=$TERM USER=$USER PWD=$PWD HOSTTYPE=$HOSTTYPE HOME=$HOME SHELL=$SHELL"; echo "---SUDOERS---"; sudo cat /etc/sudoers 2>/dev/null || echo "Cannot read sudoers file"'
    ## @description Show sudoers timestamp_timeout setting.
    alias cat-sudoers-timestamp='sudo cat /etc/sudoers | grep timestamp_timeout 2>/dev/null || echo "No timestamp_timeout setting found in sudoers"'
    ## @description Alias for cat-sudoers-timestamp.
    alias ls-sudoers-timestamp='sudo cat /etc/sudoers | grep timestamp_timeout 2>/dev/null || echo "No timestamp_timeout setting found in sudoers"'
    ## @description Alias for cat-sudoers-timestamp.
    alias show-sudoers-timestamp='sudo cat /etc/sudoers | grep timestamp_timeout 2>/dev/null || echo "No timestamp_timeout setting found in sudoers"'
#endregion User_Management

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

  #region System_Info_Aliases
    #region Kernel_and_OS
      alias cat-grub-boot='sudo cat /boot/grub/grub.cfg'
      ## @description Alias for cat-grub-boot.
      alias ls-grub-boot='sudo cat /boot/grub/grub.cfg'
      ## @description Alias for cat-grub-boot.
      alias show-grub-boot='sudo cat /boot/grub/grub.cfg'
      alias cat-def-grub='sudo cat /etc/default/grub 2>/dev/null || printf "[-] No file found at /etc/default/grub\n"'
      alias cat-default-grub='cat-def-grub'
      alias cat-grub-etc='cat-def-grub'
      ## @description Alias for cat-grub-etc.
      alias ls-grub-etc='cat-def-grub'
      ## @description Alias for cat-grub-etc.
      alias show-grub-etc='cat-def-grub'
      alias cat-k-os='sudo cat /proc/sys/kernel/osrelease'
      ## @description Alias for cat-k-os.
      alias ls-k-os='sudo cat /proc/sys/kernel/osrelease'
      ## @description Alias for cat-k-os.
      alias show-k-os='sudo cat /proc/sys/kernel/osrelease'
      alias cat-etc-os='sudo cat /etc/os-release'
      ## @description Alias for cat-etc-os.
      alias ls-etc-os='sudo cat /etc/os-release'
      ## @description Alias for cat-etc-os.
      alias show-etc-os='sudo cat /etc/os-release'
      alias cat-os-v='sudo cat /proc/version'
      ## @description Alias for cat-os-v.
      alias ls-os-v='sudo cat /proc/version'
      ## @description Alias for cat-os-v.
      alias show-os-v='sudo cat /proc/version'
      alias cat-linux-v='sudo cat /proc/version'
      ## @description Alias for cat-linux-v.
      alias ls-linux-v='sudo cat /proc/version'
      ## @description Alias for cat-linux-v.
      alias show-linux-v='sudo cat /proc/version'
      ## @description Show distro ID (debian, ubuntu, fedora, etc.).
      alias cat-distro-n='(. /etc/os-release 2>/dev/null && echo "${ID:-unknown}")'
      ## @description Alias for cat-distro-n.
      alias ls-distro-n='(. /etc/os-release 2>/dev/null && echo "${ID:-unknown}")'
      ## @description Alias for cat-distro-n.
      alias show-distro-n='(. /etc/os-release 2>/dev/null && echo "${ID:-unknown}")'
      ## @description Show distro version number.
      alias cat-distro-v='(. /etc/os-release 2>/dev/null && echo "${VERSION_ID:-unknown}")'
      ## @description Alias for cat-distro-v.
      alias ls-distro-v='(. /etc/os-release 2>/dev/null && echo "${VERSION_ID:-unknown}")'
      ## @description Alias for cat-distro-v.
      alias show-distro-v='(. /etc/os-release 2>/dev/null && echo "${VERSION_ID:-unknown}")'
      ## @description Show full distro name with version.
      alias cat-distro='(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-unknown}")'
      ## @description Alias for cat-distro.
      alias ls-distro='(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-unknown}")'
      ## @description Alias for cat-distro.
      alias show-distro='(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-unknown}")'
      alias cat-k-host='sudo cat /proc/sys/kernel/hostname'
      ## @description Alias for cat-k-host.
      alias ls-k-host='sudo cat /proc/sys/kernel/hostname'
      ## @description Alias for cat-k-host.
      alias show-k-host='sudo cat /proc/sys/kernel/hostname'
      alias cat-cmdline='sudo cat /proc/cmdline'
      ## @description Alias for cat-cmdline.
      alias ls-cmdline='sudo cat /proc/cmdline'
      ## @description Alias for cat-cmdline.
      alias show-cmdline='sudo cat /proc/cmdline'
      ## @description Show mimeapps list in ~/.config
      alias cat-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="'
      ## @description Alias for cat-mimeapps.
      alias ls-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="'
      ## @description Alias for cat-mimeapps.
      alias show-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="'
      ## @description Show mimeapps list in ~/.local/share/applications
      alias cat-share-mimeapps='cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Alias for cat-share-mimeapps.
      alias ls-share-mimeapps='cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Alias for cat-share-mimeapps.
      alias show-share-mimeapps='cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Show both mimeapps lists (config and local share)
      alias cat-all-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="; cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Alias for cat-all-mimeapps.
      alias ls-all-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="; cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Alias for cat-all-mimeapps.
      alias show-all-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="; cat ~/.local/share/applications/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME FOR APPS ==="'
      ## @description Show mimeinfo.cache
      alias cat-share-mimecache='sudo cat /usr/share/applications/mimeinfo.cache 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME INFO ==="'
      ## @description Alias for cat-share-mimecache.
      alias ls-share-mimecache='sudo cat /usr/share/applications/mimeinfo.cache 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME INFO ==="'
      ## @description Alias for cat-share-mimecache.
      alias show-share-mimecache='sudo cat /usr/share/applications/mimeinfo.cache 2>/dev/null || echo "=== NO LIST FOUND FOR SHARE OF MIME INFO ==="'
      ## @description Show GNOME global keyboard shortcuts (keybindings).
      alias show-gnome-global-shortcuts='gsettings list-recursively org.gnome.desktop.wm.keybindings'
      ## @description Alias for show-gnome-global-shortcuts.
      alias list-gnome-global-shortcuts='gsettings list-recursively org.gnome.desktop.wm.keybindings'
      ## @description Alias for show-gnome-global-shortcuts.
      alias ls-gnome-global-shortcuts='gsettings list-recursively org.gnome.desktop.wm.keybindings'
      ## @description Show KDE global keyboard shortcuts from kglobalshortcutsrc.
      alias show-kde-global-shortcuts='cat ~/.config/kglobalshortcutsrc 2>/dev/null || echo "=== NO KDE GLOBAL SHORTCUTS CONFIG FOUND ==="'
      ## @description Alias for show-kde-global-shortcuts.
      alias list-kde-global-shortcuts='cat ~/.config/kglobalshortcutsrc 2>/dev/null || echo "=== NO KDE GLOBAL SHORTCUTS CONFIG FOUND ==="'
      ## @description Alias for show-kde-global-shortcuts.
      alias ls-kde-global-shortcuts='cat ~/.config/kglobalshortcutsrc 2>/dev/null || echo "=== NO KDE GLOBAL SHORTCUTS CONFIG FOUND ==="'
      ## @description Show all global keyboard shortcuts (GNOME + KDE).
      alias show-global-shortcuts='show-gnome-global-shortcuts; show-kde-global-shortcuts'
      ## @description Alias for show-global-shortcuts.
      alias list-global-shortcuts='list-gnome-global-shortcuts; list-kde-global-shortcuts'
      ## @description Alias for show-global-shortcuts.
      alias ls-global-shortcuts='show-gnome-global-shortcuts; show-kde-global-shortcuts'

#endregion Kernel_and_OS

    #region VM_and_Memory
      alias cat-vm-swap='sudo cat /proc/sys/vm/swappiness'
      ## @description Alias for cat-vm-swap.
      alias ls-vm-swap='sudo cat /proc/sys/vm/swappiness'
      ## @description Alias for cat-vm-swap.
      alias show-vm-swap='sudo cat /proc/sys/vm/swappiness'
      alias cat-vm-over-mem='sudo cat /proc/sys/vm/overcommit_memory'
      ## @description Alias for cat-vm-over-mem.
      alias ls-vm-over-mem='sudo cat /proc/sys/vm/overcommit_memory'
      ## @description Alias for cat-vm-over-mem.
      alias show-vm-over-mem='sudo cat /proc/sys/vm/overcommit_memory'
      alias cat-vm-over-ratio='sudo cat /proc/sys/vm/overcommit_ratio'
      ## @description Alias for cat-vm-over-ratio.
      alias ls-vm-over-ratio='sudo cat /proc/sys/vm/overcommit_ratio'
      ## @description Alias for cat-vm-over-ratio.
      alias show-vm-over-ratio='sudo cat /proc/sys/vm/overcommit_ratio'
      alias cat-cpu-inf='sudo cat /proc/cpuinfo'
      ## @description Alias for cat-cpu-inf.
      alias ls-cpu-inf='sudo cat /proc/cpuinfo'
      ## @description Alias for cat-cpu-inf.
      alias show-cpu-inf='sudo cat /proc/cpuinfo'
      alias cat-mem-inf='sudo cat /proc/meminfo'
      ## @description Alias for cat-mem-inf.
      alias ls-mem-inf='sudo cat /proc/meminfo'
      ## @description Alias for cat-mem-inf.
      alias show-mem-inf='sudo cat /proc/meminfo'
      ## @description Show systemd OOM daemon configuration from /etc/systemd/oomd.conf.
      alias cat-oom-conf='sudo cat /etc/systemd/oomd.conf 2>/dev/null || echo "No OOM config file found"'
      ## @description Alias for cat-oom-conf.
      alias ls-oom-conf='sudo cat /etc/systemd/oomd.conf 2>/dev/null || echo "No OOM config file found"'
      ## @description Alias for cat-oom-conf.
      alias show-oom-conf='sudo cat /etc/systemd/oomd.conf 2>/dev/null || echo "No OOM config file found"'
      ## @description Show the vm.oom_kill_allocating_task sysctl value (0=kill random, 1=kill allocating task).
      alias show-oom-kill-alloc='sudo sysctl vm.oom_kill_allocating_task'
      alias ls-oom-kill-alloc='show-oom-kill-alloc'
      ## @description Follow earlyoom daemon output with verbose reporting at a set interval.
      ## @param $1 {int} interval - Reporting interval in seconds (default: 2)
      follow_early_oom_rec() {
        local interval="${1:-2}"
        earlyoom -r "$interval"
      }
      alias follow-early-oom-rec='follow_early_oom_rec'
      alias watch-early-oom-rec='follow_early_oom_rec'
      alias follow-early-oom='follow_early_oom_rec'
      alias watch-early-oom='follow_early_oom_rec'
      alias cat-def-earlyoom='sudo cat /etc/default/earlyoom 2>/dev/null || printf "[-] No default earlyoom config found\n"'
      alias ls-def-earlyoom='cat-def-earlyoom'
      alias cat-default-earlyoom='cat-def-earlyoom'
      alias ls-default-earlyoom='cat-def-earlyoom'
      ## @description Watch memory-hungry processes sorted by RSS in real time.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch_mem_hogs() {
        local interval="${1:-0.25}"
        watch -n "$interval" 'ps aux --sort=-%mem | awk "{print \$1,\$2,\$4,\$5,\$6,\$8,\$11}"'
      }
      alias watch-mem-hogs='watch_mem_hogs'
      ## @description Watch CPU-hungry processes sorted by CPU usage in real time.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch_cpu_hogs() {
        local interval="${1:-0.25}"
        watch -n "$interval" 'ps aux --sort=-%cpu | awk "{print \$1,\$2,\$3,\$8,\$11}"'
      }
      alias watch-cpu-hogs='watch_cpu_hogs'
      ls_sys_vm_overcommit() {
        printf "[*] Checking vm.overcommit_memory...\n"
        sudo sysctl vm.overcommit_memory 2>/dev/null || printf "[-] No overcommit_memory info available\n"
        printf "[*] Checking vm.overcommit_ratio...\n"
        sudo sysctl vm.overcommit_ratio 2>/dev/null || printf "[-] No overcommit_ratio info available\n"
      }
      alias ls-sys-vm-overcommit='ls_sys_vm_overcommit'
      alias ls-sys-vm-over-mem='ls_sys_vm_overcommit'
      ls_sys_vm_oom_kill_alloc() {
        printf "[*] Checking vm.oom_kill_allocating_task...\n"
        sudo sysctl vm.oom_kill_allocating_task 2>/dev/null || printf "[-] No oom_kill_allocating_task info available\n"
      }
      alias ls-sys-vm-oom-kill-alloc='ls_sys_vm_oom_kill_alloc'
      alias ls-sys-vm-oom-kill-allocating-task='ls_sys_vm_oom_kill_alloc'
      ls_sys_vm_swappiness() {
        printf "[*] Checking vm.swappiness...\n"
        sudo sysctl vm.swappiness 2>/dev/null || printf "[-] No swappiness info available\n"
      }
      alias ls-sys-vm-swappiness='ls_sys_vm_swappiness'
      alias ls-sys-vm-swap='ls_sys_vm_swappiness'
      ls_sys_vm_dirty_ratios() {
        printf "[*] Checking vm.dirty_ratio...\n"
        sudo sysctl vm.dirty_ratio 2>/dev/null || printf "[-] No dirty_ratio info available\n"
        printf "[*] Checking vm.dirty_background_ratio...\n"
        sudo sysctl vm.dirty_background_ratio 2>/dev/null || printf "[-] No dirty_background_ratio info available\n"
      }
      alias ls-sys-vm-dirty-ratios='ls_sys_vm_dirty_ratios'
      alias ls-sys-vm-dirtyness='ls_sys_vm_dirty_ratios'
      ls_sys_kernel_hungs() {
        printf "[*] Checking for kernel hungs...\n"
        sudo sysctl kernel.hung_task_timeout_secs 2>/dev/null || printf "[-] No hung task timeout info available\n"
        printf "[*] Checking for warning about hung tasks...\n"
        sudo sysctl kernel.hung_task_warnings 2>/dev/null || printf "[-] No hung task warning info available\n"
        printf "[*] Checking for hung task backtraces...\n"
        sudo sysctl kernel.hung_task_all_cpu_backtrace 2>/dev/null || printf "[-] No hung task backtrace info available\n"
      }
      alias ls-sys-kernel-hungs='ls_sys_kernel_hungs'
      alias ls-sys-k-hungs='ls_sys_kernel_hungs'
      alias ls-sys-kernel-hung-tasks='ls_sys_kernel_hungs'
      alias ls-sys-k-hung-tasks='ls_sys_kernel_hungs'
      ls_sys_kernel_schedules() {
        printf "[*] Checking for scheduler info...\n"
        sudo sysctl kernel.sched_latency_ns 2>/dev/null || printf "[-] No scheduler latency info available\n"
        sudo sysctl kernel.sched_min_granularity_ns 2>/dev/null || printf "[-] No scheduler min granularity info available\n"
        sudo sysctl kernel.sched_child_runs_first 2>/dev/null || printf "[-] No scheduler child runs first info available\n"
        sudo sysctl kernel.sched_autogroup_enabled 2>/dev/null || printf "[-] No scheduler autogroup info available\n"
        sudo sysctl kernel.sched_migration_cost_ns 2>/dev/null || printf "[-] No scheduler migration cost info available\n"
      }
      alias ls-sys-kernel-schedules='ls_sys_kernel_schedules'
      alias ls-sys-k-schedules='ls_sys_kernel_schedules'
      ## @description Aggregated view of kernel hung-task and scheduler parameters.
      ls_sys_kernel_info() {
        printf "\n[=== KERNEL INFO ===]\n"
        sleep 1
        printf "[=== KERNEL HUNGS ===]\n"
        ls_sys_kernel_hungs
        sleep 2
        printf "[=== KERNEL SCHEDULER ===]\n"
        ls_sys_kernel_schedules
      }
      alias ls-sys-kernel-info='ls_sys_kernel_info'
      alias ls-sys-k-info='ls_sys_kernel_info'
      ## @description Aggregated view of VM overcommit, OOM, swappiness, and dirty-ratio parameters.
      ls_sys_vm_info() {
        printf "\n[=== VM INFO ===]\n"
        sleep 1
        printf "[=== VM OVERCOMMIT ===]\n"
        ls_sys_vm_overcommit
        sleep 1
        printf "[=== VM OOM KILL ALLOCATING TASK ===]\n"
        ls_sys_vm_oom_kill_alloc
        sleep 1
        printf "[=== VM SWAPPINESS ===]\n"
        ls_sys_vm_swappiness
        sleep 1
        printf "[=== VM DIRTY RATIOS ===]\n"
        ls_sys_vm_dirty_ratios
      }
      alias ls-sys-vm-info='ls_sys_vm_info'
      ## @description Show all kernel and VM sysctl info (calls ls_sys_kernel_info + ls_sys_vm_info).
      ls_sys_info() {
        ls_sys_kernel_info
        sleep 3
        ls_sys_vm_info
      }
      alias ls-sys-info='ls_sys_info'
      ## @description List zombie processes (state Z) from ps aux output.
      ## @param $1 {int} head - Max number of results to display (default: 20)
      find_zombies() {
        local head="${1:-20}"
        ps aux | awk '$8 ~ /Z/ {print}' | head -n "$head"
      }
      alias find-zombies='find_zombies'
      ## @description Show the OOM kill score for a process (higher = more likely to be killed).
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_kill_score() {
        local pid="${1?"Usage: cat-pid-oom-kill-score <pid>"}"
        echo ==== "OOM SCORE (TO BE KILLED)" ====
        sudo cat /proc/"$pid"/oom_score 2>/dev/null || printf "[-] No OOM score info available\n"
      }
      alias cat-pid-oom-kill-score='cat_pid_oom_kill_score'
      follow_pid_oom_kill_score() {
        local pid="${1?"Usage: follow-pid-oom-kill-score <pid>"}"
        watch -n 1 "echo ==== \"OOM SCORE (TO BE KILLED)\" ==== && sudo cat /proc/$pid/oom_score 2>/dev/null || echo 'No OOM score info available'"
      }
      alias follow-pid-oom-kill-score='follow_pid_oom_kill_score'
      alias watch-pid-oom-kill-score='follow_pid_oom_kill_score'
      ## @description Show the OOM adjustment score for a process (-1000 to 1000; lower = less likely to be killed).
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_adj_score() {
        local pid="${1?"Usage: cat-pid-oom-adj-score <pid>"}"
        echo ==== "OOM SCORE (TO BE ADJUSTED)" ====
        sudo cat /proc/"$pid"/oom_score_adj 2>/dev/null || printf "[-] No OOM adj info available\n"
      }
      alias cat-pid-oom-adj-score='cat_pid_oom_adj_score'
      ## @description Show both OOM kill score and adjustment score for a process.
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_scores() {
        local pid="${1?"Usage: cat-pid-oom-scores <pid>"}"
        echo ==== "OOM SCORE (TO BE KILLED)" ====
        sudo cat /proc/"$pid"/oom_score 2>/dev/null || printf "[-] No OOM score info available\n"
        echo ==== "OOM SCORE (TO BE ADJUSTED)" ====
        sudo cat /proc/"$pid"/oom_score_adj 2>/dev/null || printf "[-] No OOM adj info available\n"
      }
      alias cat-pid-oom-scores='cat_pid_oom_scores'
      ## @description Follow the earlyoom systemd journal (sudo journalctl -u earlyoom).
      alias journal-earlyoom='sudo journalctl -u earlyoom'
      ## @description Follow the systemd-oomd journal (sudo journalctl -u systemd-oomd).
      alias journal-sysoomd='sudo journalctl -u systemd-oomd'
#endregion VM_and_Memory

    #region Storage_and_Partitions
      alias cat-partitions='sudo cat /proc/partitions'
      ## @description Alias for cat-partitions.
      alias ls-partitions='sudo cat /proc/partitions'
      ## @description Alias for cat-partitions.
      alias show-partitions='sudo cat /proc/partitions'
      alias cat-fstab='sudo cat /etc/fstab'
      ## @description Alias for cat-fstab.
      alias ls-fstab='sudo cat /etc/fstab'
      ## @description Alias for cat-fstab.
      alias show-fstab='sudo cat /etc/fstab'
#endregion Storage_and_Partitions

    #region Drivers_and_Modules
      alias cat-nvidia-v='sudo cat /proc/driver/nvidia/version'
      ## @description Alias for cat-nvidia-v.
      alias ls-nvidia-v='sudo cat /proc/driver/nvidia/version'
      ## @description Alias for cat-nvidia-v.
      alias show-nvidia-v='sudo cat /proc/driver/nvidia/version'
      alias stringify-snapd='sudo strings /lib/snapd/snapd'
      ## @description Alias for cat-sys-services.
      alias ls-sys-services='sudo ls /lib/systemd/system/'
      alias cat-systemd-conf='sudo cat /etc/systemd/system.conf 2>/dev/null || printf "[-] No systemd system.conf file found\n"'
      alias ls-systemd-conf='cat-systemd-conf'
      alias show-systemd-conf='cat-systemd-conf'
      ## @description Display /etc/sysctl.conf and all files in /etc/sysctl.d/.
      cat_sysctl_conf() {
        printf "[*] Checking /etc/sysctl.conf...\n"
        sudo cat /etc/sysctl.conf 2>/dev/null || printf "[-] No sysctl.conf file found\n"
        sleep 2
        printf "[*] Checking /etc/sysctl.d/ directory for additional config files...\n"
        sudo find /etc/sysctl.d/ -type f -exec sh -c 'printf "[=== %s ===]\n" "$1"; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-sysctl-conf='cat_sysctl_conf'
      alias ls-sysctl-conf='cat_sysctl_conf'
      alias show-sysctl-conf='cat_sysctl_conf'
      ## @description Display systemd-sysctl.service and sysinit.target.wants sysctl overrides.
      cat_systemd_sysctl_services() {
        printf "[*] Checking systemd-sysctl.service for sysctl overrides...\n"
        sudo cat /usr/lib/systemd/system/systemd-sysctl.service 2>/dev/null || printf "[-] No systemd-sysctl.service file found\n"
        sleep 1
        printf "[*] Checking systemd services for sysctl overrides...\n"
        sleep 2
        sudo cat /usr/lib/systemd/system/sysinit.target.wants/systemd-sysctl.service 2>/dev/null || printf "[-] No sysctl overrides found in systemd service files\n"
      }
      alias cat-sysctl-services='cat_systemd_sysctl_services'
      alias ls-sysctl-services='cat_systemd_sysctl_services'
      alias show-sysctl-services='cat_systemd_sysctl_services'
      alias cat-sctl-svc='cat_systemd_sysctl_services'
      alias ls-sctl-svc='cat_systemd_sysctl_services'
      alias show-sctl-svc='cat_systemd_sysctl_services'
      ## @description Alias for cat-mod-dkms.
      alias ls-mod-dkms='sudo ls "/lib/modules/$(uname -r)/updates/dkms/"'
      ## @description Show OpenGL renderer, version, and direct rendering status.
      alias glx-info='glxinfo 2>/dev/null | grep -E "(OpenGL renderer|OpenGL version|direct rendering)" || echo "glxinfo not available (install mesa-utils)"'
#endregion Drivers_and_Modules

    #region System_Config_Files
      alias cat-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      ## @description Alias for cat-gdm3-conf.
      alias ls-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      ## @description Alias for cat-gdm3-conf.
      alias show-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      ## @description Show libvirt daemon configuration from /etc/libvirt/libvirtd.conf.
      alias show-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Alias for show-libvirt-conf.
      alias ls-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Alias for show-libvirt-conf.
      alias cat-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias show-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias ls-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias cat-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      ## @description Show the system hosts file (/etc/hosts).
      alias cat-hosts='sudo cat /etc/hosts'
      ## @description Alias for cat-hosts.
      alias ls-hosts='sudo cat /etc/hosts'
      ## @description Alias for cat-hosts.
      alias show-hosts='sudo cat /etc/hosts'
      alias cat-users='sudo cat /etc/passwd | cut -d: -f1'
      ## @description Alias for cat-users.
      alias ls-users='sudo cat /etc/passwd | cut -d: -f1'
      ## @description Alias for cat-users.
      alias show-users='sudo cat /etc/passwd | cut -d: -f1'
      alias cat-ssh-cfg='sudo cat /etc/ssh/sshd_config'
      ## @description Alias for cat-ssh-cfg.
      alias ls-ssh-cfg='sudo cat /etc/ssh/sshd_config'
      ## @description Alias for cat-ssh-cfg.
      alias show-ssh-cfg='sudo cat /etc/ssh/sshd_config'
      ## @description Show the SSH systemd service unit file.
      alias cat-ssh-service='sudo cat /lib/systemd/system/ssh.service 2>/dev/null || echo "SSH service file not found"'
      ## @description Alias for cat-ssh-service.
      alias ls-ssh-service='sudo cat /lib/systemd/system/ssh.service 2>/dev/null || echo "SSH service file not found"'
      ## @description Alias for cat-ssh-service.
      alias show-ssh-service='sudo cat /lib/systemd/system/ssh.service 2>/dev/null || echo "SSH service file not found"'
      alias cat-sudoers='sudo cat /etc/sudoers'
      ## @description Alias for cat-sudoers.
      alias ls-sudoers='sudo cat /etc/sudoers'
      ## @description Alias for cat-sudoers.
      alias show-sudoers='sudo cat /etc/sudoers'
      _cat_sysctl_conf() {
        sudo find /etc/sysctl.d/ -type f -exec sh -c 'echo "=== $1 ==="; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-sysctl-conf='_cat_sysctl_conf'

      _cat_ssh_hosts() {
        sudo find /etc/ssh/ -name "ssh_host_*" -exec sh -c 'echo "=== $1 ==="; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-ssh-hosts='_cat_ssh_hosts'

      _cat_src_lists() {
        sudo find /etc/apt/sources.list.d/ -type f -exec sh -c 'echo "=== $1 ==="; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-src-lists='_cat_src_lists'

      _cat_users_verbose() {
        sudo awk -F: '{print $1 ":" $5}' /etc/passwd
      }
      alias cat-users-verbose='_cat_users_verbose'

      _cat_modeprobe_confs() {
        sudo find /etc/modprobe.d/ -type f -exec sh -c 'echo "=== $1 ==="; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-modeprobe-confs='_cat_modeprobe_confs'
#endregion System_Config_Files

    #region Logs_and_Crashes
      _stringify_crashes() {
        sudo find /var/crash/ -type f \
          -not -name "_opt_*.crash" \
          -not \( -name "_usr_bin_*.crash" -not -name "_usr_bin_blueman*.crash" \) \
          -exec sh -c 'strings "$1" 2>/dev/null; echo "=== file: $1 ==="; sleep 1' _ {} \;
      }
      alias stringify-crashes='_stringify_crashes'
      alias stringify-pkgcache='sudo strings /var/cache/apt/pkgcache.bin'
      alias stringify-srcpkgcache='sudo strings /var/cache/apt/srcpkgcache.bin'
      alias cat-var-locks='sudo ls /var/cache/apt/archives/lock'
      ## @description Alias for cat-var-locks.
      alias ls-var-locks='sudo ls /var/cache/apt/archives/lock'
      ## @description Alias for cat-var-locks.
      alias show-var-locks='sudo ls /var/cache/apt/archives/lock'
      alias cat-dpkg-log='sudo cat /var/log/dpkg.log'
      ## @description Alias for cat-dpkg-log.
      alias ls-dpkg-log='sudo cat /var/log/dpkg.log'
      ## @description Alias for cat-dpkg-log.
      alias show-dpkg-log='sudo cat /var/log/dpkg.log'
      alias cat-sys-log='sudo cat /var/log/syslog'
      ## @description Alias for cat-sys-log.
      alias ls-sys-log='sudo cat /var/log/syslog'
      ## @description Alias for cat-sys-log.
      alias show-sys-log='sudo cat /var/log/syslog'
      alias cat-history-log='sudo cat /var/log/apt/history.log'
      ## @description Alias for cat-history-log.
      alias ls-history-log='sudo cat /var/log/apt/history.log'
      ## @description Alias for cat-history-log.
      alias show-history-log='sudo cat /var/log/apt/history.log'
      alias cat-term-log='sudo cat /var/log/apt/term.log'
      ## @description Alias for cat-term-log.
      alias ls-term-log='sudo cat /var/log/apt/term.log'
      ## @description Alias for cat-term-log.
      alias show-term-log='sudo cat /var/log/apt/term.log'
      ## @description Extract strings from Xorg log files.
      stringify_xorg_logs() {
        sudo find /var/log/ -maxdepth 1 -name "Xorg*" -type f \
          -exec sh -c 'echo "=== $1 ==="; strings "$1" 2>/dev/null' _ {} \;
      }
      alias stringify-xorg-logs='stringify_xorg_logs'
      ## @description Show GPU/display/compositor errors from current boot journal.
      ## @param $1 {number} lines - Number of journal lines to scan (default: 200)
      journal_gpu_errors() {
        local n="${1:-200}"
        sudo journalctl -b -n "$n" --no-pager | \
          grep -i -E "(error|crash|gpu|display|render|compositor|window manager|fullscreen|xorg)"
      }
      alias journal-gpu-errors='journal_gpu_errors'
      ## @description Show GNOME Shell errors from user journal.
      ## @param $1 {number} lines - Number of journal lines to scan (default: 100)
      journal_gnome_errors() {
        local n="${1:-100}"
        journalctl --user -u gnome-shell -n "$n" --no-pager 2>/dev/null | \
          grep -i -E "(error|warning|fail|crash)"
      }
      alias journal-gnome-errors='journal_gnome_errors'
      ## @description List xsession error files and Xorg log directory.
      alias ls-xsession-errors='ls -lh ~/.xsession-errors* ~/.local/share/xorg/ 2>/dev/null'
      ## @description Grep Xorg log for errors (EE) and warnings (WW).
      alias grep-xorg-errors='grep -i -E "(EE|WW).*" ~/.local/share/xorg/Xorg.0.log 2>/dev/null'
      ## @description Extract crash-relevant strings from VS Code crash files.
      alias stringify-vscode-crash='sudo strings /var/crash/_usr_share_code_code.1000.crash 2>/dev/null | grep -i -E "(segfault|sigsegv|sigabrt|exception|display|render|gpu|compositor|fullscreen)"'
#endregion Logs_and_Crashes

    #region Applications_and_Icons
      ## @description Alias for cat-apps.
      alias ls-apps='sudo ls /usr/share/applications/'
      ## @description Alias for cat-apps-u.
      alias ls-apps-u='ls ~/.local/share/applications/'
      ## @description Alias for cat-icons.
      alias ls-icons='sudo ls /usr/share/icons/'
      ## @description Function for listing ALL icons in the system
      get_all_icons() {
        printf "\n[+] USER SPECIFIC ICONS\n"
        if [[ -d ~/.local/share/icons/ ]]; then
          find ~/.local/share/icons/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No user-specific icons found"
        fi
        sleep 2
        printf "\n[+] LEGACY USER SPECIFIC ICONS (if any)\n"
        if [[ -d ~/.icons/ ]]; then
          find ~/.icons/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No legacy user-specific icons found"
        fi
        sleep 2
        printf "\n[+] SYSTEM-WIDE ICONS\n"
        sudo -v
        if [[ -d /usr/share/icons/ ]]; then
          sudo find /usr/share/icons/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No system-wide icons found"
        fi
        sleep 2
        printf "\n[+] SYSTEM-WIDE SNAP-INSTALLED ICONS\n"
        if [[ -d /var/lib/snapd/desktop/icons/ ]]; then
          sudo find /var/lib/snapd/desktop/icons/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No system-wide snap-installed icons found"
        fi
        sleep 2
        printf "\n[+] SYSTEM-WIDE FLATPAK-INSTALLED ICONS\n"
        if [[ -d /var/lib/flatpak/exports/share/icons/ ]]; then
          sudo find /var/lib/flatpak/exports/share/icons/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No system-wide flatpak-installed icons found"
        fi
        sleep 2
        printf "\n[+] LEGACY SYSTEM-WIDE PIXMAPS\n"
        if [[ -d /usr/share/pixmaps/ ]]; then
          sudo find /usr/share/pixmaps/ -type f -exec sh -c 'echo "Filename: $(basename "$1")"; ls -lh "$1" 2>/dev/null' _ {} \;
        else
          echo "No legacy system-wide pixmaps found"
        fi
      }
      alias get-all-icons='get_all_icons'
      alias ls-all-icons='get_all_icons'
      alias stringify-sign-files='sudo strings "/usr/src/linux-headers-$(uname -r)/scripts/sign-file"'
      ## @description Find system/KDE/Plasma binaries in /usr/bin.
      find_system_kde_bins() {
        find /usr/bin -maxdepth 1 -type f -regextype posix-extended \
          -iregex '.*(system|kde|plasma).*' -print 2>/dev/null | sort
      }
      alias find-system-kde-bins='find_system_kde_bins'
      ## @description Search for a specific flag or option in a command's man page.
      ## @param $1 {string} cmd - Command name or "cmd subcmd" (default: ls)
      ## @param $2 {int} is_flag_or_option - 0 for flag (-), 1 for option (--) (default: 0)
      ## @param $3 {string} flag_or_option - Flag/option name to search for (default: l)
      man_fopt() {
          local cmd="${1:-ls}"
          local is_flag_or_option="${2:-0}"
          local flag_or_option="${3:-l}"
          if [[ "$is_flag_or_option" != "0" && "$is_flag_or_option" != "1" ]]; then
              echo "Error: Flag option must be 0 (flags, -) or 1 (options, --). Default is 0. Aborted." >&2
              return 1
          fi
          if [[ -z "$flag_or_option" ]]; then
              echo "Error: Flag/option name cannot be empty." >&2
              return 1
          fi
          if [[ -z "$cmd" ]]; then
              echo "Error: Command cannot be empty or not found." >&2
              return 1
          fi
          local man_page_found=false
          local man_target="$cmd"
          if [[ "$cmd" =~ [[:space:]] ]]; then
              local cmd_lead="${cmd%% *}"
              local cmd_trail="${cmd##* }"
              if man "$cmd_lead" "$cmd_trail" >/dev/null 2>&1; then
                  man_target="$cmd_lead $cmd_trail"
                  man_page_found=true
              elif man "${cmd// /-}" >/dev/null 2>&1; then
                  man_target="${cmd// /-}"
                  man_page_found=true
              elif man "$cmd_lead" >/dev/null 2>&1; then
                  echo "Warning: Subcommand man page not found, showing base command '$cmd_lead'" >&2
                  man_target="$cmd_lead"
                  man_page_found=true
              fi
          elif man "$cmd" >/dev/null 2>&1; then
              man_target="$cmd"
              man_page_found=true
          fi
          if [[ "$man_page_found" == false ]]; then
              echo "Error: No man page found for '$cmd'" >&2
              return 1
          fi
          local hyphens
          case "$is_flag_or_option" in
              0) hyphens='\-' ;;
              1) hyphens='\-\-' ;;
          esac
          man $man_target 2>/dev/null | grep -E "${hyphens}${flag_or_option}" || echo "No such flag or option found"
      }
      alias man-fopt='man_fopt'
      ## @description Extract printable strings from the current shell's own executable (/proc/self/exe).
      alias stringify-self='sudo strings /proc/self/exe 2>/dev/null || echo "No strings available for self"'
      ## @description List details of the current shell's executable symlink (/proc/self/exe).
      alias ls-self='sudo ls -lh /proc/self/exe 2>/dev/null || printf "[-] No self executable info available\n"'
#endregion Applications_and_Icons

    #region VSCode_and_GTK
      alias cat-gtk4-settings='sudo cat ~/.config/gtk-4.0/settings.ini'
      ## @description Alias for cat-gtk4-settings.
      alias ls-gtk4-settings='sudo cat ~/.config/gtk-4.0/settings.ini'
      ## @description Alias for cat-gtk4-settings.
      alias show-gtk4-settings='sudo cat ~/.config/gtk-4.0/settings.ini'
      alias cat-vscode-settings='sudo cat ~/.config/Code/User/settings.json'
      ## @description Alias for cat-vscode-settings.
      alias ls-vscode-settings='sudo cat ~/.config/Code/User/settings.json'
      ## @description Alias for cat-vscode-settings.
      alias show-vscode-settings='sudo cat ~/.config/Code/User/settings.json'
      alias cat-vscode-keybindings='sudo cat ~/.config/Code/User/keybindings.json'
      ## @description Alias for cat-vscode-keybindings.
      alias ls-vscode-keybindings='sudo cat ~/.config/Code/User/keybindings.json'
      ## @description Alias for cat-vscode-keybindings.
      alias show-vscode-keybindings='sudo cat ~/.config/Code/User/keybindings.json'
      alias cat-vscode-extensions='sudo cat ~/.config/Code/User/extensions.json'
      ## @description Alias for cat-vscode-extensions.
      alias ls-vscode-extensions='sudo cat ~/.config/Code/User/extensions.json'
      ## @description Alias for cat-vscode-extensions.
      alias show-vscode-extensions='sudo cat ~/.config/Code/User/extensions.json'
      alias cat-vscode-snippets='sudo cat ~/.config/Code/User/snippets/*'
      ## @description Alias for cat-vscode-snippets.
      alias ls-vscode-snippets='sudo cat ~/.config/Code/User/snippets/*'
      ## @description Alias for cat-vscode-snippets.
      alias show-vscode-snippets='sudo cat ~/.config/Code/User/snippets/*'
      alias cat-vscode-sqlite-state='sudo cat ~/.config/Code/User/globalStorage/state.vscdb'
      ## @description Alias for cat-vscode-sqlite-state.
      alias ls-vscode-sqlite-state='sudo cat ~/.config/Code/User/globalStorage/state.vscdb'
      ## @description Alias for cat-vscode-sqlite-state.
      alias show-vscode-sqlite-state='sudo cat ~/.config/Code/User/globalStorage/state.vscdb'
      alias stringify-vscode-logs='sudo find ~/.config/Code/logs -type f -exec strings {} \;'
      alias stringify-recent-xbel='sudo find ~/.local/share/recently-used.xbel -type f -exec strings {} \;'
      ## @description Extract strings from Copilot chat context files.
      stringify_copilot_context() {
        find ~/.config/Code/User/workspaceStorage/ -type f -name "content.txt" -exec sh -c 'echo "=== $(basename $(dirname "$1")) ==="; sleep 5; strings "$1" 2>/dev/null; echo "--------------------"; echo "#####END#####"; echo "--------------------"; echo ""; sleep 30;' _ {} \; 2>/dev/null
      }
      alias stringify-copilot-context='stringify_copilot_context'
      ## @description List unique workspaceStorage files (potentially containing chat context, logs, etc.).
      find_all_vscode_workspace_files() {
        find ~/.config/Code/User/workspaceStorage/ -type f | xargs -I{} basename {} | sort -u
      }
      alias find-all-vscode-workspace-files='find_all_vscode_workspace_files'
      ## @description Find VS Code GPU process log files.
      alias find-vscode-gpu-logs='find ~/.config/Code/logs/*/ -name "gpu-process.log" -o -name "gpuprocess.log" 2>/dev/null'
      ## @description Show GPU/render/display entries from VS Code shared process log.
      alias cat-vscode-sharedprocess-gpu='cat ~/.config/Code/logs/*/sharedprocess.log 2>/dev/null | grep -i -E "(gpu|render|display|error|warning)"'
      ## @description Alias for cat-vscode-sharedprocess-gpu.
      alias ls-vscode-sharedprocess-gpu='cat ~/.config/Code/logs/*/sharedprocess.log 2>/dev/null | grep -i -E "(gpu|render|display|error|warning)"'
      ## @description Alias for cat-vscode-sharedprocess-gpu.
      alias show-vscode-sharedprocess-gpu='cat ~/.config/Code/logs/*/sharedprocess.log 2>/dev/null | grep -i -E "(gpu|render|display|error|warning)"'
      ## @description Show VS Code argv.json (launch flags).
      alias cat-vscode-argv='cat ~/.config/Code/User/argv.json 2>/dev/null || echo "No argv.json found"'
      ## @description Alias for cat-vscode-argv.
      alias ls-vscode-argv='cat ~/.config/Code/User/argv.json 2>/dev/null || echo "No argv.json found"'
      ## @description Alias for cat-vscode-argv.
      alias show-vscode-argv='cat ~/.config/Code/User/argv.json 2>/dev/null || echo "No argv.json found"'
      ## @description Disable GPU in VS Code argv.json (with backup).
      vscode_disable_gpu() {
        local argv="$HOME/.config/Code/User/argv.json"
        if [ ! -f "$argv" ]; then
          echo "❌ argv.json not found at $argv"
          return 1
        fi
        echo -e "\033[1;33m⚠️  This will add disable-gpu flags to VS Code argv.json\033[0m"
        echo "  File: $argv"
        echo ""
        cat "$argv"
        echo ""
        read -rp "Proceed? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[yY] ]]; then
          echo "Aborted."
          return 0
        fi
        cp "$argv" "${argv}.bak.$(date +%Y%m%d%H%M%S)"
        # Use python3/jq to merge properly if available, otherwise sed
        if command -v python3 &>/dev/null; then
          python3 -c "
import json, sys
with open('$argv') as f:
    data = json.load(f)
data['disable-gpu'] = True
data['disable-gpu-compositing'] = True
with open('$argv','w') as f:
    json.dump(data, f, indent=4)
print('✅ GPU disabled in argv.json')
"
        else
          # Fallback: insert before closing brace
          sed -i 's/^}$/,\n  "disable-gpu": true,\n  "disable-gpu-compositing": true\n}/' "$argv"
          echo "✅ GPU disabled in argv.json (sed fallback)"
        fi
      }
      alias vscode-disable-gpu='vscode_disable_gpu'
#endregion VSCode_and_GTK
  #endregion System_Info_Aliases

  #region Pretty_Output_Helpers
    _pretty_hdr() {
      local title="$1"
      local w=62
      local line
      line=$(printf '═%.0s' $(seq 1 "$w"))
      echo ""
      echo -e "\033[1;36m╔${line}╗\033[0m"
      printf "\033[1;36m║\033[0m \033[1;33m%-${w}s\033[1;36m\033[0m\n" "$title"
      echo -e "\033[1;36m╚${line}╝\033[0m"
    }

    _pretty_ftr() {
      local w=64
      local line
      line=$(printf '─%.0s' $(seq 1 "$w"))
      echo -e "\033[2;37m${line}\033[0m"
      echo ""
    }

    _pretty_nl() {
      nl -ba -w5 -s ' │ ' | sed \
        -e "s/^\( *[0-9]*\)/$(printf '\033[0;37m')\1$(printf '\033[0m')/" \
        -e "s/\(#.*\)/$(printf '\033[0;32m')\1$(printf '\033[0m')/"
    }
  #endregion Pretty_Output_Helpers

  #region Pretty_Aliases
    #region Pretty_Kernel_OS
      cat-grub-boot-pretty() {
        _pretty_hdr "GRUB Boot Config — /boot/grub/grub.cfg"
        sudo cat /boot/grub/grub.cfg 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-grub-etc-pretty() {
        _pretty_hdr "GRUB Defaults — /etc/default/grub"
        sudo cat /etc/default/grub 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-k-os-pretty() {
        _pretty_hdr "Kernel OS Release"
        echo -e "  \033[1;32m►\033[0m $(sudo cat /proc/sys/kernel/osrelease 2>/dev/null)"
        _pretty_ftr
      }

      cat-etc-os-pretty() {
        _pretty_hdr "OS Release Info — /etc/os-release"
        sudo cat /etc/os-release 2>/dev/null | sed \
          -e "s/^\([A-Z_]*\)=/$(printf '\033[1;34m')\1$(printf '\033[0m')=/" | _pretty_nl
        _pretty_ftr
      }

      cat-os-v-pretty() {
        _pretty_hdr "Kernel Version — /proc/version"
        echo -e "  \033[1;32m►\033[0m $(sudo cat /proc/version 2>/dev/null)"
        _pretty_ftr
      }

      cat-linux-v-pretty() {
        _pretty_hdr "Linux Version — /proc/version"
        echo -e "  \033[1;32m►\033[0m $(sudo cat /proc/version 2>/dev/null)"
        _pretty_ftr
      }

      cat-k-host-pretty() {
        _pretty_hdr "Kernel Hostname"
        echo -e "  \033[1;35m⬢\033[0m $(sudo cat /proc/sys/kernel/hostname 2>/dev/null)"
        _pretty_ftr
      }

      cat-cmdline-pretty() {
        _pretty_hdr "Kernel Command Line — /proc/cmdline"
        sudo cat /proc/cmdline 2>/dev/null | tr ' ' '\n' | _pretty_nl
        _pretty_ftr
      }

    cat-mimeapps-pretty() {
      _pretty_hdr "Mimeapps Config List"
      cat-mimeapps | _pretty_nl
      _pretty_ftr
    }

    cat-share-mimeapps-pretty() {
      _pretty_hdr "Mimeapps Shared List"
      cat-share-mimeapps | _pretty_nl
      _pretty_ftr
    }

    cat-all-mimeapps-pretty() {
      _pretty_hdr "All Mimeapps Lists"
      cat-all-mimeapps | _pretty_nl
      _pretty_ftr
    }

    cat-share-mimecache-pretty() {
      _pretty_hdr "Mimeinfo Cache"
      cat-share-mimecache | _pretty_nl
      _pretty_ftr
    }
    #endregion Pretty_Kernel_OS

    #region Pretty_VM_Memory
      cat-vm-swap-pretty() {
        _pretty_hdr "VM Swappiness"
        local val
        val=$(sudo cat /proc/sys/vm/swappiness 2>/dev/null)
        echo -e "  \033[1;33mSwappiness:\033[0m $val"
        _pretty_ftr
      }

      cat-vm-over-mem-pretty() {
        _pretty_hdr "VM Overcommit Memory"
        local val
        val=$(sudo cat /proc/sys/vm/overcommit_memory 2>/dev/null)
        echo -e "  \033[1;33mOvercommit Mode:\033[0m $val  (0=heuristic 1=always 2=never)"
        _pretty_ftr
      }

      cat-vm-over-ratio-pretty() {
        _pretty_hdr "VM Overcommit Ratio"
        local val
        val=$(sudo cat /proc/sys/vm/overcommit_ratio 2>/dev/null)
        echo -e "  \033[1;33mOvercommit Ratio:\033[0m ${val}%%"
        _pretty_ftr
      }

      cat-cpu-inf-pretty() {
        _pretty_hdr "CPU Information — /proc/cpuinfo"
        sudo cat /proc/cpuinfo 2>/dev/null | sed \
          -e "s/^\([a-z_ ]*\)\t:/$(printf '\033[1;34m')\1$(printf '\033[0m')\t:/" | _pretty_nl
        _pretty_ftr
      }

      cat-mem-inf-pretty() {
        _pretty_hdr "Memory Information — /proc/meminfo"
        sudo cat /proc/meminfo 2>/dev/null | sed \
          -e "s/^\([A-Za-z_()]*\):/$(printf '\033[1;34m')\1$(printf '\033[0m'):/" | _pretty_nl
        _pretty_ftr
      }

      ## @description Pretty-print systemd OOM daemon configuration.
      cat-oom-conf-pretty() {
        _pretty_hdr "OOM Daemon Config — /etc/systemd/oomd.conf"
        sudo cat /etc/systemd/oomd.conf 2>/dev/null | _pretty_nl || echo "No OOM config file found"
        _pretty_ftr
      }

      ## @description Pretty-print vm.oom_kill_allocating_task sysctl value.
      show-oom-kill-alloc-pretty() {
        _pretty_hdr "OOM Kill Allocating Task"
        local val
        val=$(sudo sysctl vm.oom_kill_allocating_task 2>/dev/null)
        echo -e "  \033[1;33m${val}\033[0m  (0=kill random process 1=kill allocating task)"
        _pretty_ftr
      }

      ## @description Follow earlyoom daemon output with pretty header and a set interval.
      ## @param $1 {int} interval - Reporting interval in seconds (default: 2)
      follow_early_oom_pretty() {
        local interval="${1:-2}"
        _pretty_hdr "earlyoom — verbose reporting (interval: ${interval}s)"
        follow_early_oom_rec "$interval"
        _pretty_ftr
      }
      alias follow-early-oom-pretty='follow_early_oom_pretty'
      alias watch-early-oom-pretty='follow_early_oom_pretty'
      ## @description Watch memory-hungry processes sorted by RSS with pretty header.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch-mem-hogs-pretty() {
        local interval="${1:-0.25}"
        _pretty_hdr "Memory Hogs — top RSS consumers (interval: ${interval}s)"
        watch_mem_hogs "$interval"
        _pretty_ftr
      }

      ## @description Watch CPU-hungry processes sorted by CPU usage with pretty header.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch-cpu-hogs-pretty() {
        local interval="${1:-0.25}"
        _pretty_hdr "CPU Hogs — top CPU consumers (interval: ${interval}s)"
        watch_cpu_hogs "$interval"
        _pretty_ftr
      }

      ## @description List zombie processes with pretty header.
      ## @param $1 {int} head - Max number of results to display (default: 20)
      find-zombies-pretty() {
        local head="${1:-20}"
        _pretty_hdr "Zombie Processes (state Z)"
        find_zombies "$head" | _pretty_nl
        _pretty_ftr
      }

      ## @description Pretty-print OOM kill score for a process.
      ## @param $1 {int} pid - Process ID (required)
      cat-pid-oom-kill-score-pretty() {
        local pid="${1?"Usage: cat-pid-oom-kill-score-pretty <pid>"}"
        _pretty_hdr "OOM Kill Score — PID ${pid}"
        local val
        val=$(sudo cat /proc/"$pid"/oom_score 2>/dev/null)
        echo -e "  \033[1;33mOOM Score:\033[0m ${val:-N/A}  (higher = more likely to be killed)"
        _pretty_ftr
      }

      ## @description Pretty-print OOM adjustment score for a process.
      ## @param $1 {int} pid - Process ID (required)
      cat-pid-oom-adj-score-pretty() {
        local pid="${1?"Usage: cat-pid-oom-adj-score-pretty <pid>"}"
        _pretty_hdr "OOM Adjustment Score — PID ${pid}"
        local val
        val=$(sudo cat /proc/"$pid"/oom_score_adj 2>/dev/null)
        echo -e "  \033[1;33mOOM Score Adj:\033[0m ${val:-N/A}  (-1000=never kill  0=normal  1000=always kill)"
        _pretty_ftr
      }

      ## @description Pretty-print both OOM scores for a process.
      ## @param $1 {int} pid - Process ID (required)
      cat-pid-oom-scores-pretty() {
        local pid="${1?"Usage: cat-pid-oom-scores-pretty <pid>"}"
        _pretty_hdr "OOM Scores — PID ${pid}"
        local kill_score adj_score
        kill_score=$(sudo cat /proc/"$pid"/oom_score 2>/dev/null)
        adj_score=$(sudo cat /proc/"$pid"/oom_score_adj 2>/dev/null)
        echo -e "  \033[1;33mOOM Score:\033[0m     ${kill_score:-N/A}  (higher = more likely to be killed)"
        echo -e "  \033[1;33mOOM Score Adj:\033[0m ${adj_score:-N/A}  (-1000=never kill  0=normal  1000=always kill)"
        _pretty_ftr
      }

      ## @description Pretty-print earlyoom systemd journal.
      journal-earlyoom-pretty() {
        _pretty_hdr "earlyoom Journal — systemd"
        sudo journalctl -u earlyoom 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      ## @description Pretty-print systemd-oomd journal.
      journal-sysoomd-pretty() {
        _pretty_hdr "systemd-oomd Journal"
        sudo journalctl -u systemd-oomd 2>/dev/null | _pretty_nl
        _pretty_ftr
      }
    #endregion Pretty_VM_Memory

    #region Pretty_Storage
      cat-partitions-pretty() {
        _pretty_hdr "Partitions — /proc/partitions"
        sudo cat /proc/partitions 2>/dev/null | (
          read -r header; echo -e "\033[1;4m${header}\033[0m"
          cat
        ) | _pretty_nl
        _pretty_ftr
      }

      cat-fstab-pretty() {
        _pretty_hdr "Filesystem Table — /etc/fstab"
        sudo cat /etc/fstab 2>/dev/null | _pretty_nl
        _pretty_ftr
      }
    #endregion Pretty_Storage

    #region Pretty_Drivers_Modules
      cat-nvidia-v-pretty() {
        _pretty_hdr "NVIDIA Driver Version"
        sudo cat /proc/driver/nvidia/version 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      stringify-snapd-pretty() {
        _pretty_hdr "Snapd Strings — /lib/snapd/snapd"
        sudo strings /lib/snapd/snapd 2>/dev/null | head -200 | _pretty_nl
        echo -e "  \033[2;37m(showing first 200 lines — pipe to less for full output)\033[0m"
        _pretty_ftr
      }

      ls-sys-services-pretty() {
        _pretty_hdr "Systemd Services — /lib/systemd/system/"
        sudo ls /lib/systemd/system/ 2>/dev/null | column | sed \
          -e "s/\(.*\.service\)/$(printf '\033[0;32m')\1$(printf '\033[0m')/" \
          -e "s/\(.*\.timer\)/$(printf '\033[0;33m')\1$(printf '\033[0m')/" \
          -e "s/\(.*\.socket\)/$(printf '\033[0;35m')\1$(printf '\033[0m')/"
        _pretty_ftr
      }

      ls-mod-dkms-pretty() {
        _pretty_hdr "DKMS Modules — /lib/modules/$(uname -r)/updates/dkms/"
        sudo ls -lh "/lib/modules/$(uname -r)/updates/dkms/" 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-modeprobe-confs-pretty() {
        _pretty_hdr "Modprobe Configs — /etc/modprobe.d/"
        sudo find /etc/modprobe.d/ -type f -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          cat "$1" 2>/dev/null | nl -ba -w5 -s " │ "
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

      glx-info-pretty() {
        _pretty_hdr "OpenGL / GLX Information"
        if command -v glxinfo &>/dev/null; then
          glxinfo 2>/dev/null | grep -E "(OpenGL renderer|OpenGL version|direct rendering)" | \
            sed \
              -e "s/OpenGL renderer/$(printf '\033[1;32m')OpenGL renderer$(printf '\033[0m')/" \
              -e "s/OpenGL version/$(printf '\033[1;34m')OpenGL version$(printf '\033[0m')/" \
              -e "s/direct rendering: Yes/$(printf '\033[1;32m')direct rendering: Yes$(printf '\033[0m')/" \
              -e "s/direct rendering: No/$(printf '\033[1;31m')direct rendering: No$(printf '\033[0m')/" | \
            _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m glxinfo not available (install mesa-utils)"
        fi
        _pretty_ftr
      }
    #endregion Pretty_Drivers_Modules

    #region Pretty_System_Config
      cat-gdm3-conf-pretty() {
        _pretty_hdr "GDM3 Configuration — /etc/gdm3/custom.conf"
        sudo cat /etc/gdm3/custom.conf 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-hosts-pretty() {
        _pretty_hdr "Hosts File — /etc/hosts"
        sudo cat /etc/hosts 2>/dev/null | sed \
          -e "s/^\([0-9.]*\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" \
          -e "s/^\(::.*\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | _pretty_nl
        _pretty_ftr
      }

      cat-users-pretty() {
        _pretty_hdr "System Users — /etc/passwd"
        sudo cat /etc/passwd 2>/dev/null | cut -d: -f1 | sort | column | \
          sed "s/\b\(root\)\b/$(printf '\033[1;31m')root$(printf '\033[0m')/"
        _pretty_ftr
      }

      cat-users-verbose-pretty() {
        _pretty_hdr "Users (verbose) — /etc/passwd"
        sudo awk -F: '{printf "\033[1;34m%-20s\033[0m %s\n", $1, ($5 ? $5 : "(no description)")}' /etc/passwd 2>/dev/null
        _pretty_ftr
      }

      cat-ssh-cfg-pretty() {
        _pretty_hdr "SSH Server Config — /etc/ssh/sshd_config"
        sudo cat /etc/ssh/sshd_config 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-sudoers-pretty() {
        _pretty_hdr "Sudoers — /etc/sudoers"
        sudo cat /etc/sudoers 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-sysctl-conf-pretty() {
        _pretty_hdr "Sysctl Configs — /etc/sysctl.d/"
        sudo find /etc/sysctl.d/ -type f -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          cat "$1" 2>/dev/null | nl -ba -w5 -s " │ "
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

      cat-ssh-hosts-pretty() {
        _pretty_hdr "SSH Host Keys — /etc/ssh/ssh_host_*"
        sudo find /etc/ssh/ -name "ssh_host_*" -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          cat "$1" 2>/dev/null | nl -ba -w5 -s " │ "
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

      cat-src-lists-pretty() {
        _pretty_hdr "APT Source Lists — /etc/apt/sources.list.d/"
        sudo find /etc/apt/sources.list.d/ -type f -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          cat "$1" 2>/dev/null | nl -ba -w5 -s " │ "
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

    cat-compose-chars-pretty() {
      _pretty_hdr "X11 Compose Characters"
      cat-compose-chars | _pretty_nl
      _pretty_ftr
    }
    #endregion Pretty_System_Config

    #region Pretty_Logs
      stringify-crashes-pretty() {
        _pretty_hdr "Crash Files — /var/crash/"
        sudo find /var/crash/ -type f \
          -not -name "_opt_*.crash" \
          -not \( -name "_usr_bin_*.crash" -not -name "_usr_bin_blueman*.crash" \) \
          -exec sh -c '
            printf "\033[1;31m══ CRASH: %s ══\033[0m\n" "$1"
            strings "$1" 2>/dev/null | head -50
            echo -e "\033[2;37m  (first 50 lines shown)\033[0m"
            echo ""
          ' _ {} \;
        _pretty_ftr
      }

      stringify-pkgcache-pretty() {
        _pretty_hdr "Package Cache Strings — /var/cache/apt/pkgcache.bin"
        sudo strings /var/cache/apt/pkgcache.bin 2>/dev/null | head -200 | _pretty_nl
        echo -e "  \033[2;37m(showing first 200 lines)\033[0m"
        _pretty_ftr
      }

      stringify-srcpkgcache-pretty() {
        _pretty_hdr "Source Package Cache Strings"
        sudo strings /var/cache/apt/srcpkgcache.bin 2>/dev/null | head -200 | _pretty_nl
        echo -e "  \033[2;37m(showing first 200 lines)\033[0m"
        _pretty_ftr
      }

      cat-var-locks-pretty() {
        _pretty_hdr "APT Archive Locks — /var/cache/apt/archives/"
        sudo ls -lh /var/cache/apt/archives/lock 2>/dev/null | \
          sed "s/^\(.*\)/  \033[1;33m🔒\033[0m \1/"
        _pretty_ftr
      }

      cat-dpkg-log-pretty() {
        _pretty_hdr "DPKG Log — /var/log/dpkg.log (last 100)"
        sudo tail -100 /var/log/dpkg.log 2>/dev/null | sed \
          -e "s/ install /$(printf ' \033[1;32minstall\033[0m ')/" \
          -e "s/ remove /$(printf ' \033[1;31mremove\033[0m ')/" \
          -e "s/ upgrade /$(printf ' \033[1;33mupgrade\033[0m ')/" | _pretty_nl
        _pretty_ftr
      }

      cat-sys-log-pretty() {
        _pretty_hdr "System Log — /var/log/syslog (last 100)"
        sudo tail -100 /var/log/syslog 2>/dev/null | sed \
          -e "s/\(error\|Error\|ERROR\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/g" \
          -e "s/\(warning\|Warning\|WARN\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/g" | _pretty_nl
        _pretty_ftr
      }

      cat-history-log-pretty() {
        _pretty_hdr "APT History Log — /var/log/apt/history.log"
        sudo cat /var/log/apt/history.log 2>/dev/null | sed \
          -e "s/^\(Start-Date:\)/$(printf '\033[1;32m')\1$(printf '\033[0m')/" \
          -e "s/^\(End-Date:\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/" \
          -e "s/^\(Commandline:\)/$(printf '\033[1;34m')\1$(printf '\033[0m')/" | _pretty_nl
        _pretty_ftr
      }

      cat-term-log-pretty() {
        _pretty_hdr "APT Terminal Log — /var/log/apt/term.log"
        sudo cat /var/log/apt/term.log 2>/dev/null | tail -200 | _pretty_nl
        _pretty_ftr
      }

      stringify-xorg-logs-pretty() {
        _pretty_hdr "Xorg Log Strings — /var/log/Xorg*"
        sudo find /var/log/ -maxdepth 1 -name "Xorg*" -type f -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          strings "$1" 2>/dev/null | tail -40
          echo -e "\033[2;37m  (last 40 lines shown)\033[0m"
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

      journal-gpu-errors-pretty() {
        local n="${1:-200}"
        _pretty_hdr "GPU/Display Errors — journalctl (last $n lines)"
        sudo journalctl -b -n "$n" --no-pager 2>/dev/null | \
          grep -i -E "(error|crash|gpu|display|render|compositor|window manager|fullscreen|xorg)" | \
          sed \
            -e "s/\(error\|Error\|ERROR\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(crash\|Crash\|CRASH\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(gpu\|GPU\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/gi" | \
          _pretty_nl
        _pretty_ftr
      }

      journal-gnome-errors-pretty() {
        local n="${1:-100}"
        _pretty_hdr "GNOME Shell Errors — user journal (last $n lines)"
        journalctl --user -u gnome-shell -n "$n" --no-pager 2>/dev/null | \
          grep -i -E "(error|warning|fail|crash)" | \
          sed \
            -e "s/\(error\|fail\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(warning\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/gi" | \
          _pretty_nl
        _pretty_ftr
      }

      ls-xsession-errors-pretty() {
        _pretty_hdr "XSession Error Files"
        ls -lh ~/.xsession-errors* ~/.local/share/xorg/ 2>/dev/null | \
          sed "s/^\(.*\)/  \033[1;33m📄\033[0m \1/" | _pretty_nl
        _pretty_ftr
      }

      grep-xorg-errors-pretty() {
        _pretty_hdr "Xorg Errors & Warnings — Xorg.0.log"
        grep -i -E "(EE|WW).*" ~/.local/share/xorg/Xorg.0.log 2>/dev/null | \
          sed \
            -e "s/\(\(EE\)\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/g" \
            -e "s/\(\(WW\)\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/g" | \
          _pretty_nl
        _pretty_ftr
      }

      stringify-vscode-crash-pretty() {
        _pretty_hdr "VS Code Crash Analysis — /var/crash/"
        sudo strings /var/crash/_usr_share_code_code.1000.crash 2>/dev/null | \
          grep -i -E "(segfault|sigsegv|sigabrt|exception|display|render|gpu|compositor|fullscreen)" | \
          sed \
            -e "s/\(segfault\|sigsegv\|sigabrt\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(exception\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/gi" | \
          _pretty_nl
        _pretty_ftr
      }
    #endregion Pretty_Logs

    #region Pretty_Apps_Icons
      ls-apps-pretty() {
        _pretty_hdr "System Applications — /usr/share/applications/"
        sudo ls /usr/share/applications/ 2>/dev/null | \
          sed "s/\.desktop$/$(printf '\033[0;32m').desktop$(printf '\033[0m')/" | column
        _pretty_ftr
      }

      ls-apps-u-pretty() {
        _pretty_hdr "User Applications — ~/.local/share/applications/"
        ls ~/.local/share/applications/ 2>/dev/null | \
          sed "s/\.desktop$/$(printf '\033[0;32m').desktop$(printf '\033[0m')/" | column
        _pretty_ftr
      }

      ls-icons-pretty() {
        _pretty_hdr "Icon Themes — /usr/share/icons/"
        sudo ls /usr/share/icons/ 2>/dev/null | column
        _pretty_ftr
      }

      stringify-sign-files-pretty() {
        _pretty_hdr "Sign-File Strings — linux-headers sign-file"
        sudo strings "/usr/src/linux-headers-$(uname -r)/scripts/sign-file" 2>/dev/null | head -100 | _pretty_nl
        echo -e "  \033[2;37m(showing first 100 lines)\033[0m"
        _pretty_ftr
      }

      find-system-kde-bins-pretty() {
        _pretty_hdr "System/KDE/Plasma Binaries — /usr/bin"
        find /usr/bin -maxdepth 1 -type f -regextype posix-extended \
          -iregex '.*(system|kde|plasma).*' -print 2>/dev/null | sort | \
          sed \
            -e "s/\(.*plasma.*\)/$(printf '\033[1;34m')\1$(printf '\033[0m')/" \
            -e "s/\(.*kde.*\)/$(printf '\033[1;35m')\1$(printf '\033[0m')/" \
            -e "s/\(.*system.*\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | \
          _pretty_nl
        _pretty_ftr
      }

      man-fopt-pretty() {
        local cmd="${1:-ls}"
        local is_flag_or_option="${2:-0}"
        local flag_or_option="${3:-l}"
        _pretty_hdr "Man Page Flag/Option Search — $cmd ${is_flag_or_option:+$([ "$is_flag_or_option" = 1 ] && echo "--" || echo "-")}${flag_or_option}"
        man_fopt "$cmd" "$is_flag_or_option" "$flag_or_option" 2>&1 | _pretty_nl
        _pretty_ftr
      }

      stringify-self-pretty() {
        _pretty_hdr "Strings from /proc/self/exe"
        sudo strings /proc/self/exe 2>/dev/null | head -80 | _pretty_nl
        echo -e "  \033[2;37m(showing first 80 lines)\033[0m"
        _pretty_ftr
      }

      ls-self-pretty() {
        _pretty_hdr "Current Shell Executable — /proc/self/exe"
        sudo ls -lh /proc/self/exe 2>/dev/null | \
          sed "s/^\(.*\)/  \033[1;34m►\033[0m \1/" || \
          echo -e "  \033[1;31m✗\033[0m No self executable info available"
        _pretty_ftr
      }
    #endregion Pretty_Apps_Icons

    #region Pretty_VSCode_GTK
      cat-gtk4-settings-pretty() {
        _pretty_hdr "GTK4 Settings — ~/.config/gtk-4.0/settings.ini"
        cat ~/.config/gtk-4.0/settings.ini 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-vscode-settings-pretty() {
        _pretty_hdr "VS Code Settings — settings.json"
        cat ~/.config/Code/User/settings.json 2>/dev/null | \
          python3 -m json.tool 2>/dev/null | _pretty_nl || \
          cat ~/.config/Code/User/settings.json 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-vscode-keybindings-pretty() {
        _pretty_hdr "VS Code Keybindings — keybindings.json"
        cat ~/.config/Code/User/keybindings.json 2>/dev/null | \
          python3 -m json.tool 2>/dev/null | _pretty_nl || \
          cat ~/.config/Code/User/keybindings.json 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-vscode-extensions-pretty() {
        _pretty_hdr "VS Code Extensions — extensions.json"
        cat ~/.config/Code/User/extensions.json 2>/dev/null | \
          python3 -m json.tool 2>/dev/null | _pretty_nl || \
          cat ~/.config/Code/User/extensions.json 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      cat-vscode-snippets-pretty() {
        _pretty_hdr "VS Code Snippets"
        for f in ~/.config/Code/User/snippets/*; do
          [ -f "$f" ] || continue
          printf "\033[1;35m── %s ──\033[0m\n" "$(basename "$f")"
          cat "$f" 2>/dev/null | _pretty_nl
          echo ""
        done
        _pretty_ftr
      }

      cat-vscode-sqlite-state-pretty() {
        _pretty_hdr "VS Code State DB (binary preview)"
        sudo strings ~/.config/Code/User/globalStorage/state.vscdb 2>/dev/null | head -100 | _pretty_nl
        echo -e "  \033[2;37m(showing first 100 extracted strings)\033[0m"
        _pretty_ftr
      }

      stringify-vscode-logs-pretty() {
        _pretty_hdr "VS Code Logs"
        sudo find ~/.config/Code/logs -type f -exec sh -c '
          printf "\033[1;35m── %s ──\033[0m\n" "$1"
          strings "$1" 2>/dev/null | tail -20
          echo ""
        ' _ {} \;
        _pretty_ftr
      }

      stringify-recent-xbel-pretty() {
        _pretty_hdr "Recent Files — recently-used.xbel"
        strings ~/.local/share/recently-used.xbel 2>/dev/null | \
          grep -o 'href="[^"]*"' | \
          sed 's|href="file://||; s|"$||; s|%20| |g' | \
          _pretty_nl
        _pretty_ftr
      }

      stringify-copilot-context-pretty() {
        _pretty_hdr "Copilot Chat Context Files"
        find ~/.config/Code/User/workspaceStorage/*/Github.copilot-chat/chat-session-resources/*/*/ \
          -type f -name "context*" 2>/dev/null | while read -r f; do
          printf "\033[1;35m── %s ──\033[0m\n" "$f"
          strings "$f" 2>/dev/null | head -30 | _pretty_nl
          echo -e "  \033[2;37m(first 30 lines shown)\033[0m"
          echo ""
        done
        _pretty_ftr
      }

      find-vscode-gpu-logs-pretty() {
        _pretty_hdr "VS Code GPU Process Logs"
        find ~/.config/Code/logs/*/ -name "gpu-process.log" -o -name "gpuprocess.log" 2>/dev/null | \
          while read -r f; do
            printf "\033[1;35m── %s ──\033[0m\n" "$f"
            tail -20 "$f" 2>/dev/null | _pretty_nl
            echo ""
          done
        _pretty_ftr
      }

      cat-vscode-sharedprocess-gpu-pretty() {
        _pretty_hdr "VS Code Shared Process — GPU/Render entries"
        cat ~/.config/Code/logs/*/sharedprocess.log 2>/dev/null | \
          grep -i -E "(gpu|render|display|error|warning)" | \
          sed \
            -e "s/\(error\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(warning\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/gi" \
            -e "s/\(gpu\)/$(printf '\033[1;34m')\1$(printf '\033[0m')/gi" | \
          _pretty_nl
        _pretty_ftr
      }

      cat-vscode-argv-pretty() {
        _pretty_hdr "VS Code Launch Flags — argv.json"
        cat ~/.config/Code/User/argv.json 2>/dev/null | \
          python3 -m json.tool 2>/dev/null | _pretty_nl || \
          cat ~/.config/Code/User/argv.json 2>/dev/null | _pretty_nl || \
          echo -e "  \033[1;31m✗\033[0m No argv.json found"
        _pretty_ftr
      }
    #endregion Pretty_VSCode_GTK

    #region Pretty_Desktop_Environment
      ps-compositors-pretty() {
        _pretty_hdr "Running Compositors / Window Managers"
        ps aux | grep -E "(gnome-shell|xfwm4|mutter|kwin|compositor)" | grep -v grep | \
          awk '{printf "\033[1;32m%-12s\033[0m PID=\033[1;33m%-6s\033[0m %s\n", $11, $2, $0}' | \
          _pretty_nl
        _pretty_ftr
      }

      get-mutter-features-pretty() {
        _pretty_hdr "Mutter Experimental Features"
        local val
        val=$(gsettings get org.gnome.mutter experimental-features 2>/dev/null)
        if [ -n "$val" ]; then
          echo -e "  \033[1;33m⚙\033[0m  $val"
        else
          echo -e "  \033[1;31m✗\033[0m Mutter settings not available"
        fi
        _pretty_ftr
      }

      xwin-root-info-pretty() {
        _pretty_hdr "Root Window Geometry"
        xwininfo -root 2>/dev/null | grep -E "(Width|Height|Depth)" | \
          sed "s/^\(.*\)/  \033[1;36m🖥\033[0m \1/" | _pretty_nl
        _pretty_ftr
      }

      ls-monitors-pretty() {
        _pretty_hdr "Connected Monitors — xrandr"
        xrandr --listmonitors 2>/dev/null | \
          sed "s/^\( [0-9]:\)/$(printf '\033[1;32m')\1$(printf '\033[0m')/" | \
          _pretty_nl
        _pretty_ftr
      }

      check-de-programs-pretty() {
        _pretty_hdr "Desktop Environment Programs"
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
          if command -v "$prog" &>/dev/null; then
            printf "  \033[1;32m✓\033[0m \033[1m%-30s\033[0m %s\n" "$prog" "$(which "$prog")"
          else
            printf "  \033[1;31m✗\033[0m \033[2m%-30s\033[0m not found\n" "$prog"
          fi
        done
        _pretty_ftr
      }

      show-display-session-pretty() {
        _pretty_hdr "Display Session Type"
        echo -e "  \033[1;33m⬢\033[0m Session: \033[1;32m${XDG_SESSION_TYPE:-unknown}\033[0m"
        _pretty_ftr
      }

      show-desktop-session-pretty() {
        _pretty_hdr "Desktop Session"
        echo -e "  \033[1;33m⬢\033[0m Desktop: \033[1;32m${XDG_SESSION_DESKTOP:-unknown}\033[0m"
        _pretty_ftr
      }

      show-display-manager-pretty() {
        _pretty_hdr "Display Manager — systemd"
        systemctl show -p Id display-manager.service 2>/dev/null | \
          sed "s/^Id=/  \033[1;34mService:\033[0m /" | _pretty_nl
        _pretty_ftr
      }

      show-display-manager-x11-pretty() {
        _pretty_hdr "Display Manager — /etc/X11"
        local dm
        dm=$(sudo cat /etc/X11/default-display-manager 2>/dev/null)
        if [ -n "$dm" ]; then
          echo -e "  \033[1;34mBinary:\033[0m $dm"
        else
          echo -e "  \033[1;31m✗\033[0m File not found or empty"
        fi
        _pretty_ftr
      }

      show-current-de-pretty() {
        _pretty_hdr "Current Desktop Environment"
        echo -e "  \033[1;33m⬢\033[0m DE: \033[1;32m${XDG_CURRENT_DESKTOP:-unknown}\033[0m"
        _pretty_ftr
      }

      show-greeter-pretty() {
        _pretty_hdr "Display Manager Greeter"
        local dm
        dm=$(cat /etc/X11/default-display-manager 2>/dev/null | xargs basename)
        [[ -z "$dm" ]] && dm=$(systemctl status display-manager 2>/dev/null | grep -oP '(?<=Loaded: loaded \().*?(?=;)' | xargs basename)
        echo -e "  \033[1;34mDM detected:\033[0m \033[1;32m${dm:-unknown}\033[0m"
        echo ""
        case "$dm" in
          lightdm)
            echo -e "  \033[1;35m── LightDM Greeter Config ──\033[0m"
            grep -r "greeter-session" /etc/lightdm/ 2>/dev/null | grep -v "^#" | _pretty_nl
            ;;
          gdm3|gdm)
            echo -e "  \033[1;35m── GDM3 ──\033[0m  Greeter: GNOME Shell (built-in)"
            echo ""
            echo -e "  \033[1;35m── daemon.conf ──\033[0m"
            cat /etc/gdm3/daemon.conf 2>/dev/null | _pretty_nl
            echo ""
            echo -e "  \033[1;35m── custom.conf ──\033[0m"
            cat /etc/gdm3/custom.conf 2>/dev/null | _pretty_nl
            ;;
          sddm)
            echo -e "  \033[1;35m── SDDM Greeter Config ──\033[0m"
            grep -i "theme\|greeter" /etc/sddm.conf /etc/sddm.conf.d/*.conf 2>/dev/null | grep -v "^#" | _pretty_nl
            ;;
          lxdm)
            echo -e "  \033[1;35m── LXDM Greeter Config ──\033[0m"
            grep -i "theme\|greeter" /etc/lxdm/lxdm.conf 2>/dev/null | grep -v "^#" | _pretty_nl
            ;;
          xdm)
            echo -e "  \033[1;35m── XDM Config ──\033[0m"
            ls /etc/X11/xdm/ 2>/dev/null | _pretty_nl
            ;;
          slim)
            echo -e "  \033[1;35m── SLiM Greeter Config ──\033[0m"
            grep -i "theme\|greeter" /etc/slim.conf 2>/dev/null | grep -v "^#" | _pretty_nl
            ;;
          *)
            echo -e "  \033[1;31m✗\033[0m Unknown DM: '$dm' — try 'systemctl status display-manager'"
            ;;
        esac
        _pretty_ftr
      }

      cat-kde-settings-pretty() {
        _pretty_hdr "KDE Settings — SDDM"
        if sudo test -f /etc/sddm.conf.d/kde_settings.conf 2>/dev/null; then
          sudo cat /etc/sddm.conf.d/kde_settings.conf 2>/dev/null | sed \
            -e "s/^\(\[[^]]*\]\)/$(printf '\033[1;36m')\1$(printf '\033[0m')/" \
            -e "s/^\([A-Za-z_]*=\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m No KDE settings found"
        fi
        _pretty_ftr
      }

      cat-gdm3-conf-pretty() {
        _pretty_hdr "GDM3 Main Config — gdm3.conf"
        if sudo test -f /etc/gdm3/gdm3.conf 2>/dev/null; then
          sudo cat /etc/gdm3/gdm3.conf 2>/dev/null | sed \
            -e "s/^\(\[[^]]*\]\)/$(printf '\033[1;36m')\1$(printf '\033[0m')/" \
            -e "s/^\([A-Za-z_]*=\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m No GDM3 config found"
        fi
        _pretty_ftr
      }

      cat-gdm3-daemon-pretty() {
        _pretty_hdr "GDM3 Daemon Config — daemon.conf"
        if sudo test -f /etc/gdm3/daemon.conf 2>/dev/null; then
          sudo cat /etc/gdm3/daemon.conf 2>/dev/null | sed \
            -e "s/^\(\[[^]]*\]\)/$(printf '\033[1;36m')\1$(printf '\033[0m')/" \
            -e "s/^\([A-Za-z_]*=\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m No GDM3 daemon config found"
        fi
        _pretty_ftr
      }

      cat-gdm3-custom-pretty() {
        _pretty_hdr "GDM3 Custom Config — custom.conf"
        if sudo test -f /etc/gdm3/custom.conf 2>/dev/null; then
          sudo cat /etc/gdm3/custom.conf 2>/dev/null | sed \
            -e "s/^\(\[[^]]*\]\)/$(printf '\033[1;36m')\1$(printf '\033[0m')/" \
            -e "s/^\([A-Za-z_]*=\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/" | _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m No GDM3 custom config found"
        fi
        _pretty_ftr
      }

      show-win-mng-m-pretty() {
        _pretty_hdr "Window Manager Info — wmctrl"
        if ! command -v wmctrl &>/dev/null; then
          echo -e "  \033[1;33m⚠\033[0m  wmctrl not installed, attempting install..."
          sudo apt install -y wmctrl 2>/dev/null
        fi
        if command -v wmctrl &>/dev/null; then
          wmctrl -m 2>/dev/null | sed \
            -e "s/^\([A-Za-z ]*:\)/$(printf '\033[1;34m')\1$(printf '\033[0m')/" | _pretty_nl
        else
          echo -e "  \033[1;31m✗\033[0m wmctrl not available"
        fi
        _pretty_ftr
      }

      show-win-mng-pretty() {
        _pretty_hdr "Running Window Manager(s)"
        local WM_PATTERN='openbox|fluxbox|icewm|jwm|fvwm3|compiz|blackbox|metacity|mutter|kwin|xfwm4|afterstep|windowmaker|enlightenment|ctwm|9wm|aewm\+\+|amiwm|evilwm|flwm|lwm|marco|muffin|pekwm|ratpoison|subtle|twm|ukwm|windowlab|wm2|i3|awesome|bspwm|herbstluftwm|spectrwm|qtile|river|niri|dwm|xmonad|stumpwm|sawfish|wmii|notion|sway|weston|labwc|wayfire|hyprland|cage|phoc|cosmic-comp'
        local found
        found=$(ps aux | grep -E "$WM_PATTERN" | grep -v grep | awk '{print $11}' | xargs -I{} basename {} 2>/dev/null)
        if [ -n "$found" ]; then
          echo "$found" | while read -r wm; do
            echo -e "  \033[1;32m►\033[0m $wm"
          done
        else
          echo -e "  \033[1;31m✗\033[0m No known window manager detected"
        fi
        _pretty_ftr
      }

      show-screen-compositor-pretty() {
        _pretty_hdr "Running Screen Compositors"
        local found
        found=$(ps aux | grep -E "picom|compton|kwin|mutter|xfwm|wayfire" | grep -v grep)
        if [ -n "$found" ]; then
          echo "$found" | awk '{printf "  \033[1;32m►\033[0m PID=\033[1;33m%-6s\033[0m %s\n", $2, $11}'
        else
          echo -e "  \033[1;31m✗\033[0m No compositor detected"
        fi
        _pretty_ftr
      }

      show-screen-locker-pretty() {
        _pretty_hdr "Running Screen Lockers"
        local found
        found=$(ps aux | grep -E "xscreensaver|light-locker|swaylock|i3lock|gnome-screensaver" | grep -v grep)
        if [ -n "$found" ]; then
          echo "$found" | awk '{printf "  \033[1;32m►\033[0m PID=\033[1;33m%-6s\033[0m %s\n", $2, $11}'
        else
          echo -e "  \033[2;37m(no screen locker process detected)\033[0m"
        fi
        _pretty_ftr
      }

      show-installed-tks-pretty() {
        _pretty_hdr "Installed GUI Toolkit Libraries"
        dpkg -l 2>/dev/null | grep -E "libgtk|libqt" | grep -v dev | \
          awk '{printf "  \033[1;34m%-40s\033[0m \033[0;32m%s\033[0m\n", $2, $3}'
        _pretty_ftr
      }

      show-journal-screens-pretty() {
        _pretty_hdr "Journal Entries — Screen Recording & Desktop Portals"
        local tail_lines="${1:-50}"
        echo -e "  \033[1;36m📰 Desktop portals and PipeWire entries:\033[0m"
        journalctl --user -b 2>/dev/null | grep -iE 'pipewire|screencast|gnome-shell.*screencast|desktop-portal|mutter' | tail -n "$tail_lines" | _pretty_nl
        echo ""
        echo -e "  \033[1;36m🔍 Screencast-related entries:\033[0m"
        journalctl --user -b -u gnome-shell 2>/dev/null | grep -i screencast | tail -n "$tail_lines" | _pretty_nl
        echo ""
        echo -e "  \033[1;36m⚠️  Errors/warnings in gnome-shell:\033[0m"
        journalctl --user -u gnome-shell -n 100 --no-pager 2>/dev/null | grep -i -E "(screencast|error|warning|fail|crash)" | tail -n "$tail_lines" | \
          sed \
            -e "s/\(error\|fail\|crash\)/$(printf '\033[1;31m')\1$(printf '\033[0m')/gi" \
            -e "s/\(warning\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/gi" | _pretty_nl
        echo ""
        echo -e "  \033[1;36m👀 Active processes:\033[0m"
        ps aux | grep -iE 'pipewire|wireplumber|screencast|desktop-portal' | grep -v grep | \
          awk '{printf "  \033[1;32m►\033[0m PID=\033[1;33m%-6s\033[0m %s\n", $2, $11}'
        _pretty_ftr
      }
  
      dbus-asses-desktop-portal-pretty() {
        _pretty_hdr "D-Bus Desktop Portal Introspection"
        dbus-send --session --dest=org.freedesktop.portal.Desktop --type=method_call --print-reply /org/freedesktop/portal/desktop org.freedesktop.DBus.Introspectable.Introspect 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

      dbus-asses-xdg-desktop-portal-pretty() {
        _pretty_hdr "XDG Desktop Portal Color Scheme"
        dbus-send --print-reply=literal --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:"org.freedesktop.appearance" string:"color-scheme" 2>/dev/null | _pretty_nl
        _pretty_ftr
      }

  #endregion Pretty_Desktop_Environment

    #region Pretty_System_Setup
      show-all-env-vars-pretty() {
        _pretty_hdr "All Environment Variables (env)"
        env | grep -v '^$' | sort | _pretty_nl
        _pretty_ftr
      }

      show-all-printenv-vars-pretty() {
        _pretty_hdr "All Exported Variables (printenv)"
        printenv | grep -v '^$' | sort | _pretty_nl
        _pretty_ftr
      }

      show-all-sh-vars-pretty() {
        _pretty_hdr "All Shell Variables (set)"
        ( set -o posix; set ) | grep -v '^$' | sort | _pretty_nl
        _pretty_ftr
      }
    #endregion Pretty_System_Setup

    #region Pretty_System_Config
      cat-ssh-service-pretty() {
        _pretty_hdr "SSH Service Unit — /lib/systemd/system/ssh.service"
        sudo cat /lib/systemd/system/ssh.service 2>/dev/null | _pretty_nl \
          || echo -e "  \033[2;37m(SSH service file not found)\033[0m"
        _pretty_ftr
      }

    cat-compose-chars-pretty() {
      _pretty_hdr "X11 Compose Characters"
      cat-compose-chars | _pretty_nl
      _pretty_ftr
    }
    #endregion Pretty_System_Config

    #region Pretty_Basic_Commands
      gted-pretty() {
        _pretty_hdr "GNOME Text Editor"
        echo -e "  \033[1;32m►\033[0m Opening gnome-text-editor${1:+ for \033[1m$1\033[0m}…"
        gnome-text-editor "$@" &
        _pretty_ftr
      }

      uri-decode-pretty() {
        _pretty_hdr "URI Decode"
        local result
        result=$(printf '%b' "${1//%/\\x}")
        echo -e "  \033[1;34mInput:\033[0m  $1"
        echo -e "  \033[1;32mOutput:\033[0m $result"
        _pretty_ftr
      }

      printf-tr-pretty() {
        _pretty_hdr "Printf with TR Substitution"
        local result
        result=$(printftr "$@" 2>&1)
        local rc=$?
        if [[ $rc -eq 0 ]]; then
          echo -e "  \033[1;32mResult:\033[0m $result"
        else
          echo -e "  \033[1;31m✗ Error:\033[0m $result"
        fi
        _pretty_ftr
      }

      cat-indexed-pretty() {
        _pretty_hdr "Indexed File Listing"
        ls | nl -ba -w3 -s ' │ ' | sed \
          -e "s/^\( *[0-9]*\)/$(printf '\033[1;33m')\1$(printf '\033[0m')/"
        if [[ -n "${1:-}" ]]; then
          local file
          file=$(ls | sed -n "${1}p")
          if [[ -n "$file" ]]; then
            echo ""
            echo -e "  \033[1;36m► Contents of [$1] $file:\033[0m"
            strings "$file" 2>/dev/null | _pretty_nl
          fi
        fi
        _pretty_ftr
      }

      run-cmds-pretty() {
        _pretty_hdr "Run Multiple Commands"
        [ -z "$1" ] && { echo -e "  \033[1;31m✗ Error: target required\033[0m"; _pretty_ftr; return 1; }
        local target="$1"
        shift
        echo -e "  \033[1;34mTarget:\033[0m $target"
        echo ""
        for cmd in "$@"; do
          echo -e "  \033[1;33m► $cmd\033[0m"
          eval "$cmd \"$target\"" 2>/dev/null | _pretty_nl
          echo ""
        done
        _pretty_ftr
      }
    #endregion Pretty_Basic_Commands

    #region Pretty_HTML_CSS_Tools
      strip-html-comments-pretty() {
        _pretty_hdr "Strip HTML Comments & Prettier Format"
        local path="${1:?Usage: strip-html-comments-pretty <html_file>}"
        [[ -f "$path" ]] || { echo -e "  \033[1;31m✗ File not found:\033[0m $path"; _pretty_ftr; return 1; }
        local before after
        before=$(grep -c '<!--' "$path")
        strip_html_comments_format "$path"
        after=$(grep -c '<!--' "$path" 2>/dev/null || echo 0)
        echo ""
        echo -e "  \033[1;34mFile:\033[0m     $path"
        echo -e "  \033[1;33mBefore:\033[0m   $before comments"
        echo -e "  \033[1;32mAfter:\033[0m    $after comments"
        _pretty_ftr
      }

      extract-min-css-pretty() {
        _pretty_hdr "Extract & Minify CSS from HTML"
        local src="${1:?Usage: extract-min-css-pretty <html> <out.css> <out.min.css>}"
        local extract_src="${2:?}"
        local extract_min="${3:?}"
        extract_minify_css "$src" "$extract_src" "$extract_min"
        echo ""
        echo -e "  \033[1;34mSource:\033[0m    $src"
        echo -e "  \033[1;33mExtracted:\033[0m $extract_src ($(wc -c < "$extract_src" 2>/dev/null) bytes)"
        echo -e "  \033[1;32mMinified:\033[0m  $extract_min ($(wc -c < "$extract_min" 2>/dev/null) bytes)"
        _pretty_ftr
      }

      count-html-comments-pretty() {
        _pretty_hdr "HTML Comment & Line Count"
        local path="${1:?Usage: count-html-comments-pretty <html_file>}"
        [[ -f "$path" ]] || { echo -e "  \033[1;31m✗ File not found:\033[0m $path"; _pretty_ftr; return 1; }
        local comments lines
        comments=$(grep -c '<!--' "$path")
        lines=$(wc -l < "$path")
        echo -e "  \033[1;34mFile:\033[0m     $path"
        echo -e "  \033[1;33mComments:\033[0m $comments"
        echo -e "  \033[1;32mLines:\033[0m    $lines"
        _pretty_ftr
      }

      check-css-minifier-pretty() {
        _pretty_hdr "CSS Minifier Availability"
        local ver
        ver=$(npx csso --version 2>/dev/null)
        if [[ -n "$ver" ]]; then
          echo -e "  \033[1;32m✓\033[0m csso: $ver"
        else
          echo -e "  \033[1;31m✗\033[0m csso: not found"
        fi
        ver=$(npx clean-css-cli --version 2>/dev/null)
        if [[ -n "$ver" ]]; then
          echo -e "  \033[1;32m✓\033[0m clean-css-cli: $ver"
        else
          echo -e "  \033[1;31m✗\033[0m clean-css-cli: not found"
        fi
        _pretty_ftr
      }

      inject-min-css-pretty() {
        _pretty_hdr "Inject Minified CSS into HTML"
        local src="${1:?Usage: inject-min-css-pretty <html_file> <minified_css>}"
        local min_css="${2:?}"
        [[ -f "$src" ]] || { echo -e "  \033[1;31m✗ Source not found:\033[0m $src"; _pretty_ftr; return 1; }
        [[ -f "$min_css" ]] || { echo -e "  \033[1;31m✗ CSS not found:\033[0m $min_css"; _pretty_ftr; return 1; }
        local lines_before
        lines_before=$(wc -l < "$src")
        inject_minified_css "$src" "$min_css"
        local lines_after
        lines_after=$(wc -l < "$src")
        echo -e "  \033[1;34mHTML:\033[0m        $src"
        echo -e "  \033[1;33mCSS source:\033[0m  $min_css"
        echo -e "  \033[1;32mLines:\033[0m       $lines_before → $lines_after"
        _pretty_ftr
      }
    #endregion Pretty_HTML_CSS_Tools

    #region Pretty_Git
      git-tree-info-pretty() {
        _pretty_hdr "Git Work Tree Info"
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          echo -e "  \033[1;32m✓\033[0m Inside work tree"
          printf "  \033[1;34mGit dir:\033[0m          %s\n" "$(git rev-parse --git-dir)"
          printf "  \033[1;34mCommon dir:\033[0m       %s\n" "$(git rev-parse --git-common-dir)"
          printf "  \033[1;34mTop level:\033[0m        %s\n" "$(git rev-parse --show-toplevel)"
          printf "  \033[1;34mSuperproject:\033[0m     %s\n" "$(git rev-parse --show-superproject-working-tree 2>/dev/null | grep . || echo 'NOT A SUBMODULE')"
        else
          echo -e "  \033[1;31m✗\033[0m No work tree present for a repo"
        fi
        _pretty_ftr
      }
    #endregion Pretty_Git

      ## @description ls-*/show-* pretty aliases (point to cat-*-pretty).
      alias ls-all-mimeapps-pretty='cat-all-mimeapps-pretty'
      alias show-all-mimeapps-pretty='cat-all-mimeapps-pretty'
      alias ls-cmdline-pretty='cat-cmdline-pretty'
      alias show-cmdline-pretty='cat-cmdline-pretty'
      alias ls-compose-chars-pretty='cat-compose-chars-pretty'
      alias show-compose-chars-pretty='cat-compose-chars-pretty'
      alias ls-cpu-inf-pretty='cat-cpu-inf-pretty'
      alias show-cpu-inf-pretty='cat-cpu-inf-pretty'
      alias ls-dpkg-log-pretty='cat-dpkg-log-pretty'
      alias show-dpkg-log-pretty='cat-dpkg-log-pretty'
      alias ls-etc-os-pretty='cat-etc-os-pretty'
      alias show-etc-os-pretty='cat-etc-os-pretty'
      alias ls-fstab-pretty='cat-fstab-pretty'
      alias show-fstab-pretty='cat-fstab-pretty'
      alias ls-gdm3-conf-pretty='cat-gdm3-conf-pretty'
      alias show-gdm3-conf-pretty='cat-gdm3-conf-pretty'
      alias ls-gdm3-custom-pretty='cat-gdm3-custom-pretty'
      alias show-gdm3-custom-pretty='cat-gdm3-custom-pretty'
      alias ls-gdm3-daemon-pretty='cat-gdm3-daemon-pretty'
      alias show-gdm3-daemon-pretty='cat-gdm3-daemon-pretty'
      alias ls-grub-boot-pretty='cat-grub-boot-pretty'
      alias show-grub-boot-pretty='cat-grub-boot-pretty'
      alias ls-grub-etc-pretty='cat-grub-etc-pretty'
      alias show-grub-etc-pretty='cat-grub-etc-pretty'
      alias ls-gtk4-settings-pretty='cat-gtk4-settings-pretty'
      alias show-gtk4-settings-pretty='cat-gtk4-settings-pretty'
      alias ls-history-log-pretty='cat-history-log-pretty'
      alias show-history-log-pretty='cat-history-log-pretty'
      alias ls-hosts-pretty='cat-hosts-pretty'
      alias show-hosts-pretty='cat-hosts-pretty'
      alias ls-indexed-pretty='cat-indexed-pretty'
      alias show-indexed-pretty='cat-indexed-pretty'
      alias ls-k-host-pretty='cat-k-host-pretty'
      alias show-k-host-pretty='cat-k-host-pretty'
      alias ls-k-os-pretty='cat-k-os-pretty'
      alias show-k-os-pretty='cat-k-os-pretty'
      alias ls-kde-settings-pretty='cat-kde-settings-pretty'
      alias show-kde-settings-pretty='cat-kde-settings-pretty'
      alias ls-linux-v-pretty='cat-linux-v-pretty'
      alias show-linux-v-pretty='cat-linux-v-pretty'
      alias ls-mem-inf-pretty='cat-mem-inf-pretty'
      alias show-mem-inf-pretty='cat-mem-inf-pretty'
      alias ls-mimeapps-pretty='cat-mimeapps-pretty'
      alias show-mimeapps-pretty='cat-mimeapps-pretty'
      alias ls-modeprobe-confs-pretty='cat-modeprobe-confs-pretty'
      alias show-modeprobe-confs-pretty='cat-modeprobe-confs-pretty'
      alias ls-nvidia-v-pretty='cat-nvidia-v-pretty'
      alias show-nvidia-v-pretty='cat-nvidia-v-pretty'
      alias ls-oom-conf-pretty='cat-oom-conf-pretty'
      alias show-oom-conf-pretty='cat-oom-conf-pretty'
      alias ls-os-v-pretty='cat-os-v-pretty'
      alias show-os-v-pretty='cat-os-v-pretty'
      alias ls-partitions-pretty='cat-partitions-pretty'
      alias show-partitions-pretty='cat-partitions-pretty'
      alias ls-pid-oom-adj-score-pretty='cat-pid-oom-adj-score-pretty'
      alias show-pid-oom-adj-score-pretty='cat-pid-oom-adj-score-pretty'
      alias ls-pid-oom-kill-score-pretty='cat-pid-oom-kill-score-pretty'
      alias show-pid-oom-kill-score-pretty='cat-pid-oom-kill-score-pretty'
      alias ls-pid-oom-scores-pretty='cat-pid-oom-scores-pretty'
      alias show-pid-oom-scores-pretty='cat-pid-oom-scores-pretty'
      alias ls-share-mimeapps-pretty='cat-share-mimeapps-pretty'
      alias show-share-mimeapps-pretty='cat-share-mimeapps-pretty'
      alias ls-share-mimecache-pretty='cat-share-mimecache-pretty'
      alias show-share-mimecache-pretty='cat-share-mimecache-pretty'
      alias ls-src-lists-pretty='cat-src-lists-pretty'
      alias show-src-lists-pretty='cat-src-lists-pretty'
      alias ls-ssh-cfg-pretty='cat-ssh-cfg-pretty'
      alias show-ssh-cfg-pretty='cat-ssh-cfg-pretty'
      alias ls-ssh-hosts-pretty='cat-ssh-hosts-pretty'
      alias show-ssh-hosts-pretty='cat-ssh-hosts-pretty'
      alias ls-ssh-service-pretty='cat-ssh-service-pretty'
      alias show-ssh-service-pretty='cat-ssh-service-pretty'
      alias ls-sudoers-pretty='cat-sudoers-pretty'
      alias show-sudoers-pretty='cat-sudoers-pretty'
      alias ls-sys-log-pretty='cat-sys-log-pretty'
      alias show-sys-log-pretty='cat-sys-log-pretty'
      alias ls-sysctl-conf-pretty='cat-sysctl-conf-pretty'
      alias show-sysctl-conf-pretty='cat-sysctl-conf-pretty'
      alias ls-term-log-pretty='cat-term-log-pretty'
      alias show-term-log-pretty='cat-term-log-pretty'
      alias ls-users-pretty='cat-users-pretty'
      alias show-users-pretty='cat-users-pretty'
      alias ls-users-verbose-pretty='cat-users-verbose-pretty'
      alias show-users-verbose-pretty='cat-users-verbose-pretty'
      alias ls-var-locks-pretty='cat-var-locks-pretty'
      alias show-var-locks-pretty='cat-var-locks-pretty'
      alias ls-vm-over-mem-pretty='cat-vm-over-mem-pretty'
      alias show-vm-over-mem-pretty='cat-vm-over-mem-pretty'
      alias ls-vm-over-ratio-pretty='cat-vm-over-ratio-pretty'
      alias show-vm-over-ratio-pretty='cat-vm-over-ratio-pretty'
      alias ls-vm-swap-pretty='cat-vm-swap-pretty'
      alias show-vm-swap-pretty='cat-vm-swap-pretty'
      alias ls-vscode-argv-pretty='cat-vscode-argv-pretty'
      alias show-vscode-argv-pretty='cat-vscode-argv-pretty'
      alias ls-vscode-extensions-pretty='cat-vscode-extensions-pretty'
      alias show-vscode-extensions-pretty='cat-vscode-extensions-pretty'
      alias ls-vscode-keybindings-pretty='cat-vscode-keybindings-pretty'
      alias show-vscode-keybindings-pretty='cat-vscode-keybindings-pretty'
      alias ls-vscode-settings-pretty='cat-vscode-settings-pretty'
      alias show-vscode-settings-pretty='cat-vscode-settings-pretty'
      alias ls-vscode-sharedprocess-gpu-pretty='cat-vscode-sharedprocess-gpu-pretty'
      alias show-vscode-sharedprocess-gpu-pretty='cat-vscode-sharedprocess-gpu-pretty'
      alias ls-vscode-snippets-pretty='cat-vscode-snippets-pretty'
      alias show-vscode-snippets-pretty='cat-vscode-snippets-pretty'
      alias ls-vscode-sqlite-state-pretty='cat-vscode-sqlite-state-pretty'
      alias show-vscode-sqlite-state-pretty='cat-vscode-sqlite-state-pretty'

  #endregion Pretty_Aliases

  #region Utilities
    #region Package_Management
      alias prune-snap='sudo snap list --all | awk "/disabled/{print \$1, \$3}" | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done'
      ## @description Install Portuguese (pt) language packs (with confirmation).
      install_pt_lang_pack() {
        echo -e "\033[1;36m📦 This will install:\033[0m"
        echo "  • language-pack-pt"
        echo "  • language-pack-gnome-pt"
        read -rp "Proceed with installation? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[yY] ]]; then
          echo "Aborted."
          return 0
        fi
        sudo apt update -y && sudo apt install -y language-pack-pt language-pack-gnome-pt
      }
      alias install-pt-lang-pack='install_pt_lang_pack'
#endregion Package_Management

    #region Network_Monitoring
      ## BASED ON LUKE SMITH SCRIPT: https://www.youtube.com/watch?v=cvDyQUpaFf4
      cat_band() {
        init="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
        printf "Recording bandwidth.. Press enter to stop."
        read -r "stop"
        fin="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
        printf "%4sB of bandwith used.\\n" $(numfmt --to=iec $(($fin-$init)))
      }
      alias cat-band='cat_band'
#endregion Network_Monitoring

    #region Backup
      cleanup_before_sync() {
          local SRC="$1"
          local DST="$2"
          [ -d "$SRC" ] || { echo "Source not found: $SRC" >&2; return 1; }
          [ -d "$DST" ] || return 0
          local TRASH="${DST}/.trashed"
          mkdir -p "$TRASH"
          local tmpfile
          tmpfile=$(mktemp) || return 1
          local rsync_out deletions=()
          # Leading / anchors exclude to transfer root — only the top-level .trashed/
          rsync -ain --delete --out-format='%i %n' --exclude='/.trashed/' \
              "$SRC/" "$DST/" 2>/dev/null >"$tmpfile"
          local rsync_rc=$?
          # 23=partial transfer OK, 24=source files vanished OK
          if [ $rsync_rc -ne 0 ] && [ $rsync_rc -ne 23 ] && [ $rsync_rc -ne 24 ]; then
              rm -f "$tmpfile"
              echo "cleanup: rsync failed (exit $rsync_rc), aborting" >&2
              return 1
          fi
          mapfile -t rsync_out <"$tmpfile"
          rm -f "$tmpfile"
          local line relpath dst_item trash_item ts count=0
          declare -A moved_ancestors
          for line in "${rsync_out[@]}"; do
              [[ "$line" == \*deleting* ]] || continue
              relpath="${line#\*deleting }"
              relpath="${relpath%/}"
              [ -z "$relpath" ] && continue
              dst_item="$DST/$relpath"
              # Skip if we already moved an ancestor directory containing this item
              local ancestor="$relpath"
              while [[ "$ancestor" == */* ]]; do
                  ancestor="${ancestor%/*}"
                  [ -n "${moved_ancestors[$ancestor]:-}" ] && continue 2
              done
              [ -e "$dst_item" ] || continue
              trash_item="$TRASH/$relpath"
              mkdir -p "$(dirname "$trash_item")"
              if [ -e "$trash_item" ]; then
                  trash_item="${trash_item}.bak.$(date +%s%N)"
              fi
              mv "$dst_item" "$trash_item" && {
                  count=$((count + 1))
                  [ -d "$trash_item" ] && moved_ancestors[$relpath]=1
              }
          done
          [ "$count" -gt 0 ] && echo "cleanup: $count orphaned items moved to $TRASH"
          return 0
      }
      run_backup_projects() {
        local src="${1:?Usage: run_backup_projects <source_dir> <dest_dir>}"
        local dest="${2:?Usage: run_backup_projects <source_dir> <dest_dir>}"
        rsync -aHAXv --progress --checksum \
          --exclude={node_modules/,venv/,.venv/,__pycache__/,.gradle/,.m2/,vendor/,target/,.next/,dist/,build/,.docker/,docker/volumes/,docker/data/} \
          "$src" "$dest"
      }
      alias backup_projects='rsync -aHAXv --progress --checksum \
        --exclude={node_modules/,venv/,.venv/,__pycache__/,.gradle/,.m2/,vendor/,target/,.next/,dist/,build/,.docker/,docker/volumes/,docker/data/}'
      alias backup-projects='backup_projects'
      ## @description Forensic scan of a Chromium-based browser profile for download
      ## @description traces of a given file format. Runs every query class used during
      ## @description the May 15 music-recovery session: History DB (downloads table,
      ## @description downloads_url_chains, urls, visits, Cookies), per-site IndexedDB,
      ## @description Local/Session Storage strings dumps, and recently-used.xbel.
      ## @description Prints a categorized summary, optionally cross-checks against the
      ## @description filesystem with `find`, and optionally hands off to
      ## @description recover_chromium_yt_downloads_by_traces for re-download.
      ## @param $1 {string} format          - File extension to search for, e.g. mp3, webm, m4a (MANDATORY)
      ## @flag -b, --browser <name>         Chromium variant: brave (default), chromium, chrome, edge, vivaldi, opera
      ## @flag -p, --profile <name>         Profile directory name (default: Default)
      ## @flag -d, --days <N>               Lookback window in days (default: since browser install)
      ## @flag --filter-existing            After scan, run `find` to drop entries that already exist locally
      ## @flag --redownload                 If any traces look YouTube-shaped, prompt to call recover_chromium_yt_downloads_by_traces
      ## @flag --search-root <dir>          Root for the existing-file `find` (default: $HOME and /media)
      ## @flag -h, --help                   Show usage
      search_chromium_download_traces() {
        local format="" browser="brave" profile="Default" days="" filter_existing=0 redownload=0
        local -a search_roots=("$HOME" "/media" "/mnt")
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -b|--browser)         browser="$2"; shift 2 ;;
            -p|--profile)         profile="$2"; shift 2 ;;
            -d|--days)            days="$2"; shift 2 ;;
            --filter-existing)    filter_existing=1; shift ;;
            --redownload)         redownload=1; shift ;;
            --search-root)        search_roots=("$2"); shift 2 ;;
            -h|--help)
              echo -e "📖 \033[1msearch_chromium_download_traces\033[0m <format> [-b brave|chromium|chrome|edge|vivaldi|opera] [-p <profile>] [-d <days>] [--filter-existing] [--redownload]"
              return 0 ;;
            -*) echo -e "❌ Unknown flag: $1"; return 1 ;;
            *)  [ -z "$format" ] && format="$1" || { echo -e "❌ Unexpected arg: $1"; return 1; }; shift ;;
          esac
        done
        if [ -z "$format" ]; then
          echo -e "❌ Usage: search_chromium_download_traces <format> [...]"
          return 1
        fi
        format="${format#.}"

        # ---- browser → (config-dir, binary candidates) registry
        declare -A BROWSER_DIRS=(
          [brave]="$HOME/.config/BraveSoftware/Brave-Browser"
          [chromium]="$HOME/.config/chromium"
          [chrome]="$HOME/.config/google-chrome"
          [edge]="$HOME/.config/microsoft-edge"
          [vivaldi]="$HOME/.config/vivaldi"
          [opera]="$HOME/.config/opera"
        )
        declare -A BROWSER_BINS=(
          [brave]="brave brave-browser brave-browser-stable"
          [chromium]="chromium chromium-browser"
          [chrome]="google-chrome google-chrome-stable"
          [edge]="microsoft-edge microsoft-edge-stable"
          [vivaldi]="vivaldi vivaldi-stable"
          [opera]="opera"
        )
        _is_installed() {
          local key="$1" b
          for b in ${BROWSER_BINS[$key]}; do command -v "$b" >/dev/null 2>&1 && return 0; done
          [ -d "${BROWSER_DIRS[$key]}" ] && return 0
          return 1
        }
        echo -e "🔬 \033[1mPHASE 1\033[0m — Browser detection"
        echo -e "  Requested browser: \033[1m$browser\033[0m"
        echo -e "  Searching binaries: ${BROWSER_BINS[$browser]:-<none>}"
        echo -e "  Searching config dir: ${BROWSER_DIRS[$browser]:-<none>}"
        if ! _is_installed "$browser"; then
          echo -e "  ⚠️  \033[1;33m$browser is not installed.\033[0m"
          local -a avail=()
          for k in "${!BROWSER_DIRS[@]}"; do
            if _is_installed "$k"; then
              avail+=("$k")
              echo -e "    • $k found at ${BROWSER_DIRS[$k]}"
            fi
          done
          if [ "${#avail[@]}" -eq 0 ]; then
            echo -e "  ❌ No supported Chromium browser is installed."; return 1
          fi
          local pick
          read -rp "  Proceed with one of them? [name / n=cancel]: " pick
          if [[ " ${avail[*]} " =~ " $pick " ]]; then
            browser="$pick"
            echo -e "  ✅ Switched to: $browser"
          else
            echo -e "  ❌ Aborted."; return 1
          fi
        else
          echo -e "  ✅ Installed and config dir present."
        fi
        local cfg="${BROWSER_DIRS[$browser]}"
        local prof_dir="$cfg/$profile"
        echo -e "🔬 \033[1mPHASE 2\033[0m — Profile resolution"
        echo -e "  Profile name: \033[1m$profile\033[0m"
        echo -e "  Profile path: $prof_dir"
        if [ ! -d "$prof_dir" ]; then
          echo -e "  ❌ Profile not found."
          echo -n "  Available profiles: "; ls "$cfg" 2>/dev/null | grep -E "^(Default|Profile|Guest)" | tr '\n' ' '; echo
          return 1
        fi
        echo -e "  ✅ Profile directory readable."

        # ---- compute time window
        echo -e "🔬 \033[1mPHASE 3\033[0m — Time window resolution"
        local since_unix until_unix since_source
        until_unix=$(date +%s)
        if [ -n "$days" ]; then
          since_unix=$(( until_unix - days*86400 ))
          since_source="--days $days override"
        else
          since_unix=$(stat -c %Y "$cfg" 2>/dev/null || echo 0)
          since_source="mtime of $cfg (browser install/first-run proxy)"
        fi
        local since_chrome=$(( (since_unix + 11644473600) * 1000000 ))
        local until_chrome=$(( (until_unix + 11644473600) * 1000000 ))
        local since_iso=$(date -d "@$since_unix" '+%Y-%m-%d %H:%M:%S')
        local until_iso=$(date -d "@$until_unix" '+%Y-%m-%d %H:%M:%S')
        echo -e "  Since: $since_iso  ($since_source)"
        echo -e "  Until: $until_iso  (now)"
        echo -e "  Chrome epoch range: [$since_chrome, $until_chrome]"
        echo -e "  Format filter: \033[1m*.$format\033[0m"

        echo -e "🔍 \033[1;36mScanning $browser / $profile from $since_iso to $until_iso for *.$format\033[0m"
        local TMP
        TMP=$(mktemp -d)
        trap 'rm -rf "$TMP"' RETURN

        # =========================================================================
        # QUERY CLASS 1 — History.downloads (final filename, MIME, state, start_time)
        # =========================================================================
        echo -e "\n🔬 \033[1mPHASE 4 / Query 1\033[0m — History.downloads (Chromium download manager records)"
        echo -e "  Source: $prof_dir/History  (SQLite)"
        echo -e "  Tables: downloads JOIN downloads_url_chains"
        echo -e "  Filter: target_path LIKE '%.$format' AND start_time in window"
        cp -f "$prof_dir/History" "$TMP/h.db" 2>/dev/null \
          && echo -e "  ✅ DB copied (live DB is locked while browser is open; we work on a snapshot)" \
          || echo -e "  ⚠️  Could not copy History DB"
        local q1="
          SELECT datetime(d.start_time/1000000 - 11644473600,'unixepoch','localtime') AS ts,
                d.target_path, d.mime_type, d.state,
                (SELECT u.url FROM downloads_url_chains u WHERE u.id=d.id ORDER BY u.chain_index DESC LIMIT 1) AS final_url,
                (SELECT u.url FROM downloads_url_chains u WHERE u.id=d.id ORDER BY u.chain_index ASC LIMIT 1)  AS first_url,
                d.referrer, d.tab_url
          FROM downloads d
          WHERE d.start_time BETWEEN $since_chrome AND $until_chrome
            AND LOWER(d.target_path) LIKE '%.$format'
          ORDER BY d.start_time ASC;"
        local Q1_OUT="$TMP/q1.txt"; sqlite3 "$TMP/h.db" "$q1" > "$Q1_OUT" 2>/dev/null
        echo -e "  → $(grep -c . "$Q1_OUT" 2>/dev/null || echo 0) records"

        # =========================================================================
        # QUERY CLASS 2 — History.visits + History.urls (referrers to converter sites
        # and to YouTube searches that match the format we're after)
        # =========================================================================
        local converter_pat="orangemp3|ytmp3|y2mate|savefrom|freeconvert|cnvmp3|mp3juices|flvto|2conv|320ytmp3|320kbpsmp3"
        local q2="
          SELECT datetime(v.visit_time/1000000 - 11644473600,'unixepoch','localtime') AS ts, u.url, u.title
          FROM visits v JOIN urls u ON v.url=u.id
          WHERE v.visit_time BETWEEN $since_chrome AND $until_chrome
            AND (u.url REGEXP '$converter_pat' OR u.title LIKE '%$format%' OR u.url LIKE '%search_query%')
          ORDER BY ts;"
        echo -e "\n🔬 \033[1mQuery 2\033[0m — History.visits + History.urls (converter/search visits)"
        echo -e "  Tables: visits JOIN urls"
        echo -e "  Filter: url LIKE any-of {orangemp3, ytmp3, y2mate, savefrom, freeconvert, cnvmp3, mp3juices, flvto, search_query}"
        local Q2_OUT="$TMP/q2.txt"
        sqlite3 "$TMP/h.db" "SELECT load_extension('/usr/lib/sqlite3/pcre.so');" 2>/dev/null
        sqlite3 "$TMP/h.db" "
          SELECT datetime(v.visit_time/1000000 - 11644473600,'unixepoch','localtime') AS ts, u.url, u.title
          FROM visits v JOIN urls u ON v.url=u.id
          WHERE v.visit_time BETWEEN $since_chrome AND $until_chrome
            AND (u.url LIKE '%orangemp3%' OR u.url LIKE '%ytmp3%' OR u.url LIKE '%y2mate%'
              OR u.url LIKE '%savefrom%' OR u.url LIKE '%freeconvert%' OR u.url LIKE '%cnvmp3%'
              OR u.url LIKE '%mp3juices%' OR u.url LIKE '%flvto%' OR u.url LIKE '%search_query%')
          ORDER BY ts;" > "$Q2_OUT" 2>/dev/null
        echo -e "  → $(grep -c . "$Q2_OUT" 2>/dev/null || echo 0) records"

        # =========================================================================
        # QUERY CLASS 3 — Cookies for converter / YouTube hosts (presence == used)
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 3\033[0m — Cookies for converter/YouTube hosts (presence implies a visit)"
        echo -e "  Source: $prof_dir/Cookies  (SQLite)"
        local Q3_OUT="$TMP/q3.txt"
        if cp -f "$prof_dir/Cookies" "$TMP/c.db" 2>/dev/null; then
          echo -e "  ✅ Cookies DB copied"
          sqlite3 "$TMP/c.db" "
            SELECT host_key, name, datetime(creation_utc/1000000 - 11644473600,'unixepoch') AS created
            FROM cookies
            WHERE host_key LIKE '%orangemp3%' OR host_key LIKE '%ytmp3%' OR host_key LIKE '%y2mate%'
              OR host_key LIKE '%savefrom%' OR host_key LIKE '%freeconvert%' OR host_key LIKE '%cnvmp3%'
              OR host_key LIKE '%mp3juices%' OR host_key LIKE '%youtube%';" > "$Q3_OUT" 2>/dev/null
        else
          echo -e "  ⚠️  Could not copy Cookies DB"
        fi
        echo -e "  → $(grep -c . "$Q3_OUT" 2>/dev/null || echo 0) cookies"

        # =========================================================================
        # QUERY CLASS 4 — IndexedDB strings dump for per-site converters AND YouTube
        # (YouTube's playback telemetry stores docid + list + referrer, which is how
        # we forensically resolved which playlist items were actually watched.)
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 4\033[0m — IndexedDB (LevelDB) strings dump per site"
        echo -e "  Source dirs: $prof_dir/IndexedDB/*"
        echo -e "  Targeted hosts: youtube, orangemp3, ytmp3, y2mate, savefrom, freeconvert, cnvmp3"
        echo -e "  Extracting: docid/list/referrer pairs (YT watch telemetry), search_query strings"
        local Q4_OUT="$TMP/q4.txt"
        : > "$Q4_OUT"
        for site_dir in "$prof_dir/IndexedDB"/*; do
          [ -d "$site_dir" ] || continue
          local site
          site=$(basename "$site_dir")
          case "$site" in
            *youtube*|*orangemp3*|*ytmp3*|*y2mate*|*savefrom*|*freeconvert*|*cnvmp3*)
              echo -e "  • probing: $site"
              echo "### IndexedDB site: $site ###" >> "$Q4_OUT"
              strings -n 6 "$site_dir"/*.{ldb,log} 2>/dev/null \
                | grep -oE "docid=[A-Za-z0-9_-]+[^\"]*?(list=[A-Za-z0-9_-]+|referrer=[^&\"]+)" \
                | sort -u >> "$Q4_OUT"
              strings -n 6 "$site_dir"/*.{ldb,log} 2>/dev/null \
                | grep -oE "search_query%3D[^&\"]+" | sort -u >> "$Q4_OUT"
              ;;
          esac
        done
        echo -e "  → $(grep -cE "^docid=|^search_query" "$Q4_OUT" 2>/dev/null || echo 0) extracted refs"

        # =========================================================================
        # QUERY CLASS 5 — Local Storage / Session Storage strings dump for hosts
        # that the user clearly used. Catches cached track titles dropped by
        # converter front-ends that store recent jobs in localStorage.
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 5\033[0m — Local Storage / Session Storage strings dump"
        echo -e "  Source: $prof_dir/Local Storage/leveldb and $prof_dir/Session Storage"
        echo -e "  Heuristic filters: site keywords, .${format}, videoId, title, search_query"
        local Q5_OUT="$TMP/q5.txt"
        : > "$Q5_OUT"
        for stor_root in "$prof_dir/Local Storage/leveldb" "$prof_dir/Session Storage"; do
          [ -d "$stor_root" ] || continue
          echo -e "  • probing: $stor_root"
          echo "### $stor_root ###" >> "$Q5_OUT"
          strings -n 8 "$stor_root"/*.{ldb,log} 2>/dev/null \
            | grep -iE "orangemp3|ytmp3|youtube|\.${format}\b|search_query|videoId|title" \
            | sort -u | head -80 >> "$Q5_OUT"
        done
        echo -e "  → $(grep -cE "." "$Q5_OUT" 2>/dev/null || echo 0) suggestive strings"

        # =========================================================================
        # QUERY CLASS 6 — recently-used.xbel (GNOME's app-opened-files index).
        # Browser-independent but it caught files the browser registry missed.
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 6\033[0m — recently-used.xbel (GNOME app-opened-files registry)"
        echo -e "  Sources: $HOME/.local/share/recently-used.xbel*"
        echo -e "  Filter: href=\"file://...\\.${format}\""
        local Q6_OUT="$TMP/q6.txt"
        : > "$Q6_OUT"
        for xbel in "$HOME"/.local/share/recently-used.xbel*; do
          [ -f "$xbel" ] || continue
          echo -e "  • probing: $(basename "$xbel")"
          grep -oE "href=\"file://[^\"]+\.${format}\"" "$xbel" 2>/dev/null \
            | sed -E 's/^href="file:\/\///;s/"$//' \
            | python3 -c "import sys, urllib.parse; [print(urllib.parse.unquote(l), end='') for l in sys.stdin]" \
            >> "$Q6_OUT"
        done
        echo -e "  → $(grep -c . "$Q6_OUT" 2>/dev/null || echo 0) .${format} paths"

        echo -e "\n🔬 \033[1mPHASE 5\033[0m — Consolidating traces (tagged by origin)"
        # ---- consolidated trace list (just basenames + their sources)
        local TRACES="$TMP/traces.txt"
        : > "$TRACES"
        awk -F'|' 'NF>=2 && $2!="" {print "[downloads]\t" $2}' "$Q1_OUT" >> "$TRACES"
        awk -F'\t' '{print "[xbel]\t" $0}' "$Q6_OUT" >> "$TRACES"
        # YouTube docids → reconstruct URLs the recover function can pull
        grep -oE "docid=[A-Za-z0-9_-]+" "$Q4_OUT" | sort -u \
          | sed 's|^docid=|[yt-id]\thttps://www.youtube.com/watch?v=|' >> "$TRACES"
        local dl_n xb_n yt_n
        dl_n=$(grep -c "^\[downloads\]" "$TRACES" 2>/dev/null || echo 0)
        xb_n=$(grep -c "^\[xbel\]"      "$TRACES" 2>/dev/null || echo 0)
        yt_n=$(grep -c "^\[yt-id\]"     "$TRACES" 2>/dev/null || echo 0)
        echo -e "  [downloads]  $dl_n entries (file paths from History.downloads)"
        echo -e "  [xbel]       $xb_n entries (file paths from recently-used.xbel)"
        echo -e "  [yt-id]      $yt_n entries (reconstructable YT URLs from IndexedDB)"

        # =========================================================================
        # SUMMARY
        # =========================================================================
        echo -e "\n📊 \033[1;36mSummary\033[0m"
        printf "  %-32s %d hits\n" "downloads table (.${format})"   "$(grep -c . "$Q1_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "visits/urls (converter+search)" "$(grep -c . "$Q2_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "cookies (converter+YouTube)"    "$(grep -c . "$Q3_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "IndexedDB (docid/list/refer.)"  "$(grep -c . "$Q4_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "Local/Session Storage strings"  "$(grep -c . "$Q5_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "recently-used.xbel (.${format})" "$(grep -c . "$Q6_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d entries\n" "Consolidated traces"            "$(wc -l < "$TRACES")"

        # ---- export full payloads so a follow-up command can use them
        local OUT_DIR="${TMPDIR:-/tmp}/chromium-traces-$(date +%s)"
        mkdir -p "$OUT_DIR"
        cp "$Q1_OUT" "$OUT_DIR/01-downloads.txt"
        cp "$Q2_OUT" "$OUT_DIR/02-visits.txt"
        cp "$Q3_OUT" "$OUT_DIR/03-cookies.txt"
        cp "$Q4_OUT" "$OUT_DIR/04-indexeddb.txt"
        cp "$Q5_OUT" "$OUT_DIR/05-storage.txt"
        cp "$Q6_OUT" "$OUT_DIR/06-xbel.txt"
        cp "$TRACES" "$OUT_DIR/traces.tsv"
        echo -e "📁 Full dumps: \033[1m$OUT_DIR\033[0m"

        # =========================================================================
        # OPTIONAL: filter against filesystem with `find`
        # =========================================================================
        if [ "$filter_existing" -eq 0 ] && [ -t 0 ]; then
          local yn
          read -rp $'❓ Cross-check against filesystem (find for already-existing files)? [y/N]: ' yn
          [[ "$yn" =~ ^[Yy]$ ]] && filter_existing=1
        fi
        local MISSING="$OUT_DIR/missing.tsv"
        : > "$MISSING"
        if [ "$filter_existing" -eq 1 ]; then
          echo -e "\n🔬 \033[1mPHASE 6\033[0m — Filesystem cross-check via \`find\`"
          echo -e "  Search roots: ${search_roots[*]}"
          echo -e "  For each trace, matching basename against the filesystem."
          local n=0 total_traces; total_traces=$(wc -l < "$TRACES")
          while IFS=$'\t' read -r src target; do
            [ -z "$target" ] && continue
            n=$((n+1))
            local basename_only
            basename_only=$(basename "$target")
            local found=""
            for root in "${search_roots[@]}"; do
              [ -d "$root" ] || continue
              found=$(find "$root" -type f -name "$basename_only" -print -quit 2>/dev/null)
              [ -n "$found" ] && break
            done
            if [ -n "$found" ]; then
              echo -e "  [$n/$total_traces] \033[32m✓\033[0m $basename_only  →  $found"
            else
              echo -e "  [$n/$total_traces] \033[31m✗\033[0m $basename_only  (missing)"
              printf "%s\t%s\n" "$src" "$target" >> "$MISSING"
            fi
          done < "$TRACES"
          echo -e "❎ Missing: \033[1m$(wc -l < "$MISSING")\033[0m / $(wc -l < "$TRACES")"
          echo -e "📋 Missing list:"
          sed 's/^/  /' "$MISSING"
        fi

        # =========================================================================
        # OPTIONAL: hand off YouTube-shaped missing traces to the recover function
        # =========================================================================
        local -a yt_urls=()
        while IFS=$'\t' read -r src target; do
          [ "$src" = "[yt-id]" ] && yt_urls+=("$target")
        done < "${MISSING:-$TRACES}"
        if [ "$redownload" -eq 0 ] && [ "${#yt_urls[@]}" -gt 0 ] && [ -t 0 ]; then
          local yn
          read -rp $'❓ '"${#yt_urls[@]}"$' YouTube-shaped traces found. Redownload them? [y/N]: ' yn
          [[ "$yn" =~ ^[Yy]$ ]] && redownload=1
        fi
        if [ "$redownload" -eq 1 ] && [ "${#yt_urls[@]}" -gt 0 ]; then
          echo -e "\n🔬 \033[1mPHASE 7\033[0m — Destination prompt (3 retries max)"
          local dest="" tries=0
          while [ "$tries" -lt 3 ]; do
            read -rp "  📍 Destination directory: " dest
            echo -e "  Validating: '$dest'"
            if [ -d "$dest" ] && [ -w "$dest" ]; then
              echo -e "  ✅ Exists + writable"; break
            fi
            if [ -z "$dest" ]; then echo -e "  ❌ Empty path."; tries=$((tries+1)); continue; fi
            read -rp "  Path does not exist or is not writable. Create '$dest'? [y/N]: " yn
            if [[ "$yn" =~ ^[Yy]$ ]] && mkdir -p "$dest" 2>/dev/null; then
              echo -e "  ✅ Created"; break
            fi
            echo -e "  ⚠️  Try again ($((tries+1))/3)"
            tries=$((tries+1))
          done
          if [ ! -d "$dest" ] || [ ! -w "$dest" ]; then
            echo -e "❌ Failed to obtain a valid destination after 3 attempts."
            return 2
          fi
          echo -e "\n🔬 \033[1mPHASE 8\033[0m — Handing off to recover_chromium_yt_downloads_by_traces"
          echo -e "  → ${#yt_urls[@]} URL(s)  →  $dest"
          if declare -F recover_chromium_yt_downloads_by_traces >/dev/null; then
            recover_chromium_yt_downloads_by_traces "$dest" "${yt_urls[@]}"
          else
            echo -e "❌ recover_chromium_yt_downloads_by_traces is not defined."
            return 3
          fi
        fi
        echo -e "\n🏁 \033[1;32msearch_chromium_download_traces complete\033[0m"
        return 0
      }
      alias search-chromium-download-traces='search_chromium_download_traces'

      ## @description Re-download a list of YouTube URLs (or video IDs) into a target
      ## @description directory. Companion to search_chromium_download_traces — the
      ## @description body holds the actual yt-dlp invocation, browser cookies, node
      ## @description JS runtime, and the post-process / verify step.
      ## @param $1 {string} dest_dir  - Destination directory (required, must exist + writable)
      ## @param $@ {url...}           - One or more YouTube URLs or 11-char IDs
      ## @flag --browser <name>       Browser to extract cookies from (default: brave)
      ## @flag --format <ext>         Audio container (default: mp3)
      ## @flag --quality <0-9>        --audio-quality (default: 0 = best)
      ## @flag --no-thumb             Skip embed-thumbnail step
      recover_chromium_yt_downloads_by_traces() {
        local dest="" browser="brave" format="mp3" quality="0" thumb="--embed-thumbnail"
        local -a urls=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --browser)   browser="$2"; shift 2 ;;
            --format)    format="$2"; shift 2 ;;
            --quality)   quality="$2"; shift 2 ;;
            --no-thumb)  thumb=""; shift ;;
            -h|--help)
              echo -e "📖 \033[1mrecover_chromium_yt_downloads_by_traces\033[0m <dest_dir> <url|id> [<url|id>...]"
              return 0 ;;
            *)
              if [ -z "$dest" ]; then dest="$1"
              else urls+=("$1"); fi
              shift ;;
          esac
        done
        if [ -z "$dest" ] || [ "${#urls[@]}" -eq 0 ]; then
          echo -e "❌ Usage: recover_chromium_yt_downloads_by_traces <dest_dir> <url|id>..."
          return 1
        fi
        echo -e "🔬 \033[1mPHASE A\033[0m — Inputs validation"
        echo -e "  Destination: $dest"
        echo -e "  URLs queued: ${#urls[@]}"
        echo -e "  Browser cookies: $browser    Format: $format    Quality: $quality    Thumbs: ${thumb:-off}"
        [ ! -d "$dest" ] && { echo -e "❌ Destination not a dir: $dest"; return 1; }
        [ ! -w "$dest" ] && { echo -e "❌ Destination not writable: $dest"; return 1; }

        echo -e "🔬 \033[1mPHASE B\033[0m — Dependency check"
        command -v python3 >/dev/null && echo -e "  ✓ python3: $(command -v python3)" || { echo -e "❌ python3 required"; return 1; }
        python3 -c "import yt_dlp; import yt_dlp_ejs" 2>/dev/null \
          && echo -e "  ✓ yt_dlp + yt_dlp_ejs Python modules present" \
          || { echo -e "❌ Run: pip install --user --break-system-packages -U yt-dlp yt-dlp-ejs"; return 1; }
        command -v node >/dev/null && echo -e "  ✓ node: $(node --version 2>/dev/null)" \
          || echo -e "  ⚠️  node not found — YT JS challenges may fail."
        command -v ffmpeg >/dev/null && echo -e "  ✓ ffmpeg: $(ffmpeg -version 2>/dev/null | head -1)" \
          || { echo -e "❌ ffmpeg required for audio conversion"; return 1; }

        local LOG="/tmp/recover-chromium-yt-$(date +%Y%m%d-%H%M%S).log"
        echo -e "📜 Log file: $LOG"
        local -i ok=0 skipped=0 failed=0 total="${#urls[@]}" i=0
        echo -e "\n🎵 \033[1;36mPHASE C — Downloading $total URL(s) → $dest\033[0m"
        for u in "${urls[@]}"; do
          i=$((i+1))
          if [[ "$u" =~ ^[A-Za-z0-9_-]{11}$ ]]; then u="https://www.youtube.com/watch?v=$u"; fi
          echo -e "\n────────── [$i/$total] $u ──────────" | tee -a "$LOG"
          echo -e "  ⓘ Resolving title via yt-dlp --skip-download"
          local title
          title=$(python3 -m yt_dlp --no-js-runtimes --js-runtimes node \
                    --cookies-from-browser "$browser" --no-playlist --skip-download \
                    --print "%(title)s" "$u" 2>&1 | tee -a "$LOG" | tail -1)
          if [ -z "$title" ] || [[ "$title" == *"ERROR"* ]]; then
            echo -e "  ⚠️  Title not resolved — skipping"
            failed=$((failed+1)); continue
          fi
          local safe="${title//\//-}"; safe="${safe//$'\n'/ }"
          echo -e "  📝 Title:    $title"
          echo -e "  💾 Filename: $safe.$format"
          local out="$dest/$safe.$format"
          if [ -e "$out" ]; then
            echo -e "  ✋ Already exists — skip"
            skipped=$((skipped+1)); continue
          fi
          echo -e "  ⬇️  Invoking yt-dlp (bestaudio → $format @ q$quality)"
          if python3 -m yt_dlp --no-js-runtimes --js-runtimes node \
              --cookies-from-browser "$browser" \
              --no-playlist --retries 10 --fragment-retries 20 \
              --sleep-interval 2 --max-sleep-interval 5 \
              --extract-audio --audio-format "$format" --audio-quality "$quality" \
              $thumb --add-metadata --no-mtime \
              -f bestaudio \
              -o "$dest/$safe.%(ext)s" \
              "$u" 2>&1 | tee -a "$LOG" | grep -E "(\[download\] |\[ExtractAudio\]|\[EmbedThumbnail\]|ERROR|WARNING)" | sed 's/^/    /'; then
            if [ -f "$out" ]; then
              local dur
              dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$out" 2>/dev/null)
              echo -e "  ✅ Saved [$dur s]"
              ok=$((ok+1))
            else
              echo -e "  ❌ Expected output not found at $out"
              failed=$((failed+1))
            fi
          else
            echo -e "  ❌ yt-dlp exited non-zero"
            failed=$((failed+1))
          fi
        done
        echo -e "\n🏁 \033[1;32mPHASE D — Summary\033[0m"
        echo -e "  ✅ ok:      $ok"
        echo -e "  ✋ skipped: $skipped"
        echo -e "  ❌ failed:  $failed"
        echo -e "  📜 Log:     $LOG"
        [ "$failed" -gt 0 ] && return 2 || return 0
      }
      alias recover-chromium-yt-downloads-by-traces='recover_chromium_yt_downloads_by_traces'

#endregion Backup

    #region File_Analysis
      ## @description Show recently used files from XDG recent files database.
      ## @param $1 {string} search_term - Optional filter pattern (default: ".")
      show_recent_files() {
        local search_term="${1:-.}"
        strings ~/.local/share/recently-used.xbel 2>/dev/null | \
          grep -o 'href="[^"]*"' | \
          sed 's/href="file:\/\///' | \
          sed 's/"//' | \
          while read line; do 
            echo "${line//\%/\\x}"
          done | \
          xargs -0 printf "%b" 2>/dev/null | \
          grep -i "$search_term"
      }
      alias ls-rec-files='show_recent_files'
      ## @description Check if a file has multiple consecutive blank lines.
      ## @param $1 {string} file - File path to check (required)
      has_multiple_blank_lines() {
        local file="$1"
        if [ ! -f "$file" ]; then
          echo "File not found: $file" >&2
          return 1
        fi
        awk '/^[[:space:]]*$/ {blank++} !/^[[:space:]]*$/ {if(blank>=2) exit 0; blank=0} END{exit !(blank>=2)}' "$file" && \
          echo "File does have multiple blank lines" || echo "File does not have multiple blank lines"
      }
      alias is-mblank='has_multiple_blank_lines'
      ## @description List files in current directory that have multiple consecutive blank lines.
      show_multiple_blank_lines_files() {
        find . -maxdepth 1 -type f -exec awk '
          /^[[:space:]]*$/ { blank++ }
          !/^[[:space:]]*$/ { 
            if (blank >= 2) { 
              print FILENAME ": has multiple consecutive blank lines"
              exit 
            }
            blank = 0 
          }
          END { 
            if (blank >= 2) 
              print FILENAME ": has multiple consecutive blank lines" 
          }
        ' {} \;
      }
      alias ls-mblank='show_multiple_blank_lines_files'
      ## @description List files with name, path, and size.
      list_files_detail() {
        find . -type f -exec sh -c '
          for file do
            basename=$(basename "$file")
            size=$(stat -c "%s" "$file")
            printf "NAME: %s  |  PATH: %s  |  SIZE: %s\n\n" "$basename" "$file" "$size"
          done
        ' sh {} +
      }
      alias list-files='list_files_detail'
      ## @description Check which directories in current dir contain files.
      ## @flag -r  Recurse into subdirectories
      contains_files() {
        local recurse=0
        [[ "$1" == "-r" ]] && recurse=1
        if (( recurse )); then
          find . -type d -exec sh -c '[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]' {} \; -print
        else
          find . -maxdepth 1 -type d -exec sh -c '[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]' {} \; -print
        fi
      }
      alias contains-files='contains_files'
#endregion File_Analysis

    #region Hardware_Shortcuts
      alias check-ecc='sudo dmidecode -t memory | grep -i "error\|ecc\|correction"'
      alias btctl='bluetoothctl'
      alias stctl='systemctl'
      alias su-stctl='sudo systemctl'
      alias disconnect-all-bt='for device in $(bluetoothctl devices Connected | awk '"'"'{print $2}'"'"'); do bluetoothctl disconnect "$device"; done'
    #endregion Hardware_Shortcuts

    #region Basic_Commands
      ## @description Open GNOME Text Editor.
      alias gted='gnome-text-editor'
      ## @description Short alias for rhythmbox-client.
      alias rtb='rhythmbox-client'
      ## @description Shuffle the Rhythmbox play order N times by toggling shuffle
      ##              off and back on so each iteration forces a fresh random sequence.
      ## @param $1 {number} times - Number of reshuffle iterations (default: 5)
      rtb_multishuffle() {
        local times="${1:-5}"
        local colors=(
          "1;31" "1;32" "1;33" "1;34" "1;35" "1;36"
          "1;91" "1;92" "1;93" "1;94" "1;95" "1;96"
        )
        for i in $(seq 1 "$times"); do
          local color="${colors[RANDOM % ${#colors[@]}]}"
          printf "\033[%sm ↻ Shuffling Rhythmbox ↺ (iteration %d/%d)…\033[0m\n" \
            "$color" "$i" "$times"
          rhythmbox-client --no-shuffle
          sleep 0.2
          rhythmbox-client --shuffle
          sleep 0.5
        done
        rhythmbox-client --play
      }
      ## @description Alias for rtb_multishuffle.
      alias rtb-mshuffle='rtb_multishuffle'
      ## @description Print D-Bus introspection XML for the Rhythmbox MPRIS2 interface.
      alias ls-mpris-dbus-sender='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox /org/mpris/MediaPlayer2 org.freedesktop.DBus.Introspectable.Introspect'
      ## @description Alias for ls-mpris-dbus-sender.
      alias show-mpris-dbus-sender='ls-mpris-dbus-sender'
      ## @description Alias for ls-mpris-dbus-sender.
      alias get-mpris-dbus-sender='ls-mpris-dbus-sender'
      alias mkd='mkdir'
      alias grep='grep --color=auto'
      alias wget-ubuntu-iso='wget https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso'
      ## @description Decode a percent-encoded URI string (e.g. %20 -> space).
      ## @param $1 {string} uri - Percent-encoded string to decode (required)
      uri_decode() {
          printf '%b' "${1//%/\\x}"
      }
      alias uri-decode='uri_decode'
      ## @description Printf with field-width, delimiter, and tr-based substitution.
      ## @param $1 {string} delimiter - Fill character flag (-, 0, +, or empty)
      ## @param $2 {number} width     - Field width
      ## @param $3 {string} type      - Format type (%b or %s, default: %b)
      ## @param $4 {string} target    - String to format (required)
      ## @param $5 {string} pattern   - Pattern to replace in target (required)
      ## @param $6 {string} substitute - Replacement string (required)
      ## @param $7 {string} tr_from   - tr source character (optional)
      ## @param $8 {string} tr_to     - tr destination character (optional, default: space)
      printftr() {
        local delimiter="${1:-}"
        local width="${2:-}"
        local type="${3:-%b}"
        local target="${4:?No argument for capturing provided}"
        local pattern="${5:?No pattern to replace provided. Failed.}"
        local substitute="${6:?No replacer given. Failed.}"
        local tr_from="${7:-}"
        local tr_to="${8:- }"
        if [[ -n "$delimiter" && "$delimiter" != '-' && "$delimiter" != '0' && "$delimiter" != '+' ]]; then
          echo "Invalid delimiter! Acceptable values are -, 0, + or empty" >&2
          return 1
        fi
        if [[ "$type" != '%b' && "$type" != '%s' ]]; then
          echo "Invalid type for printf. Acceptable values: %b or %s" >&2
          return 1
        fi
        local fill_char
        case "$delimiter" in
          '0') fill_char='0' ;;
          '+') fill_char='+' ;;
          *)   fill_char=' ' ;;
        esac
        tr_from="${tr_from:-$fill_char}"
        printf "%${delimiter}${width}${type#%}" "${target//${pattern}/${substitute}}" | tr "$tr_from" "$tr_to"
      }
      alias printf-tr='printftr'
      ## @description List files with index numbers and display the contents of a file by index.
      ## @param $1 {number} index - 1-based index of the file to display (default: 1)
      cat_indexed() {
        local index="${1:-1}"
        (ls | nl) && file=$(ls | sed -n "${index}p") && output=$(strings "$file") && echo "${output:-"INDEXED HAS NO CONTENT"} 2>/dev/null" || echo "No file found at index $index"
      }
      alias cat-indexed='cat_indexed'
      ## @description Run multiple commands against a single target argument.
      ## @param $1 {string} target - The target argument for all commands (required)
      ## @param $@ {string} cmds   - Commands to run against the target
      run_cmds() {
        [ -z "$1" ] && { echo "Error: target required" >&2; return 1; }
        local target="$1"
        shift
        for cmd in "$@"; do 
            eval "$cmd \"$target\"" 2>/dev/null
        done
      }
      alias run-cmds='run_cmds'
      ## @description Custom ls output: time, size, name.
      ls_lah_859() {
        local path="${1:-.}"
        ls -lah "$path" | awk 'BEGIN{FS=" "}; {print $8, $5, $9}'
      }
      alias ls-lah-859='ls_lah_859'
      ## @description Count total lines in directory excluding vendor folders.
      wc_lines_novendors() {
        local files=0 total=0
        while IFS= read -r -d $'\0' file; do
          lines=$(wc -l < "$file")
          total=$((total+lines))
          files=$((files+1))
          printf "%s %d\n" "$file" "$total"
        done < <(find . -type f \
              ! -path '*/vendor/*' \
              ! -path '*/node_modules/*' \
              ! -path '*/.git/*' \
              -print0)
        echo "-> TOTAL: $total lines in $files files"
      }
      alias wc-l-novendors='wc_lines_novendors'
      ## @description List block devices that are not mounted.
      alias ls-nomount='sudo blkid -o list | grep "not mounted"'
      ## @description Mount NTFS drive with proper options and add to fstab.
      ## @param $1 {string} media_path - Mount destination path (required)
      ## @param $2 {string} device - Block device path (required)
      mount_ntfs_media_drive() {
        local media_path="$1"
        local device="$2"
        if [ -z "$media_path" ] || [ -z "$device" ]; then
          echo "Usage: mount-recover-ntfs '/media/user/Drive Name' /dev/sdX1"
          echo "Example: mount-recover-ntfs '/media/aronboliveira/Seagate Expansion Drive1' /dev/sdc1"
          return 1
        fi
        if [ ! -b "$device" ]; then
          echo "Error: Device $device does not exist"
          return 1
        fi
        sudo bash -c "
          set -e
          DEV='$device'
          M='$media_path'
          MPT=\$(findmnt -no TARGET \"\$DEV\" 2>/dev/null || true)
          [ -n \"\$MPT\" ] && umount \"\$MPT\" || true
          ntfsfix \"\$DEV\"
          mkdir -p \"\$M\"
          UUID=\$(blkid -s UUID -o value \"\$DEV\")
          M_ESC=\$(printf \"%s\" \"\$M\" | sed \"s/ /\\\\\\\\040/g\")
          LINE=\"UUID=\$UUID \$M_ESC ntfs uid=1000,gid=1000,dmask=022,fmask=133,windows_names,noatime,x-systemd.automount,nofail,x-systemd.device-timeout=5s 0 0\"
          sed -i.bak -e \"/UUID=\$UUID[[:space:]]/d\" -e \"\|[[:space:]]\$M_ESC[[:space:]]\|d\" /etc/fstab
          printf \"%s\\n\" \"\$LINE\" >> /etc/fstab
          systemctl daemon-reload
          mount -a
          ls \"\$M\" >/dev/null
          findmnt \"\$M\"
        "
      }
      alias mount-recover-ntfs='mount_ntfs_media_drive'

      # sda2 is plain ext4 — no LUKS unlock needed (use mount-sda2 directly)
      alias mount-sda2='\
          sudo mkdir -p /mnt/sda2; \
          sudo mount /dev/sda2 /mnt/sda2; \
          echo "Successfully mounted /dev/sda2 to /mnt/sda2";'

      ## @description Calculate Modulus N check digits for a numeric string (e.g. CPF mod-11, CNPJ).
      ## @param $1 {string} state - Digit string (e.g. "123456789")
      ## @param $2 {number} total - Modulus base (e.g. 11)
      calculate_check_sum() {
        local state="${1:?Usage: calculate_check_sum <digits> <modulus>}"
        local total="${2:?Usage: calculate_check_sum <digits> <modulus>}"
        if ! [[ "$state" =~ ^[0-9]+$ ]]; then
          echo "Error: state must be a numeric string." >&2
          return 1
        fi
        if ! [[ "$total" =~ ^[0-9]+$ ]] || (( total < 2 )); then
          echo "Error: total must be an integer >= 2." >&2
          return 1
        fi
        local state_len=${#state}
        local diff=$(( total - state_len ))
        if (( diff < 1 )); then
          echo "Error: total must be greater than the length of state." >&2
          return 1
        fi
        local pos
        for (( pos = 1; pos <= diff; pos++ )); do
          local cur_len=$(( state_len + pos - 1 ))
          local sr=0 i
          for (( i = 0; i < cur_len; i++ )); do
            local digit="${state:$i:1}"
            local weight=$(( state_len + pos - i ))
            sr=$(( sr + digit * weight ))
          done
          local rest=$(( sr % total ))
          local check_digit
          if (( rest < 2 )); then
            check_digit=0
          else
            check_digit=$(( total - rest ))
          fi
          state="${state}${check_digit}"
        done
        echo "$state"
      }
      alias calculate-check-sum='calculate_check_sum'
      alias calc-checksum='calculate_check_sum'
      ## @description Change directory up N levels using dots or .{N}.
      ## @param $1 {string} dots - Dot pattern (e.g., ... or .{3})
      cdup() {
        if [[ $# -ne 1 ]]; then
          echo "Usage: cdup .... | cdup .{N}" >&2
          return 1
        fi
        local arg="$1"
        local n=""
        if [[ "$arg" =~ ^\.+$ ]]; then
          n=${#arg}
        elif [[ "$arg" =~ ^\.\{([0-9]+)\}$ ]]; then
          n="${BASH_REMATCH[1]}"
        else
          echo "Usage: cdup .... | cdup .{N}" >&2
          return 1
        fi
        if (( n < 1 )); then
          echo "Error: N must be >= 1" >&2
          return 1
        fi
        local path=""
        local i
        for (( i = 0; i < n; i++ )); do
          path+="../"
        done
        path="${path%/}"
        cd "$path" || return
      }
        ## @description Find common web image formats in a directory (png/jpg/gif/svg/webp/etc).
        ## @param $1 {string} path - Directory to search (default: .)
        ## @param $@ {string[]} extra - Additional find arguments
        find_web_images() {
          local path="${1:-.}"
          if [[ ! -d "$path" ]]; then
          echo "Error: $path is not a directory" >&2
          return 1
          fi
          find "$path" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
                    -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
                    -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
                    -name "*.tiff" -o -name "*.tif" \) "${@:2}"
        }
        ## @description Alias for find-web-images.
        alias ls-web-images='find_web_images'
        ## @description Alias for find-web-images.
        alias show-web-images='find_web_images'
        ## @description Find a broad set of image formats (web + RAW + design files).
        ## @param $1 {string} path - Directory to search (default: .)
        ## @param $@ {string[]} extra - Additional find arguments
        find_all_images() {
          local path="${1:-.}"
          if [[ ! -d "$path" ]]; then
          echo "Error: $path is not a directory" >&2
          return 1
          fi
          find "$path" -type f \( \
            -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
            -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
            -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
            -name "*.tiff" -o -name "*.tif" -o -name "*.jfif" -o \
            -name "*.jpe" -o -name "*.jif" -o -name "*.jp2" -o \
            -name "*.j2k" -o -name "*.jpf" -o -name "*.jpx" -o \
            -name "*.jpm" -o -name "*.mj2" -o -name "*.cr2" -o \
            -name "*.cr3" -o -name "*.nef" -o -name "*.nrw" -o \
            -name "*.arw" -o -name "*.srf" -o -name "*.sr2" -o \
            -name "*.orf" -o -name "*.rw2" -o -name "*.pef" -o \
            -name "*.ptx" -o -name "*.raf" -o -name "*.3fr" -o \
            -name "*.fff" -o -name "*.dcr" -o -name "*.dng" -o \
            -name "*.mrw" -o -name "*.iiq" -o -name "*.kdc" -o \
            -name "*.mos" -o -name "*.erf" -o -name "*.bay" -o \
            -name "*.psd" -o -name "*.psb" -o -name "*.ai" -o \
            -name "*.eps" -o -name "*.indd" -o -name "*.xcf" -o \
            -name "*.cdr" -o -name "*.heic" -o -name "*.heif" -o \
            -name "*.jxr" -o -name "*.jxl" \
          \) "${@:2}"
        }
        ## @description Alias for find-all-images.
        alias ls-all-images='find_all_images'
        ## @description Alias for find-all-images.
        alias show-all-images='find_all_images'
        ## @description Parse common find options for deep image search helpers.
        parse_find_options() {
          local path="."
          local max_depth=""
          local min_depth="0"
          local args=()
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --path|-p)
                path="$2"
                shift 2
                ;;
              --max-depth|-M)
                max_depth="$2"
                shift 2
                ;;
              --min-depth|-m)
                min_depth="$2"
                shift 2
                ;;
              --help|-h)
                echo "Usage: ${FUNCNAME[1]} [OPTIONS] [-- extra find args]"
                echo "Options:"
                echo "  --path, -p DIR     Directory to search (default: .)"
                echo "  --max-depth, -M N  Maximum depth (default: no limit)"
                echo "  --min-depth, -m N  Minimum depth (default: 0)"
                echo "  --help, -h         Show this help"
                echo "All remaining arguments are passed directly to find."
                return 1
                ;;
              --)
                shift
                args+=("$@")
                break
                ;;
              -*)
                args+=("$@")
                break
                ;;
              *)
                if [[ "$path" == "." ]]; then
                  path="$1"
                  shift
                else
                  args+=("$@")
                  break
                fi
                ;;
            esac
          done
          if [[ ! -d "$path" ]]; then
            echo "Error: '$path' is not a directory" >&2
            return 1
          fi
          FIND_OPTS_PATH="$path"
          FIND_OPTS_MIN="$min_depth"
          FIND_OPTS_MAX="$max_depth"
          FIND_OPTS_ARGS=("${args[@]}")
          return 0
        }
        ## @description Find common web image formats with depth controls.
        find_web_images_deep() {
          parse_find_options "$@" || return 1
          local cmd=(find "$FIND_OPTS_PATH" -type f)
          if [[ -n "$FIND_OPTS_MIN" && "$FIND_OPTS_MIN" != "0" ]]; then
          cmd+=( -mindepth "$FIND_OPTS_MIN" )
          fi
          if [[ -n "$FIND_OPTS_MAX" ]]; then
          cmd+=( -maxdepth "$FIND_OPTS_MAX" )
          fi
          cmd+=( \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
                -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
                -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
                -name "*.tiff" -o -name "*.tif" \) )
          cmd+=( "${FIND_OPTS_ARGS[@]}" )
          "${cmd[@]}"
        }
        ## @description Alias for find-web-images-deep.
        alias ls-web-images-deep='find_web_images_deep'
        ## @description Alias for find-web-images-deep.
        alias show-web-images-deep='find_web_images_deep'
        ## @description Find a broad set of image formats with depth controls.
        find_all_images_deep() {
          parse_find_options "$@" || return 1
          local cmd=(find "$FIND_OPTS_PATH" -type f)
          if [[ -n "$FIND_OPTS_MIN" && "$FIND_OPTS_MIN" != "0" ]]; then
          cmd+=( -mindepth "$FIND_OPTS_MIN" )
          fi
          if [[ -n "$FIND_OPTS_MAX" ]]; then
          cmd+=( -maxdepth "$FIND_OPTS_MAX" )
          fi
          cmd+=( \( \
            -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
            -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
            -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
            -name "*.tiff" -o -name "*.tif" -o -name "*.jfif" -o \
            -name "*.jpe" -o -name "*.jif" -o -name "*.jp2" -o \
            -name "*.j2k" -o -name "*.jpf" -o -name "*.jpx" -o \
            -name "*.jpm" -o -name "*.mj2" -o -name "*.cr2" -o \
            -name "*.cr3" -o -name "*.nef" -o -name "*.nrw" -o \
            -name "*.arw" -o -name "*.srf" -o -name "*.sr2" -o \
            -name "*.orf" -o -name "*.rw2" -o -name "*.pef" -o \
            -name "*.ptx" -o -name "*.raf" -o -name "*.3fr" -o \
            -name "*.fff" -o -name "*.dcr" -o -name "*.dng" -o \
            -name "*.mrw" -o -name "*.iiq" -o -name "*.kdc" -o \
            -name "*.mos" -o -name "*.erf" -o -name "*.bay" -o \
            -name "*.psd" -o -name "*.psb" -o -name "*.ai" -o \
            -name "*.eps" -o -name "*.indd" -o -name "*.xcf" -o \
            -name "*.cdr" -o -name "*.heic" -o -name "*.heif" -o \
            -name "*.jxr" -o -name "*.jxl" \
          \) )
          cmd+=( "${FIND_OPTS_ARGS[@]}" )
          "${cmd[@]}"
        }
        ## @description Alias for find-all-images-deep.
        alias ls-all-images-deep='find_all_images_deep'
        ## @description Alias for find-all-images-deep.
        alias show-all-images-deep='find_all_images_deep'
#endregion Basic_Commands
  #endregion Utilities

  #region Git_Aliases
    alias git-log-pretty='git log --all --pretty=format:"%ae - %cd - %s" --date=short'
    alias git-stats='\
        AUTHOR="${1:-$(git config user.email)}"; \
        echo "Author email: $AUTHOR"; \
        echo ""; \
        git log --author="$AUTHOR" --pretty=tformat: --numstat 2>/dev/null | \
        awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { \
            printf "Lines added: %s\nLines removed: %s\nNet lines (changed): %s\n", add, subs, loc \
        }'\''; \
        echo ""; \
        echo "Total number of lines in the project (ignoring vendors):"; \
        find . -type f \
            ! -path '\''*/vendor/*'\'' \
            ! -path '\''*/node_modules/*'\'' \
            ! -path '\''*/.git/*'\'' \
            ! -path '\''*/dist/*'\'' \
            ! -path '\''*/build/*'\'' \
            ! -path '\''*/./*'\'' \
            -exec wc -l {} + 2>/dev/null | tail -1 | awk '\''{print $1}'\''; \
        echo "Total number of files in the project (ignoring vendors):"; \
        find . -type f \
            ! -path '\''*/vendor/*'\'' \
            ! -path '\''*/node_modules/*'\'' \
            ! -path '\''*/.git/*'\'' \
            ! -path '\''*/dist/*'\'' \
            ! -path '\''*/build/*'\'' \
            ! -path '\''*/./*'\'' \
            | wc -l 2>/dev/null; \
        echo ""; \
        echo "Total number of commits registered for the remote repository:"; \
        git rev-list --count --all 2>/dev/null || echo "No remote repository"; \
        echo "Total number of commits registered for the branch:"; \
        git rev-list --count HEAD 2>/dev/null;'
      ## @description Show Git work tree info: repo dir, common dir, top level, and superproject status.
      git_tree_info() { if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then printf "\n[Inside work tree]\n\nGit repo directory:\n%s\nGit repo common directory:\n%s\nPath to top level repo:\n%s\nSuperproject working tree:\n%s\n" "$(git rev-parse --git-dir)" "$(git rev-parse --git-common-dir)" "$(git rev-parse --show-toplevel)" "$(git rev-parse --show-superproject-working-tree 2>/dev/null | grep . || echo 'NOT A SUBMODULE')"; else printf "NO WORK TREE PRESENT FOR A REPO\n"; fi; }
      alias git-tree-info='git_tree_info'
      
    #region Git_Basic
      alias gra='git remote add'
      alias gra-o='git remote add origin'
      alias ga='git add'
      alias gal='git add .'
      alias gc='git commit'
      alias gca='git commit -a -m'
      alias galps='cd "$(git rev-parse --show-toplevel 2>/dev/null)" && git add . && git commit -am'
#endregion Git_Basic

    #region Git_Log_Status
      alias gl='git log'
      alias gl-o='git log --oneline'
      alias gs='git status'
      alias gsw='git show'
      alias grl='git reflog'
      alias gsl='git shortlog'
      alias gci='git check-ignore -v'
      alias glr='git ls-remote'
      alias glt='git ls-tree'
      alias glost='git fsck --lost-found'
      alias gfsckf='git fsck --full'
      alias gitgcagro='git gc --aggressive --prune=now'
#endregion Git_Log_Status

    #region Git_Remote
      alias gps='git push'
      alias gps-oh='git push origin HEAD'
      alias gps-ohm='git push origin HEAD:main'
      alias gpl='git pull'
      alias gf='git fetch'
#endregion Git_Remote

    #region Git_Branch_Diff
      alias gd='git diff'
      alias gb='git branch'
      alias gbv='git branch -v'
      alias gsc='git switch -c'
      alias gco='git checkout'
      alias gtop='git rev-parse --show-toplevel'
      alias gm='git merge'
      alias grb='git rebase'
#endregion Git_Branch_Diff

    #region Git_Reset_Revert
      alias grs='git reset'
      alias grs-h='git reset --hard'
      alias grs-s='git reset --soft'
      alias grs--1='git reset HEAD~1'
      alias grs-h--1='git reset --hard HEAD~1'
      alias grs-s--1='git reset --soft HEAD~1'
      alias grs--og='git reset origin'
      alias grs-h--og='git reset --hard origin'
      alias grs-s--og='git reset --soft origin'
      alias grv='git revert'
      alias grv-nc='git revert --no-commit'
      alias grv--h='git revert HEAD'
      alias grv-m--1='git revert -m 1'
#endregion Git_Reset_Revert

    #region Git_Stash
      alias gst='git stash'
      alias gst-ps='git statsh push'
      alias gst-pp-u='git stash push --include-untracked'
      alias gst-pp-a='git stash push --all'
      alias gst-pp-ki='git stash push --keep-index'
      alias gst-pp='git stash pop'
      alias gst-a='git stash apply'
      alias gst-d='git stash drop'
      alias gst-l='git stash list'
      alias gst-s='git stash show'
      alias gst-c='git stash clear'
      alias gst-filter-rdm='git filter-branch --force --prune-empty --index-filter "git rm --cached --ignore-unmatch README.md" cat -- --all'
#endregion Git_Stash
  #endregion Git_Aliases

  #region Navigation_Aliases
    alias desk='cd ~/Desktop'
    alias docs='cd ~/Documents'
    alias dl='cd ~/Downloads'
    alias ..='cd ..'
    alias ...='cd ../..'
    alias .ilv='cd _inc/laravel'
  #endregion Navigation_Aliases

  #region Laravel_PHP_Aliases
    alias artmrs='php artisan migrate:reset'
    alias artmsd='php artisan migrate:fresh --seed'
    alias artmst='php artisan migrate:status'
    alias artmrs-sd='php artisan migrate:status && php artisan migrate:reset && php artisan migrate:fresh --seed'
    alias artcl='php artisan permission:cache-reset && php artisan config:clear && php artisan cache:clear && php artisan optimize:clear && php artisan route:clear && php artisan view:clear && php artisan clear-compiled'
    alias artsv='php artisan serve'
    alias artclrs='
php artisan permission:cache-reset; \
php artisan config:clear; \
php artisan cache:clear; \
php artisan optimize:clear; \
php artisan route:clear; \
php artisan view:clear; \
php artisan clear-compiled; \
rm -f bootstrap/cache/services.php bootstrap/cache/packages.php bootstrap/cache/compiled.php bootstrap/cache/routes.php; \
composer dump-autoload -o; \
php artisan migrate:status; \
php artisan migrate:reset; \
php artisan migrate:fresh --seed; \
php artisan route:list --sort=uri; \
php artisan serve
'
    alias artrtl='php artisan route:list --sort=uri'
    alias laravel-rm-cache='rm -f bootstrap/cache/services.php && rm -f bootstrap/cache/packages.php && rm -f bootstrap/cache/compiled.php && rm -f bootstrap/cache/routes.php'
    alias compdp='composer dump-autoload -o'
    alias mysqlr='mysql -u root -p'
#endregion Laravel_PHP_Aliases

  #region Filesystem_Utilities
    alias list-files='find . -type f -exec sh -c '\''
	for file do
		basename=$(basename "$file")
		size=$(stat -c "%s" "$file")
		printf "NAME: %s  |  PATH: %s  |  SIZE: %s\n\n" "$basename" "$file" "$size"
	done
'\'' sh {} +'
    alias contains-files--r='find . -type d -exec sh -c '\''[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]'\'' {} \; -print'
    alias contains-files='find . -maxdepth 1 -type d -exec sh -c '\''[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]'\'' {} \; -print'
    alias wc-l-total-novendors="files=0; total=0; \
while IFS= read -r -d \$'\0' file; do \
  lines=\$(wc -l < \"\$file\"); \
  total=\$((total+lines)); \
  files=\$((files+1)); \
  printf \"%s %d\n\" \"\$file\" \"\$total\"; \
done < <(find . -type f \
     ! -path '*/vendor/*' \
     ! -path '*/node_modules/*' \
     ! -path '*/.git/*' \
     -print0); \
echo \"-> TOTAL NUMBER OF LINES IN THE DIRECTORY: \$total, distributed in \$files files\""
    alias clear-compressed='_find_matching_files() { if [ $# -eq 0 ]; then echo "Usage: find_matching_files <ext1> [ext2] [ext3] ..."; echo "Example: find_matching_files xci ns"; return 1; fi; local conditions=""; for ext in "$@"; do if [ -n "$conditions" ]; then conditions="$conditions -o -name \"\${base_path}.$ext\""; else conditions="-name \"\${base_path}.$ext\""; fi; done; local compressed_files=$(find . -type f \( -name "*.7z" -o -name "*.rar" -o -name "*.zip" \) | sed "s/\.[^.]*$//"); for base_path in $compressed_files; do local matching_files=$(eval "find . -type f \( $conditions \)"); if [ -n "$matching_files" ]; then echo "Found matching files for base path: $base_path"; echo "$matching_files"; echo; local compressed_file=""; for ext in 7z rar zip; do if [ -f "${base_path}.$ext" ]; then compressed_file="${base_path}.$ext"; break; fi; done; if [ -n "$compressed_file" ]; then echo "Compressed file: $compressed_file"; read -p "Do you want to delete '\''$compressed_file'\''? (y/N): " choice; case "$choice" in y|Y|yes|Yes|YES) rm -f "$compressed_file"; echo "Deleted: $compressed_file";; *) echo "Skipped: $compressed_file";; esac; echo "----------------------------------------"; fi; fi; done; }; _find_matching_files'

    pack_files() {
      local files
      local acc=0
      local pack_count=1
      local to_push_dir=""
      readarray -t files < <(find . -type f)
      for file in "${files[@]}"; do
        if [ $acc -eq 100 ] || [ $acc -eq 0 ]; then
          to_push_dir="pack${pack_count}"
          mkdir -p "$to_push_dir"
          echo "Packing files into directory: $to_push_dir"
          ((pack_count++))
          acc=0
        fi
        mv "$file" "$to_push_dir/"
        ((acc++))
      done
      echo "Packed ${#files[@]} files into $((pack_count - 1)) directories"
    }
    alias packf=pack_files

    ## @description View or edit the X11 Compose key character definitions.
    alias cat-compose-chars='sudo cat /usr/share/X11/locale/en_US.UTF-8/Compose'
    ## @description Alias for cat-compose-chars.
    alias show-compose-chars='sudo cat /usr/share/X11/locale/en_US.UTF-8/Compose'
    alias ls-compose-chars='cat-compose-chars'
    alias less-compose-chars='sudo less /usr/share/X11/locale/en_US.UTF-8/Compose'
    alias edit-compose-chars='sudo nano /usr/share/X11/locale/en_US.UTF-8/Compose'

    ## @description Find and sort files by path length, excluding vendor/node_modules/backup directories.
    ## @param $1 {string} extension - File extension pattern to match (required)
    ## @param $2 {string} src - Root search directory (default: .)
    ## @param $3 {int} max_depth - Max directory depth (default: 15)
    ## @param $4 {int} cut_indexes - If non-zero, strip path-length prefix from output (default: 0)
    function list_paths_no_vendors() {
      local extension=${1?Usage: find-sorted-paths-no-vendors <extension> ?<src=.> ?<max_depth=15> ?<cut_indexes=0>}
      local src=${2:-.}
      local max_depth=${3:-15}
      local cut_indexes=${4:-0}
      local sorted_res=$(find "$src" -maxdepth "$max_depth" -type f \( -not -path "*node_modules*" -not -path "*/vendor/*" -not -path "*backup/*" -not -path "*.venv/" -path "*${extension}" \) | awk '{print length,$0}' | sort -n -k1,1 -k2)
      if (( ! cut_indexes == 0 )); then
        sorted_res=$(echo "$sorted_res" | cut -d' ' -f2-)
      fi
      echo "$sorted_res"
    }
    alias list-paths-no-vendors='list_paths_no_vendors'
    ## @description List files under /var/log/journal with file type, size, and optional strings preview.
    ls_journal_files() {
      local path="/var/log/journal"
      if [[ ! -d "$path" ]]; then
        echo "Error: $path is not a directory" >&2
        return 1
      fi
      sudo find "$path" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do
        echo -e "\n"
        sudo file "$file" | sed "s|$path/||"
        sudo du -h "$file" | awk '{print $1}'
        if file -b --mime-encoding "$file" 2>/dev/null | grep -qi "binary"; then
          echo -e "⚠️  (binary — showing printable strings)"
          sudo strings "$file" 2>/dev/null | head -n 5
        fi
        echo -e "\n"
      done
    }
    ## @description Alias for ls-journal-files.
    alias ls-journal-files='ls_journal_files'
    ## @description Alias for ls-journal-files.
    alias show-journal-files='ls_journal_files'

#endregion Filesystem_Utilities

  #region Audiovisual_Processing
    gif_to_mp4() {
        local input="$1"
        local output="${2:-${input%.gif}.mp4}"

        # Guard clauses
        if ! command -v ffmpeg &>/dev/null; then
            echo "ERROR: ffmpeg not found" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: gif_to_mp4 <input.gif> [output.mp4]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ -f "$output" ]]; then
            echo "WARNING: Output '$output' already exists, overwriting..." >&2
        fi

        echo "Converting GIF '$input' -> MP4 '$output' ..."
        ffmpeg -i "$input" -c:v libx264 -pix_fmt yuv420p "$output" && \
            echo "✅ Success: $output" || {
                echo "❌ Conversion failed" >&2
                return 1
            }
    }
    webm_to_mp4() {
        local input="$1"
        local output="${2:-${input%.webm}.mp4}"

        if ! command -v ffmpeg &>/dev/null; then
            echo "ERROR: ffmpeg not found" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: webm_to_mp4 <input.webm> [output.mp4]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ -f "$output" ]]; then
            echo "WARNING: Output '$output' already exists, overwriting..." >&2
        fi

        echo "Converting WebM '$input' -> MP4 '$output' ..."
        ffmpeg -v warning -i "$input" \
            -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
            -c:v libx264 -crf 18 -c:a aac -b:a 192k "$output" && \
            echo "✅ Success: $output" || {
                echo "❌ Conversion failed" >&2
                return 1
            }
    }
    video_to_gif_chunks() {
        local input="$1"
        local chunk_duration="${2:-60}"      # seconds per chunk
        local fps="${3:-15}"
        local width="${4:-480}"
        local prefix="${5:-video}"

        if ! command -v ffmpeg &>/dev/null || ! command -v ffprobe &>/dev/null; then
            echo "ERROR: ffmpeg and ffprobe are required" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: video_to_gif_chunks <input.mp4> [chunk_duration=60] [fps=15] [width=480] [prefix=video]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ ! "$chunk_duration" =~ ^[0-9]+$ ]] || [[ "$chunk_duration" -le 0 ]]; then
            echo "ERROR: chunk_duration must be a positive integer (seconds)" >&2
            return 1
        fi

        # Get total duration (integer seconds)
        local duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" | cut -d. -f1)
        if [[ -z "$duration" ]]; then
            echo "ERROR: Could not read duration from '$input'" >&2
            return 1
        fi

        echo "Splitting '$input' (duration ${duration}s) into ${chunk_duration}s GIF chunks..."
        local c=0
        local success_count=0
        for ((i=0; i<=duration; i+=chunk_duration)); do
            local index=$(printf "%02d" "$c")
            local output="${prefix}_${index}.gif"
            echo "Processing chunk $c: $output"
            ffmpeg -v error -ss "$i" -t "$chunk_duration" -i "$input" \
                -vf "fps=$fps,scale=$width:-1:flags=lanczos" -y "$output" && \
                ((success_count++))
            ((c++))
        done

        echo "✅ Done! $success_count GIF chunk(s) created."
        if [[ $success_count -eq 0 ]]; then
            echo "WARNING: No chunks were generated" >&2
            return 1
        fi
    }
    concat_m4s() {
        if [ $# -lt 2 ]; then
            echo "Usage: ffmpeg_concat_m4s <output_file> <input_part1> [input_part2] ..."
            echo "Example: ffmpeg_concat_m4s output.mp4 part0.m4s part1.m4s part2.m4s"
            return 1
        fi
        local output_file="$1"
        shift
        local concat_list=$(mktemp)
        for input_file in "$@"; do
            if [ ! -f "$input_file" ]; then
                echo "Error: File not found - $input_file"
                rm -f "$concat_list"
                return 1
            fi
            echo "file '$input_file'" >> "$concat_list"
        done
        ffmpeg -f concat -safe 0 -i "$concat_list" -c copy "$output_file"
        if [ $? -eq 0 ]; then
            echo "Successfully created: $output_file"
        else
            echo "Error: ffmpeg concatenation failed"
        fi
        rm -f "$concat_list"
    }
    mp3_to_oga() {
      if ! command -v ffmpeg &>/dev/null; then
        echo "ERROR: ffmpeg not found" >&2
        return 1
      fi
      if [[ $# -eq 0 ]]; then
        echo "Usage: mp3_to_oga <file1.mp3> [file2.mp3 ...]" >&2
        return 1
      fi
        local quality="${FFMPEG_OGA_QUALITY:-3}"
        local codec="libvorbis"
        
        for input in "$@"; do
            local basename="${input%.mp3}"
            basename="${basename%.MP3}"
            local mp3_file="${basename}.mp3"
            local oga_file="${basename}.oga"
            
            [[ ! -f "$mp3_file" ]] && { echo "Missing: $mp3_file" >&2; continue; }
            [[ -z "$FORCE" && -f "$oga_file" ]] && { echo "Exists: $oga_file (FORCE=1 to overwrite)" >&2; continue; }
            
            ffmpeg -i "$mp3_file" \
                  -c:a "$codec" \
                  -q:a "$quality" \
                  -map_metadata 0 \
                  -loglevel error \
                  -nostdin \
                  ${FORCE:+-y} \
                  "$oga_file" </dev/null
        done
    }
    mp4_to_gif() {
        command -v ffmpeg  >/dev/null 2>&1 || { echo "ERROR: ffmpeg is required but not found." >&2; return 1; }
        command -v ffprobe >/dev/null 2>&1 || { echo "ERROR: ffprobe is required but not found." >&2; return 1; }

        local input="" output="" target_width="" target_height="" target_fps="" dither="bayer:bayer_scale=5"
        local usage="Usage: mp4-to-gif <input.mp4> [-o output.gif] [-w WIDTH] [-h HEIGHT] [-f FPS]"

        [[ $# -eq 0 ]] && { echo "$usage" >&2; return 1; }

        while [[ $# -gt 0 ]]; do
            case "$1" in
                -o) output="$2"; shift 2 ;;
                -w) target_width="$2"; shift 2 ;;
                -h) target_height="$2"; shift 2 ;;
                -f) target_fps="$2"; shift 2 ;;
                -*) echo "Unknown option: $1" >&2; echo "$usage" >&2; return 1 ;;
                *)  input="$1"; shift ;;
            esac
        done

        [[ -z "$input"   ]] && { echo "ERROR: no input file provided." >&2; return 1; }
        [[ ! -f "$input" ]] && { echo "ERROR: file '$input' not found." >&2; return 1; }

        local ext="${input##*.}"
        [[ "$ext" =~ ^(mp4|mov|mkv|avi|webm)$ ]] || { echo "ERROR: '$input' is not a recognised video file (.mp4/.mov/.mkv/.avi/.webm)." >&2; return 1; }

        local has_video
        has_video=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$input" 2>/dev/null)
        [[ "$has_video" == "video" ]] || { echo "ERROR: '$input' has no video stream." >&2; return 1; }

        local orig_width orig_height orig_fps
        IFS=',' read -r orig_width orig_height orig_fps < <(
            ffprobe -v error -select_streams v:0 \
                -show_entries stream=width,height,r_frame_rate \
                -of csv=p=0 "$input"
        )

        orig_fps=$(awk "BEGIN {printf \"%.2f\", ${orig_fps:-30/1}}")

        : "${output:=${input%.*}.gif}"
        : "${target_fps:=$orig_fps}"

        if [[ -f "$output" && "$output" != "${input%.*}.gif" ]]; then
            echo "WARNING: '$output' already exists. Overwrite? [y/N] "
            read -r reply
            [[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; return 1; }
        fi

        local scale_filter
        if [[ -n "$target_height" ]]; then
            scale_filter="scale=-2:${target_height}:flags=lanczos"
        elif [[ -n "$target_width" ]]; then
            scale_filter="scale=${target_width}:-2:flags=lanczos"
        else
            scale_filter="scale=${orig_width}:${orig_height}:flags=lanczos"
        fi

        echo "→ ${input}  (${orig_width}x${orig_height} @ ${orig_fps} fps)  →  ${output}"
        echo "  scale: ${scale_filter}   fps: ${target_fps}   dither: ${dither}"

        ffmpeg -y -i "$input" \
            -filter_complex \
                "[0:v] fps=${target_fps},${scale_filter},split[a][b];\
                [a]palettegen=max_colors=256:stats_mode=diff[p];\
                [b][p]paletteuse=dither=${dither}" \
            -loop 0 "$output"

        local ret=$?
        if [[ $ret -eq 0 ]]; then
            local size
            size=$(du -h "$output" | cut -f1)
            echo "✔ Done: ${output} (${size})"
        fi
        return $ret
    }
    ## Convert webm to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, defaults to input name with .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert webm to aac
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }
    ## Convert webm to wav (lossless PCM)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 ignored (kept for interface consistency)
    webm_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }
    ## Convert webm to aiff (lossless PCM)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 ignored
    webm_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }
    ## Convert webm to flac (lossless)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 compression level 0-8 (optional, default 5)
    webm_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }
    ## Convert webm to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a container for ALAC)
    ## @param $3 ignored (ALAC is lossless)
    webm_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert webm to ogg (Opus or Vorbis, default Opus)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert webm to oga (Ogg Vorbis, .oga extension)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert webm to wma (Windows Media Audio)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert mp4 to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mp4_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mp4 to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mp4_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mp4 to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mp4_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mp4 to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mp4_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }
    ## Convert mp4 to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to wma (Windows Media Audio)
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mpg to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert mpg to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }
    ## Convert mpg to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mpg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mpg to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mpg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mpg to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mpg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mpg to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mpg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mpg to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mpg to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mpg to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    ogg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }
    ## Convert ogg (video) to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    ogg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert ogg (video) to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    ogg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert ogg (video) to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    ogg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert ogg (video) to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert avi to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert avi to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert avi to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    avi_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert avi to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    avi_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert avi to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    avi_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert avi to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    avi_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert avi to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert avi to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert avi to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mov to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert mov to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mov to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mov_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mov to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mov_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mov to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mov_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mov to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mov_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mov to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mov to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mov to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert flv to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert flv to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert flv to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    flv_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert flv to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    flv_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert flv to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    flv_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert flv to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    flv_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert flv to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert flv to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert webm to mpg (MPEG-2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF quality 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1" or "640x480")
    webm_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert webm to ogg (Theora video)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    webm_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert webm to avi (MPEG-4)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert webm to mov (QuickTime)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert webm to flv (Flash Video)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp4 to mpg
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert mp4 to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mp4_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mp4 to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mp4 to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp4 to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to webm (VP9)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mpg_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert mpg to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mpg_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mpg to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mpg to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg (Theora) to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    ogg_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert ogg to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg to mpg
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert ogg to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mp4 to webm (VP9)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mp4_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert ogg (Theora) to mov (QuickTime H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg to flv (Flash Video H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    avi_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert avi to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to mpg (MPEG-2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert avi to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    avi_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert avi to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mov to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    mov_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert mov to mp4 (H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mov_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mov to mpg (MPEG-2/MP2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert mov to ogg (Theora/Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mov_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mov to avi (H.264/MP3)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mov to flv (Flash H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert flv to webm (VP9/Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    flv_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert flv to mp4 (H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert flv to mpg (MPEG-2/MP2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert flv to ogg (Theora/Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    flv_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert flv to avi (H.264/MP3)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert flv to mov (QuickTime H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1")
    flv_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp3 to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mp3_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mp3 to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mp3_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mp3 to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mp3_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mp3 to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mp3_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mp3 to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert aac to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert aac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    aac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert aac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    aac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert aac to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    aac_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert aac to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    aac_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert aac to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert aac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert aac to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert wav to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert wav to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert wav to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    wav_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert wav to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    wav_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert wav to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    wav_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert wav to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert wav to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert wav to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert aiff to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert aiff to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert aiff to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    aiff_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert aiff to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    aiff_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert aiff to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    aiff_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert aiff to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert aiff to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert aiff to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert flac to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert flac to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert flac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    flac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert flac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    flac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert flac to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    flac_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert flac to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert flac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert flac to wma (Windows Media Audio)
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert alac (Apple Lossless) to mp3
    ## @param $1 input file (usually .m4a)
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert alac to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert alac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    alac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert alac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    alac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert alac to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    alac_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert alac to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert alac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert alac to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio (Opus or Vorbis) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio (Opus/Vorbis) to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    ogg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert ogg audio to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    ogg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert ogg audio to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    ogg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert ogg audio to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    ogg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert ogg audio to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert oga (Ogg Vorbis) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert oga to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert oga to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    oga_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert oga (Ogg Vorbis) to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    oga_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert oga to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    oga_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert oga to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    oga_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert oga to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert oga to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert wma (Windows Media Audio) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert wma to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert wma to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    wma_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert wma to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    wma_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert wma to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    wma_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert wma to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    wma_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert wma to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert wma to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    alias gif-to-mp4='gif_to_mp4'
    alias webm-to-mp4='webm_to_mp4'
    alias video-to-gif-chunks='video_to_gif_chunks'
    alias mp3-to-oga='mp3_to_oga'
    alias concat-m4s='concat_m4s'
    alias mp4-to-gif='mp4_to_gif'
    alias ffmpeg-gif-to-mp4='gif_to_mp4'
    alias ffmpeg-webm-to-mp4='webm_to_mp4'
    alias ffmpeg-video-to-gif-chunks='video_to_gif_chunks'
    alias ffmpeg-mp3-to-oga='mp3_to_oga'
    alias ffmpeg-concat-m4s='concat_m4s'
    alias ffmpeg-mp4-to-gif='mp4_to_gif'
    alias ffmpeg-webm-to-mp3='webm_to_mp3'
    alias webm-to-mp3='webm_to_mp3'
    alias ffmpeg-webm-to-aac='webm_to_aac'
    alias webm-to-aac='webm_to_aac'
    alias ffmpeg-webm-to-wav='webm_to_wav'
    alias webm-to-wav='webm_to_wav'
    alias ffmpeg-webm-to-aiff='webm_to_aiff'
    alias webm-to-aiff='webm_to_aiff'
    alias ffmpeg-webm-to-flac='webm_to_flac'
    alias webm-to-flac='webm_to_flac'
    alias ffmpeg-webm-to-alac='webm_to_alac'
    alias webm-to-alac='webm_to_alac'
    alias ffmpeg-webm-to-ogg='webm_to_ogg'
    alias webm-to-ogg='webm_to_ogg'
    alias ffmpeg-webm-to-oga='webm_to_oga'
    alias webm-to-oga='webm_to_oga'
    alias ffmpeg-webm-to-wma='webm_to_wma'
    alias webm-to-wma='webm_to_wma'
    alias ffmpeg-mp4-to-mp3='mp4_to_mp3'
    alias mp4-to-mp3='mp4_to_mp3'
    alias ffmpeg-mp4-to-aac='mp4_to_aac'
    alias mp4-to-aac='mp4_to_aac'
    alias ffmpeg-mp4-to-wav='mp4_to_wav'
    alias mp4-to-wav='mp4_to_wav'
    alias ffmpeg-mp4-to-aiff='mp4_to_aiff'
    alias mp4-to-aiff='mp4_to_aiff'
    alias ffmpeg-mp4-to-flac='mp4_to_flac'
    alias mp4-to-flac='mp4_to_flac'
    alias ffmpeg-mp4-to-alac='mp4_to_alac'
    alias mp4-to-alac='mp4_to_alac'
    alias ffmpeg-mp4-to-ogg='mp4_to_ogg'
    alias mp4-to-ogg='mp4_to_ogg'
    alias ffmpeg-mp4-to-oga='mp4_to_oga'
    alias mp4-to-oga='mp4_to_oga'
    alias ffmpeg-mp4-to-wma='mp4_to_wma'
    alias mp4-to-wma='mp4_to_wma'
    alias ffmpeg-mpg-to-mp3='mpg_to_mp3'
    alias mpg-to-mp3='mpg_to_mp3'
    alias ffmpeg-mpg-to-aac='mpg_to_aac'
    alias mpg-to-aac='mpg_to_aac'
    alias ffmpeg-mpg-to-wav='mpg_to_wav'
    alias mpg-to-wav='mpg_to_wav'
    alias ffmpeg-mpg-to-aiff='mpg_to_aiff'
    alias mpg-to-aiff='mpg_to_aiff'
    alias ffmpeg-mpg-to-flac='mpg_to_flac'
    alias mpg-to-flac='mpg_to_flac'
    alias ffmpeg-mpg-to-alac='mpg_to_alac'
    alias mpg-to-alac='mpg_to_alac'
    alias ffmpeg-mpg-to-ogg='mpg_to_ogg'
    alias mpg-to-ogg='mpg_to_ogg'
    alias ffmpeg-mpg-to-oga='mpg_to_oga'
    alias mpg-to-oga='mpg_to_oga'
    alias ffmpeg-mpg-to-wma='mpg_to_wma'
    alias mpg-to-wma='mpg_to_wma'
    alias ffmpeg-ogg-to-mp3='ogg_to_mp3'
    alias ogg-to-mp3='ogg_to_mp3'
    alias ffmpeg-ogg-to-aac='ogg_to_aac'
    alias ogg-to-aac='ogg_to_aac'
    alias ffmpeg-ogg-to-wav='ogg_to_wav'
    alias ogg-to-wav='ogg_to_wav'
    alias ffmpeg-ogg-to-aiff='ogg_to_aiff'
    alias ogg-to-aiff='ogg_to_aiff'
    alias ffmpeg-ogg-to-flac='ogg_to_flac'
    alias ogg-to-flac='ogg_to_flac'
    alias ffmpeg-ogg-to-alac='ogg_to_alac'
    alias ogg-to-alac='ogg_to_alac'
    alias ffmpeg-ogg-to-ogg='ogg_to_ogg'
    alias ogg-to-ogg='ogg_to_ogg'
    alias ffmpeg-ogg-to-oga='ogg_to_oga'
    alias ogg-to-oga='ogg_to_oga'
    alias ffmpeg-ogg-to-wma='ogg_to_wma'
    alias ogg-to-wma='ogg_to_wma'
    alias ffmpeg-avi-to-mp3='avi_to_mp3'
    alias avi-to-mp3='avi_to_mp3'
    alias ffmpeg-avi-to-aac='avi_to_aac'
    alias avi-to-aac='avi_to_aac'
    alias ffmpeg-avi-to-wav='avi_to_wav'
    alias avi-to-wav='avi_to_wav'
    alias ffmpeg-avi-to-aiff='avi_to_aiff'
    alias avi-to-aiff='avi_to_aiff'
    alias ffmpeg-avi-to-flac='avi_to_flac'
    alias avi-to-flac='avi_to_flac'
    alias ffmpeg-avi-to-alac='avi_to_alac'
    alias avi-to-alac='avi_to_alac'
    alias ffmpeg-avi-to-ogg='avi_to_ogg'
    alias avi-to-ogg='avi_to_ogg'
    alias ffmpeg-avi-to-oga='avi_to_oga'
    alias avi-to-oga='avi_to_oga'
    alias ffmpeg-avi-to-wma='avi_to_wma'
    alias avi-to-wma='avi_to_wma'
    alias ffmpeg-mov-to-mp3='mov_to_mp3'
    alias mov-to-mp3='mov_to_mp3'
    alias ffmpeg-mov-to-aac='mov_to_aac'
    alias mov-to-aac='mov_to_aac'
    alias ffmpeg-mov-to-wav='mov_to_wav'
    alias mov-to-wav='mov_to_wav'
    alias ffmpeg-mov-to-aiff='mov_to_aiff'
    alias mov-to-aiff='mov_to_aiff'
    alias ffmpeg-mov-to-flac='mov_to_flac'
    alias mov-to-flac='mov_to_flac'
    alias ffmpeg-mov-to-alac='mov_to_alac'
    alias mov-to-alac='mov_to_alac'
    alias ffmpeg-mov-to-ogg='mov_to_ogg'
    alias mov-to-ogg='mov_to_ogg'
    alias ffmpeg-mov-to-oga='mov_to_oga'
    alias mov-to-oga='mov_to_oga'
    alias ffmpeg-mov-to-wma='mov_to_wma'
    alias mov-to-wma='mov_to_wma'
    alias ffmpeg-flv-to-mp3='flv_to_mp3'
    alias flv-to-mp3='flv_to_mp3'
    alias ffmpeg-flv-to-aac='flv_to_aac'
    alias flv-to-aac='flv_to_aac'
    alias ffmpeg-flv-to-wav='flv_to_wav'
    alias flv-to-wav='flv_to_wav'
    alias ffmpeg-flv-to-aiff='flv_to_aiff'
    alias flv-to-aiff='flv_to_aiff'
    alias ffmpeg-flv-to-flac='flv_to_flac'
    alias flv-to-flac='flv_to_flac'
    alias ffmpeg-flv-to-alac='flv_to_alac'
    alias flv-to-alac='flv_to_alac'
    alias ffmpeg-flv-to-ogg='flv_to_ogg'
    alias flv-to-ogg='flv_to_ogg'
    alias ffmpeg-flv-to-oga='flv_to_oga'
    alias flv-to-oga='flv_to_oga'
    alias ffmpeg-flv-to-wma='flv_to_wma'
    alias flv-to-wma='flv_to_wma'
    alias ffmpeg-webm-to-mpg='webm_to_mpg'
    alias webm-to-mpg='webm_to_mpg'
    alias ffmpeg-webm-to-ogg='webm_to_ogg'
    alias webm-to-ogg='webm_to_ogg'
    alias ffmpeg-webm-to-avi='webm_to_avi'
    alias webm-to-avi='webm_to_avi'
    alias ffmpeg-webm-to-mov='webm_to_mov'
    alias webm-to-mov='webm_to_mov'
    alias ffmpeg-webm-to-flv='webm_to_flv'
    alias webm-to-flv='webm_to_flv'
    alias ffmpeg-mp4-to-webm='mp4_to_webm'
    alias mp4-to-webm='mp4_to_webm'
    alias ffmpeg-mp4-to-mpg='mp4_to_mpg'
    alias mp4-to-mpg='mp4_to_mpg'
    alias ffmpeg-mp4-to-ogg='mp4_to_ogg'
    alias mp4-to-ogg='mp4_to_ogg'
    alias ffmpeg-mp4-to-avi='mp4_to_avi'
    alias mp4-to-avi='mp4_to_avi'
    alias ffmpeg-mp4-to-mov='mp4_to_mov'
    alias mp4-to-mov='mp4_to_mov'
    alias ffmpeg-mp4-to-flv='mp4_to_flv'
    alias mp4-to-flv='mp4_to_flv'
    alias ffmpeg-mpg-to-webm='mpg_to_webm'
    alias mpg-to-webm='mpg_to_webm'
    alias ffmpeg-mpg-to-mp4='mpg_to_mp4'
    alias mpg-to-mp4='mpg_to_mp4'
    alias ffmpeg-mpg-to-ogg='mpg_to_ogg'
    alias mpg-to-ogg='mpg_to_ogg'
    alias ffmpeg-mpg-to-avi='mpg_to_avi'
    alias mpg-to-avi='mpg_to_avi'
    alias ffmpeg-mpg-to-mov='mpg_to_mov'
    alias mpg-to-mov='mpg_to_mov'
    alias ffmpeg-mpg-to-flv='mpg_to_flv'
    alias mpg-to-flv='mpg_to_flv'
    alias ffmpeg-ogg-to-webm='ogg_to_webm'
    alias ogg-to-webm='ogg_to_webm'
    alias ffmpeg-ogg-to-mp4='ogg_to_mp4'
    alias ogg-to-mp4='ogg_to_mp4'
    alias ffmpeg-ogg-to-mpg='ogg_to_mpg'
    alias ogg-to-mpg='ogg_to_mpg'
    alias ffmpeg-ogg-to-avi='ogg_to_avi'
    alias ogg-to-avi='ogg_to_avi'
    alias ffmpeg-ogg-to-mov='ogg_to_mov'
    alias ogg-to-mov='ogg_to_mov'
    alias ffmpeg-ogg-to-flv='ogg_to_flv'
    alias ogg-to-flv='ogg_to_flv'
    alias ffmpeg-avi-to-webm='avi_to_webm'
    alias avi-to-webm='avi_to_webm'
    alias ffmpeg-avi-to-mp4='avi_to_mp4'
    alias avi-to-mp4='avi_to_mp4'
    alias ffmpeg-avi-to-mpg='avi_to_mpg'
    alias avi-to-mpg='avi_to_mpg'
    alias ffmpeg-avi-to-ogg='avi_to_ogg'
    alias avi-to-ogg='avi_to_ogg'
    alias ffmpeg-avi-to-mov='avi_to_mov'
    alias avi-to-mov='avi_to_mov'
    alias ffmpeg-avi-to-flv='avi_to_flv'
    alias avi-to-flv='avi_to_flv'
    alias ffmpeg-mov-to-webm='mov_to_webm'
    alias mov-to-webm='mov_to_webm'
    alias ffmpeg-mov-to-mp4='mov_to_mp4'
    alias mov-to-mp4='mov_to_mp4'
    alias ffmpeg-mov-to-mpg='mov_to_mpg'
    alias mov-to-mpg='mov_to_mpg'
    alias ffmpeg-mov-to-ogg='mov_to_ogg'
    alias mov-to-ogg='mov_to_ogg'
    alias ffmpeg-mov-to-avi='mov_to_avi'
    alias mov-to-avi='mov_to_avi'
    alias ffmpeg-mov-to-flv='mov_to_flv'
    alias mov-to-flv='mov_to_flv'
    alias ffmpeg-flv-to-webm='flv_to_webm'
    alias flv-to-webm='flv_to_webm'
    alias ffmpeg-flv-to-mp4='flv_to_mp4'
    alias flv-to-mp4='flv_to_mp4'
    alias ffmpeg-flv-to-mpg='flv_to_mpg'
    alias flv-to-mpg='flv_to_mpg'
    alias ffmpeg-flv-to-ogg='flv_to_ogg'
    alias flv-to-ogg='flv_to_ogg'
    alias ffmpeg-flv-to-avi='flv_to_avi'
    alias flv-to-avi='flv_to_avi'
    alias ffmpeg-flv-to-mov='flv_to_mov'
    alias flv-to-mov='flv_to_mov'
    alias ffmpeg-mp3-to-aac='mp3_to_aac'
    alias mp3-to-aac='mp3_to_aac'
    alias ffmpeg-mp3-to-wav='mp3_to_wav'
    alias mp3-to-wav='mp3_to_wav'
    alias ffmpeg-mp3-to-aiff='mp3_to_aiff'
    alias mp3-to-aiff='mp3_to_aiff'
    alias ffmpeg-mp3-to-flac='mp3_to_flac'
    alias mp3-to-flac='mp3_to_flac'
    alias ffmpeg-mp3-to-alac='mp3_to_alac'
    alias mp3-to-alac='mp3_to_alac'
    alias ffmpeg-mp3-to-ogg='mp3_to_ogg'
    alias mp3-to-ogg='mp3_to_ogg'
    alias ffmpeg-mp3-to-oga='mp3_to_oga'
    alias mp3-to-oga='mp3_to_oga'
    alias ffmpeg-mp3-to-wma='mp3_to_wma'
    alias mp3-to-wma='mp3_to_wma'
    alias ffmpeg-aac-to-mp3='aac_to_mp3'
    alias aac-to-mp3='aac_to_mp3'
    alias ffmpeg-aac-to-wav='aac_to_wav'
    alias aac-to-wav='aac_to_wav'
    alias ffmpeg-aac-to-aiff='aac_to_aiff'
    alias aac-to-aiff='aac_to_aiff'
    alias ffmpeg-aac-to-flac='aac_to_flac'
    alias aac-to-flac='aac_to_flac'
    alias ffmpeg-aac-to-alac='aac_to_alac'
    alias aac-to-alac='aac_to_alac'
    alias ffmpeg-aac-to-ogg='aac_to_ogg'
    alias aac-to-ogg='aac_to_ogg'
    alias ffmpeg-aac-to-oga='aac_to_oga'
    alias aac-to-oga='aac_to_oga'
    alias ffmpeg-aac-to-wma='aac_to_wma'
    alias aac-to-wma='aac_to_wma'
    alias ffmpeg-wav-to-mp3='wav_to_mp3'
    alias wav-to-mp3='wav_to_mp3'
    alias ffmpeg-wav-to-aac='wav_to_aac'
    alias wav-to-aac='wav_to_aac'
    alias ffmpeg-wav-to-aiff='wav_to_aiff'
    alias wav-to-aiff='wav_to_aiff'
    alias ffmpeg-wav-to-flac='wav_to_flac'
    alias wav-to-flac='wav_to_flac'
    alias ffmpeg-wav-to-alac='wav_to_alac'
    alias wav-to-alac='wav_to_alac'
    alias ffmpeg-wav-to-ogg='wav_to_ogg'
    alias wav-to-ogg='wav_to_ogg'
    alias ffmpeg-wav-to-oga='wav_to_oga'
    alias wav-to-oga='wav_to_oga'
    alias ffmpeg-wav-to-wma='wav_to_wma'
    alias wav-to-wma='wav_to_wma'
    alias ffmpeg-aiff-to-mp3='aiff_to_mp3'
    alias aiff-to-mp3='aiff_to_mp3'
    alias ffmpeg-aiff-to-aac='aiff_to_aac'
    alias aiff-to-aac='aiff_to_aac'
    alias ffmpeg-aiff-to-wav='aiff_to_wav'
    alias aiff-to-wav='aiff_to_wav'
    alias ffmpeg-aiff-to-flac='aiff_to_flac'
    alias aiff-to-flac='aiff_to_flac'
    alias ffmpeg-aiff-to-alac='aiff_to_alac'
    alias aiff-to-alac='aiff_to_alac'
    alias ffmpeg-aiff-to-ogg='aiff_to_ogg'
    alias aiff-to-ogg='aiff_to_ogg'
    alias ffmpeg-aiff-to-oga='aiff_to_oga'
    alias aiff-to-oga='aiff_to_oga'
    alias ffmpeg-aiff-to-wma='aiff_to_wma'
    alias aiff-to-wma='aiff_to_wma'
    alias ffmpeg-flac-to-mp3='flac_to_mp3'
    alias flac-to-mp3='flac_to_mp3'
    alias ffmpeg-flac-to-aac='flac_to_aac'
    alias flac-to-aac='flac_to_aac'
    alias ffmpeg-flac-to-wav='flac_to_wav'
    alias flac-to-wav='flac_to_wav'
    alias ffmpeg-flac-to-aiff='flac_to_aiff'
    alias flac-to-aiff='flac_to_aiff'
    alias ffmpeg-flac-to-alac='flac_to_alac'
    alias flac-to-alac='flac_to_alac'
    alias ffmpeg-flac-to-ogg='flac_to_ogg'
    alias flac-to-ogg='flac_to_ogg'
    alias ffmpeg-flac-to-oga='flac_to_oga'
    alias flac-to-oga='flac_to_oga'
    alias ffmpeg-flac-to-wma='flac_to_wma'
    alias flac-to-wma='flac_to_wma'
    alias ffmpeg-alac-to-mp3='alac_to_mp3'
    alias alac-to-mp3='alac_to_mp3'
    alias ffmpeg-alac-to-aac='alac_to_aac'
    alias alac-to-aac='alac_to_aac'
    alias ffmpeg-alac-to-wav='alac_to_wav'
    alias alac-to-wav='alac_to_wav'
    alias ffmpeg-alac-to-aiff='alac_to_aiff'
    alias alac-to-aiff='alac_to_aiff'
    alias ffmpeg-alac-to-flac='alac_to_flac'
    alias alac-to-flac='alac_to_flac'
    alias ffmpeg-alac-to-ogg='alac_to_ogg'
    alias alac-to-ogg='alac_to_ogg'
    alias ffmpeg-alac-to-oga='alac_to_oga'
    alias alac-to-oga='alac_to_oga'
    alias ffmpeg-alac-to-wma='alac_to_wma'
    alias alac-to-wma='alac_to_wma'
    alias ffmpeg-ogg-to-mp3='ogg_to_mp3'
    alias ogg-to-mp3='ogg_to_mp3'
    alias ffmpeg-ogg-to-aac='ogg_to_aac'
    alias ogg-to-aac='ogg_to_aac'
    alias ffmpeg-ogg-to-wav='ogg_to_wav'
    alias ogg-to-wav='ogg_to_wav'
    alias ffmpeg-ogg-to-aiff='ogg_to_aiff'
    alias ogg-to-aiff='ogg_to_aiff'
    alias ffmpeg-ogg-to-flac='ogg_to_flac'
    alias ogg-to-flac='ogg_to_flac'
    alias ffmpeg-ogg-to-alac='ogg_to_alac'
    alias ogg-to-alac='ogg_to_alac'
    alias ffmpeg-ogg-to-oga='ogg_to_oga'
    alias ogg-to-oga='ogg_to_oga'
    alias ffmpeg-ogg-to-wma='ogg_to_wma'
    alias ogg-to-wma='ogg_to_wma'
    alias ffmpeg-oga-to-mp3='oga_to_mp3'
    alias oga-to-mp3='oga_to_mp3'
    alias ffmpeg-oga-to-aac='oga_to_aac'
    alias oga-to-aac='oga_to_aac'
    alias ffmpeg-oga-to-wav='oga_to_wav'
    alias oga-to-wav='oga_to_wav'
    alias ffmpeg-oga-to-aiff='oga_to_aiff'
    alias oga-to-aiff='oga_to_aiff'
    alias ffmpeg-oga-to-flac='oga_to_flac'
    alias oga-to-flac='oga_to_flac'
    alias ffmpeg-oga-to-alac='oga_to_alac'
    alias oga-to-alac='oga_to_alac'
    alias ffmpeg-oga-to-ogg='oga_to_ogg'
    alias oga-to-ogg='oga_to_ogg'
    alias ffmpeg-oga-to-wma='oga_to_wma'
    alias oga-to-wma='oga_to_wma'
    alias ffmpeg-wma-to-mp3='wma_to_mp3'
    alias wma-to-mp3='wma_to_mp3'
    alias ffmpeg-wma-to-aac='wma_to_aac'
    alias wma-to-aac='wma_to_aac'
    alias ffmpeg-wma-to-wav='wma_to_wav'
    alias wma-to-wav='wma_to_wav'
    alias ffmpeg-wma-to-aiff='wma_to_aiff'
    alias wma-to-aiff='wma_to_aiff'
    alias ffmpeg-wma-to-flac='wma_to_flac'
    alias wma-to-flac='wma_to_flac'
    alias ffmpeg-wma-to-alac='wma_to_alac'
    alias wma-to-alac='wma_to_alac'
    alias ffmpeg-wma-to-ogg='wma_to_ogg'
    alias wma-to-ogg='wma_to_ogg'
    alias ffmpeg-wma-to-oga='wma_to_oga'
    alias wma-to-oga='wma_to_oga'
  #endregion Audiovisual_Processing

#endregion PUBLICABLE_CODE
### * END OF PUBLICABLE CODE * ###

### * START OF POWERSHELL PROFILE EQUIVALENTS * ###
#region POWERSHELL_PROFILE_EQUIVALENTS

  #region Power_Management
    set_power_sleep() {
      systemctl suspend
    }
    alias p-sleep='set_power_sleep'

    diagnose_memory() {
      free -h
    }
    alias diag-mem='diagnose_memory'
#endregion Power_Management

  #region Helper_Functions
    get_file_manager() {
      de="${XDG_CURRENT_DESKTOP,,}"
      case "$de" in
        gnome*|unity)     echo nautilus   ;;
        kde*|plasma)      echo dolphin    ;;
        cinnamon)         echo nemo       ;;
        xfce*|xubuntu)    echo thunar     ;;
        mate)             echo caja       ;;
        lxde)             echo pcmanfm    ;;
        lxqt)             echo pcmanfm-qt ;;
        *)                echo xdg-open   ;;
      esac
    }

    get_user_dir() {
      if command -v xdg-user-dir >/dev/null 2>&1; then
        xdg-user-dir "$1"
      else
        case "$1" in
          DESKTOP)   echo "$HOME/Desktop"   ;;
          DOCUMENTS) echo "$HOME/Documents" ;;
          PICTURES)  echo "$HOME/Pictures"  ;;
          DOWNLOAD)  echo "$HOME/Downloads" ;;
          MUSIC)     echo "$HOME/Music"     ;;
          VIDEOS)    echo "$HOME/Videos"    ;;
          *)         echo "$HOME"          ;;
        esac
      fi
    }
  #endregion Helper_Functions

  #region Quick_Open_Folders
    open_recycle_bin() {
      "$(get_file_manager)" trash://
    }
    alias ls-cbin='open_recycle_bin'

    open_documents() {
      "$(get_file_manager)" "$(get_user_dir DOCUMENTS)"
    }
    alias ls-docs='open_documents'

    open_desktop() {
      "$(get_file_manager)" "$(get_user_dir DESKTOP)"
    }
    alias ls-desk='open_desktop'

    open_pictures() {
      "$(get_file_manager)" "$(get_user_dir PICTURES)"
    }
    alias ls-pics='open_pictures'

    open_fonts() {
      "$(get_file_manager)" "${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
    }
    alias ls-fonts='open_fonts'
#endregion Quick_Open_Folders

  #region Hardware_Inspection
    get_usb_controller_device() {
      lsusb
    }
    alias ls-usb-dev='get_usb_controller_device'

    get_processor() {
      lscpu
    }
    alias ls-cpu='get_processor'

    get_usb_controller() {
      lspci | grep -i usb
    }
    alias ls-usb='get_usb_controller'

    get_physical_memory() {
      free -h
    }
    alias ls-mem='get_physical_memory'

    get_disk_drive() {
      lsblk -d
    }
    alias ls-disks='get_disk_drive'

    get_logical_disk() {
      df -h
    }
    alias ls-ldisk='get_logical_disk'

    get_battery() {
      acpi -b
    }
    alias ls-batt='get_battery'

    get_power_setting() {
      if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl list
      else
        echo powerprofilesctl not installed
      fi
    }
    alias ls-pwr='get_power_setting'

    get_printers() {
      lpstat -p -d
    }
    alias ls-prin='get_printers'

    get_video_controller() {
      lspci | grep -iE 'vga|3d|display'
    }
    alias ls-gpu='get_video_controller'

    get_monitors() {
      if command -v xrandr >/dev/null 2>&1; then
        xrandr --listmonitors
      else
        echo xrandr not installed
      fi
    }
    alias ls-mons='get_monitors'
#endregion Hardware_Inspection

  #region System_Info
    get_network_adapter_configuration() {
      if command -v nmcli >/dev/null 2>&1; then
        nmcli device show
      else
        ip addr
      fi
    }
    alias ls-net='get_network_adapter_configuration'

    get_bios() {
      sudo dmidecode -t bios
    }
    alias ls-bios='get_bios'

    get_ntlog_event() {
      journalctl
    }
    alias ls-logs='get_ntlog_event'

    get_user_account() {
      getent passwd
    }
    alias ls-users='get_user_account'

    get_computer_system() {
      uname -a
    }
    alias ls-host='get_computer_system'

    ## @description List all groups from the system database.
    get_groups() {
      getent group
    }
    alias ls-groups='get_groups'

    ## @description List users belonging to a specific group.
    ## @param $1 {string} group_name - Name of the group to query.
    get_group_users() {
      local group_name="${1:?Usage: get_group_users <group_name>}"
      local groups=($(cut -d: -f1 /etc/group))
      if [[ ! " ${groups[*]} " =~ " ${group_name} " ]]; then
        echo "Group '$group_name' does not exist in the system. Aborting."
        return 1
      fi
      grep "^${group_name}:" /etc/group | cut -d: -f4 | tr ',' '\n' | sort -u
    }
    ## @description Alias for get_group_users.
    alias get-group-users='get_group_users'
    ## @description Alias for get_group_users.
    alias ls-group-users='get_group_users'
    ## @description Dump dconf user settings database as readable strings.
    alias stringify-user-settings='sudo strings ~/.config/dconf/user'
    ## @description Alias for stringify-user-settings.
    alias str-user-stg='stringify-user-settings'

    get_operating_system() {
      if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -a
      else
        hostnamectl
      fi
    }
    alias ls-os='get_operating_system'

    get_product() {
      if command -v dpkg-query >/dev/null 2>&1; then
        dpkg-query -l
      elif command -v rpm >/dev/null 2>&1; then
        rpm -qa
      else
        echo "no package manager found"
      fi
    }
    alias ls-pkgs='get_product'
#endregion System_Info

  #region Hardware_Data_Functions
    processor_data() {
      lscpu
    }
    alias cpu-info='processor_data'

    ssram_data() {
      sudo dmidecode -t memory
    }
    alias ssram-info='ssram_data'

    storage_data() {
      lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
      df -h
    }
    alias storage-info='storage_data'

    usb_data() {
      lsusb
    }
    alias usb-info='usb_data'

    video_data() {
      lspci | grep -iE 'vga|3d|display'
    }
    alias video-info='video_data'

    pnp_signed_driver() {
      if command -v lspci >/dev/null 2>&1; then
        lspci -k
      else
        echo "install pciutils"
      fi
    }
    alias pnp-info='pnp_signed_driver'

    wddm_version() {
      if command -v glxinfo >/dev/null 2>&1; then
        glxinfo | grep "OpenGL version string"
      else
        echo "install mesa-utils"
      fi
    }
    alias wddm-info='wddm_version'

    grouped_hardware() {
      if command -v lshw >/dev/null 2>&1; then
        sudo lshw -short
      else
        echo "install lshw"
      fi
    }
    alias lshw='grouped_hardware'
#endregion Hardware_Data_Functions

  #region Services_Network
    get_services() {
      if command -v systemctl >/dev/null 2>&1; then
        systemctl list-units --type=service --no-pager
      else
        service --status-all
      fi
    }
    alias ls-svc='get_services'

    netsh_winsock_catalog() {
      ss -tunap
    }
    alias ls-sock='netsh_winsock_catalog'

    netsh_wlan() {
      if command -v nmcli >/dev/null 2>&1; then
        nmcli device wifi list
      elif command -v iwlist >/dev/null 2>&1; then
        sudo iwlist scan
      else
        echo "no wireless tool available"
      fi
    }
    alias ls-wlan='netsh_wlan'

    get_wireless_capabilities() {
      if command -v iw >/dev/null 2>&1; then
        iw list
      elif command -v nmcli >/dev/null 2>&1; then
        nmcli device wifi list
      else
        echo "install iw or NetworkManager to view wireless capabilities"
      fi
    }
    alias ls-wcap='get_wireless_capabilities'

    get_net_drivers() {
      if command -v lspci >/dev/null 2>&1; then
        lspci -nnk | grep -A3 -i network
      else
        echo "install pciutils to list network drivers"
      fi
    }
    alias ls-netdrv='get_net_drivers'
#endregion Services_Network

  #region File_Utilities
    alias get-mimeapps='cat ~/.config/mimeapps.list 2>/dev/null || echo "=== NO LIST FOUND FOR CONFIG OF MIME FOR APPS ==="'
    alias get-compose-chars='sudo cat /usr/share/X11/locale/en_US.UTF-8/Compose'

    calc_storage() {
      local target_input="${1:-c:}"
      local drive_letter="${target_input:0:1}"
      drive_letter="${drive_letter,,}"
      drive_letter="${drive_letter//[^a-z]/}"
      local target_dir="/${drive_letter}"
      printf "Calculating storage for: %s\n" "$target_dir" >&2
      local last_dir=""
      find "$target_dir" -type f 2>/dev/null | \
      while IFS= read -r file; do
        local dir="${file%/*}"
        if [[ "$dir" != "$last_dir" ]]; then
          printf "Reading directory: %s\n" "$dir" >&2
          last_dir="$dir"
        fi
        stat -c "%s" "$file" 2>/dev/null
      done | \
      awk '{ sum += $1 } END { printf "Total: %.2f GB\n", sum/1073741824 }'
    }
    alias calc-storage=calc_storage

    compress_current_directory() {
      local zip_dest="$(basename "$(pwd)").zip"
      zip -r "$zip_dest" . -x "*/node_modules/*" "*/vendor/*"
      echo "Archive created: $zip_dest"
    }
    alias compdir='compress_current_directory'

    unzip_all() {
      shopt -s globstar nocaseglob
      for f in **/*.zip **/*.7z **/*.rar; do
        d="${f%/*}"
        case "${f,,}" in
          *.zip) unzip -o "$f" -d "$d" ;;
          *.7z)  7z x "$f" -o"$d" ;;
          *.rar) unrar x "$f" "$d" ;;
        esac
      done
    }
    alias uz-all='unzip_all'

    delete_all_compressed() {
      shopt -s nocaseglob
      rm -f *.zip *.7z *.rar
    }
    alias del-comp='delete_all_compressed'

    convert_to_pascal_case() {
      local input="$1"
      local base="${input%_controller}"
      local pascal
      pascal=$(echo "$base" | sed -r 's/(^|_)([a-z])/\U\2/g')
      if [[ "$input" == *_controller ]]; then
        echo "${pascal}Controller"
      else
        echo "$pascal"
      fi
    }
    alias topascal='convert_to_pascal_case'

    convert_to_snake_case() {
      local input="$1"
      local step
      step=$(echo "$input" | sed -r 's/([A-Z]+)([A-Z][a-z])/\1_\2/g')
      step=$(echo "$step"  | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g')
      echo "${step,,}"
    }
    alias tosnake='convert_to_snake_case'

    sanitize_dirnames() {
      local recurse=0
      [[ "$1" == "-r" ]] && recurse=1
      local find_opts=(-type d)
      (( recurse )) || find_opts+=(-maxdepth 1)

      find . "${find_opts[@]}" -print0 | while IFS= read -r -d $'\0' dir; do
        base="${dir##*/}"
        new_base=$(echo "$base" | sed 's/[^a-zA-Z0-9_]/__/g' | tr '[:upper:]' '[:lower:]')
        if [[ "$new_base" != "$base" ]]; then
          echo -e "\n\033[32mRenaming '$base' to '$new_base'\033[0m\n"
          mv -f "$dir" "${dir%/*}/$new_base"
        fi
      done

      dirs=()
      while IFS= read -r -d $'\0'; do dirs+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)

      echo -en "\n\033[36mReplace multiple underscores with single? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        for dir in "${dirs[@]}"; do
          base="${dir##*/}"
          new_base=$(echo "$base" | sed 's/__+/_/g')
          [[ "$new_base" == "$base" ]] && continue
          echo -e "\n\033[32mRenaming '$base' to '$new_base'\033[0m\n"
          mv -f "$dir" "${dir%/*}/$new_base"
        done
        dirs=()
        while IFS= read -r -d $'\0'; do dirs+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
      fi

      echo -en "\n\033[36mTrim long names to 255 characters? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        for dir in "${dirs[@]}"; do
          base="${dir##*/}"
          [[ ${#base} -le 255 ]] && continue
          new_base="${base:0:255}"
          echo -e "\n\033[33mTrimming '$base' (length ${#base}) to '$new_base'\033[0m\n"
          mv -f "$dir" "${dir%/*}/$new_base"
        done
      fi
    }
    alias sanitize-d='sanitize_dirnames'

    sanitize_filenames() {
      local recurse=0
      [[ "$1" == "-r" ]] && recurse=1
      local find_opts=(-type f)
      (( recurse )) || find_opts+=(-maxdepth 1)

      find . "${find_opts[@]}" -print0 | while IFS= read -r -d $'\0' file; do
        dir="${file%/*}"
        base="${file##*/}"
        ext="${base##*.}"
        [[ "$base" == "$ext" ]] && ext="" || base_noext="${base%.*}"
        new_base=$(echo "$base_noext" | sed 's/[^a-zA-Z0-9_]/__/g' | tr '[:upper:]' '[:lower:]')
        new_name="$new_base${ext:+.${ext}}"
        [[ "$new_name" == "$base" ]] && continue
        echo -e "\n\033[32mRenaming '$base' to '$new_name'\033[0m\n"
        mv -f "$file" "$dir/$new_name"
      done

      files=()
      while IFS= read -r -d $'\0'; do files+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)

      echo -en "\n\033[36mReplace multiple underscores with single? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        for file in "${files[@]}"; do
          dir="${file%/*}"
          base="${file##*/}"
          ext="${base##*.}"
          [[ "$base" == "$ext" ]] && ext="" || base_noext="${base%.*}"
          new_base=$(echo "$base_noext" | sed 's/__+/_/g')
          new_name="$new_base${ext:+.${ext}}"
          [[ "$new_name" == "$base" ]] && continue
          echo -e "\n\033[32mRenaming '$base' to '$new_name'\033[0m\n"
          mv -f "$file" "$dir/$new_name"
        done
        files=()
        while IFS= read -r -d $'\0'; do files+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
      fi

      echo -en "\n\033[36mTrim long names to 255 characters? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        for file in "${files[@]}"; do
          base="${file##*/}"
          ext="${base##*.}"
          [[ "$base" == "$ext" ]] && { ext=""; base_noext="$base"; } || base_noext="${base%.*}"
          max_base_len=$((255 - ${#ext} - ${ext:+-1}))
          [[ ${#base_noext} -le $max_base_len ]] && continue
          new_base="${base_noext:0:$max_base_len}"
          new_name="$new_base${ext:+.${ext}}"
          dir="${file%/*}"
          echo -e "\n\033[33mTrimming '$base' (length ${#base}) to '$new_name'\033[0m\n"
          mv -f "$file" "$dir/$new_name"
        done
      fi
    }
    alias sanitize-f='sanitize_filenames'

    sanitize_names() {
      local recurse=""
      [[ "$1" == "-r" ]] && recurse="-r"
      echo -en "\n\033[36mSanitize directory names? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        echo "Sanitizing directory names..."
        sanitize_dirnames $recurse
      fi
      echo -en "\n\033[36mSanitize file names? [Y/N] \033[0m"
      read -r choice
      if [[ "${choice^^}" == "Y" ]]; then
        echo "Sanitizing file names..."
        sanitize_filenames $recurse
      fi
    }
    alias sanitize-a='sanitize_names'
#endregion File_Utilities

  #region Backup_Analysis
    backup_robo() {
      local src=$1 dst=$2 retry=${3:-3} wait=${4:-5}
      for ((i=1; i<=retry; i++)); do
        rsync -a "$src" "$dst" && break || sleep "$wait"
      done
    }
    alias bcp='backup_robo'

    heavy_folders() {
      local root=${1:-.} top=${2:-10}
      du -Sb "$root"/* 2>/dev/null \
        | sort -nr \
        | head -n "$top" \
        | awk '{printf "%.2fGB\t%s\n",$1/1024/1024/1024,$2}'
    }
    alias hfold='heavy_folders'

    heavy_files() {
      local root=${1:-.} top=${2:-10}
      find "$root" -type f -printf '%s %p\n' 2>/dev/null \
        | sort -nr \
        | head -n "$top" \
        | awk '{printf "%.2fGB\t%s\n",$1/1024/1024/1024,substr($0,index($0,$2))}'
    }
    alias hfile='heavy_files'

    du_surface() {
      local path=${1:-.}
      du -sh "$path"/* 2>/dev/null | sort -hr
    }
    alias du-surface='du_surface'

    measure_file_distribution() {
      local root=$1 sub=$2 filter=${3:-*}
      [ ! -d "$root" ] && { echo "Root path not found"; return 1; }
      local root_count sub_count pct
      root_count=$(find "$root" -type f -name "$filter" 2>/dev/null | wc -l)
      echo "Found $root_count files in root folder"
      local sub_path="$root/$sub"
      [ ! -d "$sub_path" ] && { echo "Subdirectory '$sub' not found"; return 1; }
      sub_count=$(find "$sub_path" -type f -name "$filter" 2>/dev/null | wc -l)
      echo "Found $sub_count files in subfolder"
      pct=0
      [ "$root_count" -gt 0 ] && pct=$(awk -v s="$sub_count" -v r="$root_count" 'BEGIN{printf "%.2f", s/r*100}')
      printf "Root Files Count: %s\nNested Files Count: %s\nPercentage Nested: %s%%\nFilter Applied: %s\n" \
        "$root_count" "$sub_count" "$pct" "$filter"
    }
    alias mfd='measure_file_distribution'

    search_interactive() {
      read -rp "Enter filename or pattern: " pattern
      local matches=()
      while IFS= read -r f; do
        echo "Looking at: $f"
        [[ "$(basename "$f")" == $pattern ]] && matches+=("$f")
      done < <(find . -type f)
      if [ ${#matches[@]} -gt 0 ]; then
        echo "Matches for '$pattern':"
        printf "%s\n" "${matches[@]}"
      else
        echo "No files found matching '$pattern'."
      fi
    }
    alias sint='search_interactive'

    recursive_search_files() {
      local path=${1:-.} idx=${2:-1} filter=${3:-*}
      case "$idx" in
        0) find "$path" -type f -name "$filter" ;;
        1) find "$path" -type f -name "$filter" -printf '%f\n' ;;
        2) find "$path" -type f -name "$filter" -exec stat {} \; ;;
        *) echo "Index must be 0, 1 or 2" ;;
      esac
    }
    alias rsf='recursive_search_files'

    cd_by_index() {
      local idx=${1:-0}
      mapfile -t dirs < <(printf "%s\n" */)
      [ ${#dirs[@]} -eq 0 ] && { echo "No directories found"; return 1; }
      if [ "$idx" -lt 0 ] || [ "$idx" -ge "${#dirs[@]}" ]; then
        echo "Index out of range. Available dirs:"
        for i in "${!dirs[@]}"; do printf "[%d] %s\n" "$i" "${dirs[i]}"; done
        return 1
      fi
      cd "${dirs[idx]}"
    }
    alias cd-i='cd_by_index'

    expand_all_7z() {
      local path=${1:-.}
      shopt -s nullglob
      for f in "$path"/*.7z; do
        7z x "$f" -o"$path"
      done
    }
    alias exp-7z='expand_all_7z'

    code_by_index() {
      local path=${1:-.} idx=${2:-0} files
      mapfile -t files < <(ls -1A "$path")
      if (( idx<0 || idx>=${#files[@]} )); then
        echo "Index out of range. Valid: 0 to $(( ${#files[@]} - 1 ))"
        for i in "${!files[@]}"; do printf "[%d] %s\n" "$i" "${files[i]}"; done
        return 1
      fi
      code "$path/${files[idx]}"
    }
    alias code-i='code_by_index'

    open_with_excel() {
      local file=$1
      [[ -f "$file" ]] || { echo "Invalid path: $file"; return 1; }
      case "$file" in *.xls|*.xlsx|*.xlsm) ;; *) echo "Not an Excel file"; return 1;; esac
      command -v soffice >/dev/null 2>&1 && soffice --calc "$file" \
        || { echo "Please install libreoffice-calc"; return 1; }
    }
    alias xcl='open_with_excel'
#endregion Backup_Analysis

  #region Data_Extraction
    get_concatenated_gpt_tokens() {
      local file=$1
      [[ -f "$file" ]] || { echo "Invalid path: $file"; return 1; }
      command -v jq >/dev/null 2>&1 || { echo "Please install jq"; return 1; }
      jq -r '.[] .data.v' "$file" | sed G
    }
    alias join-tokens='get_concatenated_gpt_tokens'

    get_java_files_data() {
      local count=0 lines=0 f
      while IFS= read -r f; do
        echo "Found $f"
        count=$((count+1))
        lines=$((lines + $(wc -l < "$f")))
      done < <(find . -type f -name "*.java" 2>/dev/null)
      printf "Total Java Files: %d\nTotal Java Lines: %d\n" "$count" "$lines"
    }
    alias jdata='get_java_files_data'

    get_js_files_data() {
      local count=0 lines=0 f
      while IFS= read -r f; do
        echo "Found $f"
        count=$((count+1))
        lines=$((lines + $(wc -l < "$f")))
      done < <(find . -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.mjs" -o -name "*.jsx" -o -name "*.ts" -o -name "*.cts" -o -name "*.mts" -o -name "*.tsx" -o -name "*.vue" \) 2>/dev/null)
      printf "Total JS Files: %d\nTotal JS Lines: %d\n" "$count" "$lines"
    }
    alias jsdata='get_js_files_data'

    get_php_files_data() {
      local count=0 lines=0 f
      while IFS= read -r f; do
        echo "Found $f"
        count=$((count+1))
        lines=$((lines + $(wc -l < "$f")))
      done < <(find . -type f -name "*.php" 2>/dev/null)
      printf "Total PHP Files: %d\nTotal PHP Lines: %d\n" "$count" "$lines"
    }
    alias phpdata='get_php_files_data'

    get_python_files_data() {
      local count=0 lines=0 f
      while IFS= read -r f; do
        echo "Found $f"
        count=$((count+1))
        lines=$((lines + $(wc -l < "$f")))
      done < <(find . -type f -name "*.py" 2>/dev/null)
      printf "Total Python Files: %d\nTotal Python Lines: %d\n" "$count" "$lines"
    }
    alias pydata='get_python_files_data'

    get_prog_lang_files_data() {
      local patterns=("$@") count=0 lines=0 f
      for p in "${patterns[@]}"; do
        while IFS= read -r f; do
          echo "Found $f"
          count=$((count+1))
          lines=$((lines + $(wc -l < "$f")))
        done < <(find . -type f -name "$p" 2>/dev/null)
      done
      printf "Total Files: %d\nTotal Lines: %d\n" "$count" "$lines"
    }
    alias pldata='get_prog_lang_files_data'

    remove_multiple_underscores() {
      local path="${1:-.}" interactive=1
      [[ "$2" == "--no-interactive" ]] && interactive=0
      find "$path" -type f -name "*__*" | while IFS= read -r file; do
        local base="${file##*/}" dir="${file%/*}" newbase="${base//__/_}"
        if (( interactive )); then
          read -rp "Replace '$base' with '$newbase'? [y/N]: " resp
          [[ "$resp" =~ ^[Yy] ]] || { echo "Skipped"; continue; }
        fi
        mv -i "$file" "$dir/$newbase" && echo "Renamed '$base' → '$newbase'" || echo "Error renaming '$base'"
      done
    }
    alias rmmultius='remove_multiple_underscores'
    ## @description Rename all files in the current directory to random 16-char alphanumeric names, preserving extensions. Requires sudo.
    fully_randomized_file_names() {
      sudo -v || { echo "Requires sudo privileges to rename files with random names"; return 1; }
      for f in *; do [[ -f "$f" ]] && mv -- "$f" "$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c 16).${f##*.}"; done
    }
    ## @description Alias for fully_randomized_file_names.
    alias fully-randomized-file-names='fully_randomized_file_names'
    ## @description Alias for fully_randomized_file_names.
    alias randomize-filenames='fully_randomized_file_names'
    ## @description Alias for fully_randomized_file_names (short form).
    alias rand-fn='fully_randomized_file_names'
#endregion Data_Extraction

  #region Browser_Dev
    clear_chrome_fetches() {
      local user_dir="${HOME}"
      # candidate Chrome cache paths
      local cache_dirs=(
        "$HOME/.cache/google-chrome/Default/Code Cache/entries"
        "$HOME/.cache/chromium/Default/Code Cache/entries"
      )
      for dir in "${cache_dirs[@]}"; do
        if [ -d "$dir" ]; then
          echo "Clearing Chrome fetches in $dir"
          rm -rf "${dir:?}"/*
        fi
      done
      echo "Chrome fetch cache cleared."
    }
    alias rm-chromefetch='clear_chrome_fetches'

    # mysqlr() {
    #   mysql -u root -p
    # }
    # alias mysqlr='mysqlr'

    py_venv() {
      source ./env/bin/activate
    }
    alias py-venv='py_venv'

    pymng() {
      command -v python >/dev/null 2>&1 || { echo "Python not found"; return 1; }
      [ ! -f manage.py ] && { echo "No manage.py found"; return 1; }
      python manage.py "$@"
      [ "$1" = runserver ] && echo "[Django] Server running. Press Ctrl+C to stop."
    }
    alias pymng='pymng'
    alias django='pymng'

    kill_chrome() {
      pkill -9 -f chrome 2>/dev/null || echo "No Chrome processes found"
      echo "Chrome processes terminated"
    }
    alias killchrome='kill_chrome'

    clear_chrome_fetch() {
      local dirs=(
        "$HOME/.cache/google-chrome/Default/Code Cache/entries"
        "$HOME/.cache/chromium/Default/Code Cache/entries"
      )
      for d in "${dirs[@]}"; do
        [ -d "$d" ] && rm -rf "$d"/*
      done
      echo "Chrome fetch cache cleared"
    }
    alias rmchrome-fetch='clear_chrome_fetch'
#endregion Browser_Dev

  #region HTML_CSS_Tools
    ## @description Strip all HTML comments from a file and reformat with Prettier.
    ## @param $1 {string} path - Path to the HTML file (required)
    strip_html_comments_format() {
      local path="${1:?Usage: strip-html-comments <html_file>}"
      [[ -f "$path" ]] || { echo -e "❌ \033[1;31mFile not found:\033[0m $path"; return 1; }
      perl -0777 -i -pe 's/<!--(?!.*?--\s*>.*?<!--).*?-->//gs' "$path" \
        && npx prettier --parser html --print-width 120 --tab-width 2 \
             --no-semi --single-attribute-per-line \
             --html-whitespace-sensitivity ignore --write "$path"
    }
    alias strip-html-comments='strip_html_comments_format'
    ## @description Extract <style> content from an HTML file, minify with clean-css-cli,
    ##              and display original vs minified byte sizes.
    ## @param $1 {string} src          - Source HTML file (required)
    ## @param $2 {string} extract_src  - Destination for extracted CSS (required)
    ## @param $3 {string} extract_min  - Destination for minified CSS (required)
    extract_minify_css() {
      local src="${1:?Usage: extract-min-css <html_file> <extracted.css> <minified.css>}"
      local extract_src="${2:?Usage: extract-min-css <html_file> <extracted.css> <minified.css>}"
      local extract_min="${3:?Usage: extract-min-css <html_file> <extracted.css> <minified.css>}"
      [[ -f "$src" ]] || { echo -e "❌ \033[1;31mSource not found:\033[0m $src"; return 1; }
      perl -0777 -ne '/<style[^>]*>(.*?)<\/style>/s && print $1' "$src" > "$extract_src" \
        && npx clean-css-cli -o "$extract_min" "$extract_src" \
        && wc -c "$extract_src" "$extract_min"
    }
    alias extract-min-css='extract_minify_css'
    ## @description Count HTML comments and total lines in a file.
    ## @param $1 {string} path - Path to the HTML file (required)
    count_html_comments() {
      local path="${1:?Usage: count-html-comments <html_file>}"
      [[ -f "$path" ]] || { echo -e "❌ \033[1;31mFile not found:\033[0m $path"; return 1; }
      echo "Comments: $(grep -c '<!--' "$path")"
      echo "Lines:    $(wc -l < "$path")"
    }
    alias count-html-comments='count_html_comments'
    ## @description Check which CSS minifier CLI is available (csso or clean-css-cli).
    check_css_minifier() {
      npx csso --version 2>/dev/null \
        || npx clean-css-cli --version 2>/dev/null \
        || echo "NONE"
    }
    alias check-css-minifier='check_css_minifier'
    ## @description Inject a minified CSS file into the <style> block of an HTML file,
    ##              then restore @media and @container at-rules collapsed by minification.
    ## @param $1 {string} src     - HTML file to inject into (required)
    ## @param $2 {string} min_css - Minified CSS file to inject (required)
    inject_minified_css() {
      local src="${1:?Usage: inject-min-css <html_file> <minified_css_file>}"
      local min_css="${2:?Usage: inject-min-css <html_file> <minified_css_file>}"
      [[ -f "$src" ]] || { echo -e "❌ \033[1;31mSource not found:\033[0m $src"; return 1; }
      [[ -f "$min_css" ]] || { echo -e "❌ \033[1;31mCSS not found:\033[0m $min_css"; return 1; }
      local css
      css=$(<"$min_css")
      perl -0777 -i -pe \
        "s{(<style[^>]*>).*?(</style>)}{\$1${css}\$2}s" "$src"
      perl -0777 -i -pe '
        s/\}\s*(print|screen|all|speech)\s*\{/}\@media $1\{/g;
        s/(container-type:\s*[a-z-]+\s*\})\s*(\([^)]+\)\s*\{)/$1\@container $2/g;
        s/\}\s+(\([^)]+\)\s*\{)/}\@media $1/g;
      ' "$src"
      echo -e "✅ Injected into \033[1m$src\033[0m ($(wc -l < "$src") lines)"
    }
    alias inject-min-css='inject_minified_css'
#endregion HTML_CSS_Tools

  #region Android_ADB
    list_heaviest_android_files() {
      local IGNORE_DIRS=(/system /vendor /proc /sys /dev /asec /acct /mnt /sys/fs /storage)
      local MAX_RESULTS=200
      local INTERIM_COUNT=50
      local REPORT_INTERVAL=100
      local temp_file
      temp_file=$(mktemp) || return 1

      generate_report() {
        sort -nrk1 "$1" |
        head -n "$2" |
        awk -F $'\t' '{ printf("%12d  %s\n", $1, $2) }'
      }

      countdown() {
        local sec=$1
        while (( sec > 0 )); do
          echo -ne "Resuming in $sec... (press C to pause) \r"
          read -rsn1 -t 1 key
          if [[ $key == [Cc] ]]; then
            echo -ne "\nPaused. Press C to resume.\n"
            while true; do
              read -rsn1 key2
              [[ $key2 == [Cc] ]] && break
            done
          fi
          (( sec-- ))
        done
        echo -ne "\r                                       \r"
      }

      local dirs=()
      while IFS= read -r -d '' dir; do
        local skip=false
        for ignore in "${IGNORE_DIRS[@]}"; do
          [[ "$dir" == "$ignore"* ]] && { skip=true; break; }
        done
        $skip || dirs+=("$dir")
      done < <(adb shell find / -type d -print0 2>/dev/null)

      local total=${#dirs[@]}
      local processed=0

      for dir in "${dirs[@]}"; do
        (( processed++ ))
        echo "[$processed/$total] Scanning: $dir"
        adb shell "find '$dir' -maxdepth 1 -type f -printf '%s\t%p\n'" 2>/dev/null >> "$temp_file"

        if (( processed % REPORT_INTERVAL == 0 )); then
          echo
          echo "Interim top $INTERIM_COUNT largest files so far:"
          generate_report "$temp_file" "$INTERIM_COUNT"
          echo
          countdown 5
          echo
        fi
      done

      echo
      echo "Final top $MAX_RESULTS largest files:"
      generate_report "$temp_file" "$MAX_RESULTS"
      rm -f "$temp_file"
    }
    alias ls-heavy-adb='list_heaviest_android_files'

    list_heaviest_android_dirs() {
      local IGNORE_DIRS=(/system /vendor /proc /sys /dev /asec /acct /mnt /sys/fs /storage)
      local MAX_RESULTS=200 INTERIM_COUNT=50 REPORT_INTERVAL=100
      local temp_file dirs=() total processed key key2 sec

      temp_file=$(mktemp) || return 1

      generate_report() {
        sort -nrk1 "$1" | head -n "$2" | awk -F $'\t' '{printf("%12d  %s\n",$1,$2)}'
      }

      countdown() {
        sec=$1
        while (( sec > 0 )); do
          echo -ne "Resuming in $sec... (press C to pause) \r"
          read -rsn1 -t 1 key
          if [[ $key == [Cc] ]]; then
            echo -ne "\nPaused. Press C to resume.\n"
            while true; do
              read -rsn1 key2
              [[ $key2 == [Cc] ]] && break
            done
          fi
          (( sec-- ))
        done
        echo -ne "\r                                       \r"
      }

      while IFS= read -r -d '' dir; do
        skip=false
        for ignore in "${IGNORE_DIRS[@]}"; do
          [[ "$dir" == "$ignore"* ]] && { skip=true; break; }
        done
        $skip || dirs+=("$dir")
      done < <(adb shell find / -type d -print0 2>/dev/null)

      total=${#dirs[@]}
      processed=0

      for dir in "${dirs[@]}"; do
        (( processed++ ))
        echo "[$processed/$total] Measuring: $dir"
        adb shell du -s "$dir" 2>/dev/null | awk '{print $1"\t"$2}' >> "$temp_file"
        if (( processed % REPORT_INTERVAL == 0 )); then
          echo
          echo "Interim top $INTERIM_COUNT largest directories so far:"
          generate_report "$temp_file" "$INTERIM_COUNT"
          echo
          countdown 5
          echo
        fi
      done

      echo
      echo "Final top $MAX_RESULTS largest directories:"
      generate_report "$temp_file" "$MAX_RESULTS"
      rm -f "$temp_file"
    }
    alias ls-heavy-adb-dirs='list_heaviest_android_dirs'
#endregion Android_ADB

  #region Alias_Shortcuts
    #region Complex_Functions
      alias tosnake='convert_to_snake_case'
      alias compweb='compress_current_directory'
      alias unzipall='unzip_all'
      alias deletezip='delete_all_compressed'
      alias getheavfiles='heavy_files'
      alias getheavdirs='heavy_folders'
      alias filedistrib='measure_file_distribution'
      alias isearch='search_interactive'
      alias lsrf='recursive_search_files'
      alias idxcode='code_by_index'
      alias getgpttokens='get_concatenated_gpt_tokens'
      alias getjavadata='get_java_files_data'
      alias getjsdata='get_js_files_data'
      alias getphpdata='get_php_files_data'
      alias getpydata='get_python_files_data'
      alias getplngdata='get_prog_lang_files_data'
#endregion Complex_Functions

    #region Hardware_Aliases
      alias getprocfull='processor_data'
      alias getssramfull='ssram_data'
      alias getstoragefull='storage_data'
      alias lshw-storage='storage_data'
      alias getusbportfull='usb_data'
      alias lsusb='usb_data'
      alias getvcfull='video_data'
      alias gethwfull='grouped_hardware'
#endregion Hardware_Aliases

    #region Storage_Aliases
      alias cbin='open_recycle_bin'
#endregion Storage_Aliases

    #region USB_Aliases
      alias getusbcd='get_usb_controller_device'
      alias getusbc='get_usb_controller'
#endregion USB_Aliases

    #region Proc_Mem_Aliases
      alias getproc='get_processor'
      alias getpmem='get_physical_memory'
      alias getdd='get_disk_drive'
      alias getld='get_logical_disk'
      alias getvc='get_video_controller'
      alias getwddm='wddm_version'
#endregion Proc_Mem_Aliases

    #region Core_System_Aliases
      alias getbt='get_battery'
      alias getpws='get_power_setting'
      alias getprn='get_printers'
      alias getbios='get_bios'
      alias getcs='get_computer_system'
      alias getos='get_operating_system'
      alias getprod='get_product'
      alias getsvc='get_services'
#endregion Core_System_Aliases

    #region Administration_Aliases
      alias getua='get_user_account'
      alias getgu='get_group_user'
      alias getntlog='get_ntlog_event'
#endregion Administration_Aliases

    #region Network_Aliases
      alias getnac='get_network_adapter_configuration'
      alias netshv='netsh_winsock_catalog'
      alias netsha='netsh_wlan'
      alias netshc='get_wireless_capabilities'
      alias getndv='get_net_drivers'
#endregion Network_Aliases

    #region Quick_Open_Aliases
      alias recyclebin='open_recycle_bin'
      alias documents='open_documents'
      alias docs='open_documents'
      alias desktop='open_desktop'
      alias dkt='open_desktop'
      alias pictures='open_pictures'
      alias pct='open_pictures'
      alias memdiag='diagnose_memory'
      alias fonts='open_fonts'
      alias personalization='open_personalization'
#endregion Quick_Open_Aliases
  #endregion Alias_Shortcuts

  #region XFCE_Settings
    alias deb-st-display='xfce4-display-settings'
    alias deb-st-nightlight='xfce4-power-manager-settings'
    alias deb-st-screenresolution='xfce4-display-settings'
    alias deb-st-multitasking='xfce4-workspace-settings'
    alias deb-st-about='xfce4-about'
    alias deb-st-systeminfo='xfce4-about'
    alias deb-st-sound='pavucontrol'
    alias deb-st-sound-devices='pavucontrol'
    alias deb-st-audio='pavucontrol'
    alias deb-st-network='nm-connection-editor'
    alias deb-st-wifi='nm-connection-editor'
    alias deb-st-ethernet='nm-connection-editor'
    alias deb-st-bluetooth='blueman-manager'
    alias st-bt='blueman-manager'
    alias deb-st-proxy='nm-connection-editor'
    alias deb-st-personalization='xfce4-settings-manager'
    alias deb-st-themes='xfce4-appearance-settings'
    alias deb-st-colors='xfce4-appearance-settings'
    alias deb-st-background='xfce4-desktop-settings'
    alias deb-st-lockscreen='xfce4-screensaver-preferences'
    alias deb-st-taskbar='xfce4-panel --preferences'
    alias deb-st-fonts='xfce4-appearance-settings'
    alias deb-st-cursormousepointer='xfce4-mouse-settings'
    alias deb-st-printers='system-config-printer'
    alias deb-st-mouse='xfce4-mouse-settings'
    alias deb-st-touchpad='xfce4-mouse-settings'
    alias deb-st-keyboard='xfce4-keyboard-settings'
    alias deb-st-pen='xfce4-mouse-settings'
    alias deb-st-autoplay='thunar --preferences'
    alias deb-st-usb='thunar'
    alias deb-st-dateandtime='xfce4-time-admin'
    alias deb-st-regionlanguage='xfce4-settings-manager'
    alias deb-st-language='xfce4-settings-manager'
    alias deb-st-powersleep='xfce4-power-manager-settings'
    alias deb-st-batterysaver='xfce4-power-manager-settings'
    alias deb-st-poweroptions='xfce4-power-manager-settings'
    alias deb-st-storagesense='thunar'
    alias deb-st-defaultapps='xfce4-mime-settings'
    alias deb-st-maps='xdg-open https://maps.google.com'
    alias deb-st-appsfeatures='xfce4-appfinder'
    alias deb-st-optionalfeatures='synaptic'
    alias deb-st-programsfeatures='synaptic'
    alias deb-st-defaultapps='xfce4-mime-settings'
    alias deb-st-appdefaults='xfce4-mime-settings'
    alias deb-st-yourinfo='users-admin'
    alias deb-st-signinoptions='users-admin'
    alias deb-st-workplace='users-admin'
    alias deb-st-otherusers='users-admin'
    alias deb-st-gaming='steam'
    alias deb-st-gamemode='gamemode'
    alias deb-st-easeofaccess='xfce4-accessibility-settings'
    alias deb-st-display-easeofaccess='xfce4-display-settings'
    alias deb-st-mousepointer='xfce4-mouse-settings'
    alias deb-st-keyboard-easeofaccess='xfce4-keyboard-settings'
    alias deb-st-privacy='xfce4-settings-manager'
    alias deb-st-windowsdefender='clamav'
    alias deb-st-backup='deja-dup'
    alias deb-st-troubleshoot='xfce4-settings-manager'
    alias deb-st-recovery='systemd-analyze'
    alias deb-st-activation='xfce4-about'
    alias deb-st-findmydevice='echo "Feature not available in Linux"'
    alias deb-st-windowsupdate='sudo apt update && sudo apt upgrade'
    alias deb-st-windowsdefender='sudo clamav-freshclam'
    alias deb-st-backup='deja-dup-preferences'
    alias deb-st-troubleshoot='xfce4-settings-manager'
    alias deb-st-recovery='echo "Use GRUB recovery mode"'
    alias deb-st-activation='echo "No activation needed in Linux"'
    alias deb-st-developers='xfce4-settings-manager'
    alias deb-st-cortana='xfce4-appfinder'
    alias deb-st-search='xfce4-appfinder'
    alias deb-st-holographic='echo "Mixed reality not natively supported"'
    alias deb-st-explorer='thunar'
    alias deb-st-thispc='thunar'
    alias deb-st-documents='thunar ~/Documents'
    alias deb-st-downloads='thunar ~/Downloads'
    alias deb-st-music='thunar ~/Music'
    alias deb-st-pictures='thunar ~/Pictures'
    alias deb-st-videos='thunar ~/Videos'
    alias deb-st-desktop='thunar ~/Desktop'
    alias deb-st-controlpanel='xfce4-settings-manager'
    alias deb-st-admintools='xfce4-settings-manager'
    alias deb-st-devicemanager='lshw-gtk'
    alias deb-st-diskmgmt='gnome-disks'
    alias deb-st-eventvwr='gnome-logs'
    alias deb-st-services='systemd-manager'
    alias deb-st-taskmanager='htop'
    alias deb-st-regedit='dconf-editor'
    alias deb-st-terminal='xfce4-terminal'
    alias deb-st-filemanager='thunar'
    alias deb-st-calculator='galculator'
    alias deb-st-notepad='mousepad'
    alias deb-st-paint='gimp'
    alias deb-st-screenshot='xfce4-screenshooter'
    alias deb-st-msinfo32='hardinfo'
    alias deb-st-msconfig='systemd-manager'
    alias deb-st-cmd='xfce4-terminal'
    alias deb-st-powershell='xfce4-terminal'
    alias deb-st-run='xfce4-appfinder --collapsed'
#endregion XFCE_Settings

#endregion POWERSHELL_PROFILE_EQUIVALENTS
### * END OF POWERSHELL PROFILE EQUIVALENTS * ###