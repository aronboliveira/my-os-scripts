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
      echo -e "\n⚠️  \033[1;36mChecking for errors/warnings in gnome-shell logs...\033[0m"
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
          systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk 2>/dev/null || true
          printf "    \033[1;32m→ Restarted\033[0m xdg-desktop-portal services to apply D-Bus settings\n"
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
    rm -f "$0"
    exit 0
fi
ignore_inhibitors=false
ide_programs=(
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
)
editor_programs=(
    gedit kate kwrite mousepad
    pluma xed xedit
    featherpad leafpad notepadqq
    gvim emacs emacs-gtk emacs-nox
    l3afpad tea focuswriter
    ghostwriter manuskript
)
rdp_programs=(
    anydesk teamviewer remmina
    vinagre xfreerdp wlfreerdp
    rustdesk nxplayer nxclient
    parsec x2goclient krdc
    tigervnc vncviewer
    xrdp xrdp-sesman
)
filemanager_programs=(
    nautilus thunar dolphin
    pcmanfm pcmanfm-qt
    nemo caja spacefm
    krusader konqueror
    doublecmd ranger mc
    sunflower gentoo polo-file-manager
)
all_programs=(
    "${ide_programs[@]}"
    "${editor_programs[@]}"
    "${rdp_programs[@]}"
    "${filemanager_programs[@]}"
)
for prog in "${all_programs[@]}"; do
    if ! which "$prog" &>/dev/null && ! type -P "$prog" &>/dev/null; then
        continue
    fi
    has_procs=false
    if pgrep -x "$prog" &>/dev/null; then
        has_procs=true
    elif ps -C "$prog" --no-headers 2>/dev/null | grep -q .; then
        has_procs=true
    fi
    if [[ "$has_procs" != true ]]; then
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
shutdown -h now 2>/dev/null || true
sleep 120
if [[ "$ignore_inhibitors" == true ]]; then
    systemctl poweroff --ignore-inhibitors 2>/dev/null || true
else
    systemctl poweroff 2>/dev/null || true
fi
sleep 120
if [[ "$ignore_inhibitors" == true ]]; then
    echo "systemctl poweroff --ignore-inhibitors" | at now + 2 minutes 2>/dev/null || true
else
    echo "systemctl poweroff" | at now + 2 minutes 2>/dev/null || true
fi
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
      alias cat-grub-etc='sudo cat /etc/default/grub'
      ## @description Alias for cat-grub-etc.
      alias ls-grub-etc='sudo cat /etc/default/grub'
      ## @description Alias for cat-grub-etc.
      alias show-grub-etc='sudo cat /etc/default/grub'
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
## @description Watch memory-hungry processes sorted by RSS in real time.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch_mem_hogs() {
        local interval="${1:-0.25}"
        watch -n "$interval" 'ps aux --sort=-%mem | awk "{print \$1,\$2,\$4,\$5,\$6,\$11}"'
      }
      alias watch-mem-hogs='watch_mem_hogs'
## @description Show the OOM kill score for a process (higher = more likely to be killed).
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_kill_score() {
        local pid="${1?"Usage: cat-pid-oom-kill-score <pid>"}"
        echo ==== "OOM SCORE (TO BE KILLED)" ====
        sudo cat /proc/"$pid"/oom_score 2>/dev/null || echo "No OOM score info available"
      }
      alias cat-pid-oom-kill-score='cat_pid_oom_kill_score'
## @description Show the OOM adjustment score for a process (-1000 to 1000; lower = less likely to be killed).
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_adj_score() {
        local pid="${1?"Usage: cat-pid-oom-adj-score <pid>"}"
        echo ==== "OOM SCORE (TO BE ADJUSTED)" ====
        sudo cat /proc/"$pid"/oom_score_adj 2>/dev/null || echo "No OOM adj info available"
      }
      alias cat-pid-oom-adj-score='cat_pid_oom_adj_score'
## @description Show both OOM kill score and adjustment score for a process.
      ## @param $1 {int} pid - Process ID (required)
      cat_pid_oom_scores() {
        local pid="${1?"Usage: cat-pid-oom-scores <pid>"}"
        echo ==== "OOM SCORE (TO BE KILLED)" ====
        sudo cat /proc/"$pid"/oom_score 2>/dev/null || echo "No OOM score info available"
        echo ==== "OOM SCORE (TO BE ADJUSTED)" ====
        sudo cat /proc/"$pid"/oom_score 2>/dev/null || echo "No OOM adj info available"
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
      alias ls-self='sudo ls -lh /proc/self/exe 2>/dev/null || echo "No self executable info available"'
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
      follow-early-oom-pretty() {
        local interval="${1:-2}"
        _pretty_hdr "earlyoom — verbose reporting (interval: ${interval}s)"
        follow_early_oom_rec "$interval"
        _pretty_ftr
      }

      ## @description Watch memory-hungry processes sorted by RSS with pretty header.
      ## @param $1 {float} interval - Refresh interval in seconds (default: 0.25)
      watch-mem-hogs-pretty() {
        local interval="${1:-0.25}"
        _pretty_hdr "Memory Hogs — top RSS consumers (interval: ${interval}s)"
        watch_mem_hogs "$interval"
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
      alias backup_projects='rsync -aHAXv --progress --checksum \
        --exclude="node_modules/" \
        --exclude="venv/" \
        --exclude=".venv/" \
        --exclude="__pycache__/" \
        --exclude=".gradle/" \
        --exclude=".m2/" \
        --exclude="vendor/" \
        --exclude="target/" \
        --exclude=".next/" \
        --exclude="dist/" \
        --exclude="build/"'
      alias backup-projects='backup_projects'
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
#endregion Filesystem_Utilities

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

    get_group_user() {
      getent group
    }
    alias ls-groups='get_group_user'

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
