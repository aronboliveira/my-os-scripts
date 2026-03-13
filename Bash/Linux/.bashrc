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

    alias install-plasma-backends='sudo apt install -y plasma-discover-backend-flatpak plasma-discover-backend-snap'
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
      mkdir -p "$HOME/.logs"
      local log="$HOME/.logs/powerstat-$(date +%Y-%m-%d_%H-%M-%S).log"
      echo -e "⚡ \033[1;36mRecording power stats for ${duration}s (tick: ${tick}s) → $log\033[0m"
      sudo stdbuf -oL powerstat -Rn "$tick" "$duration" 2>&1 | \
        awk '{
          if (NF >= 2 && $NF ~ /^[0-9.]/) {
            w = $NF
            printf "%-8s %-8s", $1, w
            for (i = 2; i < NF; i++) printf " %-6s", $i
            printf "\n"
          } else { print }
        }' | tee "$log"
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
  #endregion Desktop_Environment

  #region System_Info_Aliases
    #region Kernel_and_OS
      alias cat-grub-boot='sudo cat /boot/grub/grub.cfg'
      alias cat-grub-etc='sudo cat /etc/default/grub'
      alias cat-k-os='sudo cat /proc/sys/kernel/osrelease'
      alias cat-etc-os='sudo cat /etc/os-release'
      alias cat-os-v='sudo cat /proc/version'
      alias cat-linux-v='sudo cat /proc/version'
      alias cat-k-host='sudo cat /proc/sys/kernel/hostname'
      alias cat-cmdline='sudo cat /proc/cmdline'
    #endregion Kernel_and_OS

    #region VM_and_Memory
      alias cat-vm-swap='sudo cat /proc/sys/vm/swappiness'
      alias cat-vm-over-mem='sudo cat /proc/sys/vm/overcommit_memory'
      alias cat-vm-over-ratio='sudo cat /proc/sys/vm/overcommit_ratio'
      alias cat-cpu-inf='sudo cat /proc/cpuinfo'
      alias cat-mem-inf='sudo cat /proc/meminfo'
    #endregion VM_and_Memory

    #region Storage_and_Partitions
      alias cat-partitions='sudo cat /proc/partitions'
      alias cat-fstab='sudo cat /etc/fstab'
    #endregion Storage_and_Partitions

    #region Drivers_and_Modules
      alias cat-nvidia-v='sudo cat /proc/driver/nvidia/version'
      alias stringify-snapd='sudo strings /lib/snapd/snapd'
      alias ls-sys-services='sudo ls /lib/systemd/system/'
      alias ls-mod-dkms='sudo ls "/lib/modules/$(uname -r)/updates/dkms/"'

      ## @description Show OpenGL renderer, version, and direct rendering status.
      alias glx-info='glxinfo 2>/dev/null | grep -E "(OpenGL renderer|OpenGL version|direct rendering)" || echo "glxinfo not available (install mesa-utils)"'
    #endregion Drivers_and_Modules

    #region System_Config_Files
      alias cat-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      alias cat-hosts='sudo cat /etc/hosts'
      alias cat-users='sudo cat /etc/passwd | cut -d: -f1'
      alias cat-ssh-cfg='sudo cat /etc/ssh/sshd_config'
      alias cat-sudoers='sudo cat /etc/sudoers'

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
      alias cat-dpkg-log='sudo cat /var/log/dpkg.log'
      alias cat-sys-log='sudo cat /var/log/syslog'
      alias cat-history-log='sudo cat /var/log/apt/history.log'
      alias cat-term-log='sudo cat /var/log/apt/term.log'

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
      alias ls-apps='sudo ls /usr/share/applications/'
      alias ls-apps-u='ls ~/.local/share/applications/'
      alias ls-icons='sudo ls /usr/share/icons/'
      alias stringify-sign-files='sudo strings "/usr/src/linux-headers-$(uname -r)/scripts/sign-file"'

      ## @description Find system/KDE/Plasma binaries in /usr/bin.
      find_system_kde_bins() {
        find /usr/bin -maxdepth 1 -type f -regextype posix-extended \
          -iregex '.*(system|kde|plasma).*' -print 2>/dev/null | sort
      }
      alias find-system-kde-bins='find_system_kde_bins'
    #endregion Applications_and_Icons

    #region VSCode_and_GTK
      alias cat-gtk4-settings='sudo cat ~/.config/gtk-4.0/settings.ini'
      alias cat-vscode-settings='sudo cat ~/.config/Code/User/settings.json'
      alias cat-vscode-keybindings='sudo cat ~/.config/Code/User/keybindings.json'
      alias cat-vscode-extensions='sudo cat ~/.config/Code/User/extensions.json'
      alias cat-vscode-snippets='sudo cat ~/.config/Code/User/snippets/*'
      alias cat-vscode-sqlite-state='sudo cat ~/.config/Code/User/globalStorage/state.vscdb'
      alias stringify-vscode-logs='sudo find ~/.config/Code/logs -type f -exec strings {} \;'
      alias stringify-recent-xbel='sudo find ~/.local/share/recently-used.xbel -type f -exec strings {} \;'

      ## @description Extract strings from Copilot chat context files.
      stringify_copilot_context() {
        find ~/.config/Code/User/workspaceStorage/*/Github.copilot-chat/chat-session-resources/*/*/ \
          -type f -name "context*" \
          -exec sh -c 'echo "=== $1 ==="; strings "$1" 2>/dev/null' _ {} \; 2>/dev/null
      }
      alias stringify-copilot-context='stringify_copilot_context'

      ## @description Find VS Code GPU process log files.
      alias find-vscode-gpu-logs='find ~/.config/Code/logs/*/ -name "gpu-process.log" -o -name "gpuprocess.log" 2>/dev/null'

      ## @description Show GPU/render/display entries from VS Code shared process log.
      alias cat-vscode-sharedprocess-gpu='cat ~/.config/Code/logs/*/sharedprocess.log 2>/dev/null | grep -i -E "(gpu|render|display|error|warning)"'

      ## @description Show VS Code argv.json (launch flags).
      alias cat-vscode-argv='cat ~/.config/Code/User/argv.json 2>/dev/null || echo "No argv.json found"'

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
    #endregion Pretty_Desktop_Environment
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
      alias mkd='mkdir'
      alias grep='grep --color=auto'
      alias wget-ubuntu-iso='wget https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso'

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
