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

