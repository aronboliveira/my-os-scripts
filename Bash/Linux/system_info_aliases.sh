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
        local overcommit_mode=$(sudo sysctl vm.overcommit_memory 2>/dev/null || printf "[-] No overcommit_memory info available\n")
        case "$overcommit_mode" in
          *"vm.overcommit_memory = 0"*)
            printf "  → Overcommit mode: Heuristic (0, default)\n"
            ;;
          *"vm.overcommit_memory = 1"*)
            printf "  → Overcommit mode: Always overcommit (1)\n"
            ;;
          *"vm.overcommit_memory = 2"*)
            printf "  → Overcommit mode: Don't overcommit (2)\n"
            ;;
          *)
            printf "  → Overcommit mode: Unknown or not available\n"
            ;;
        esac
        printf "[*] Checking vm.overcommit_ratio (only relevant for mode 2)...\n"
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
        printf "[*] Checking vm.dirty_ratio (unblocked, no flushing threads, R or S alternating state)...\n"
        sudo sysctl vm.dirty_ratio 2>/dev/null || printf "[-] No dirty_ratio info available\n"
        printf "[*] Checking vm.dirty_background_ratio... (asynchronous writing, like flush-*, kworker/u*, jbd, kswapd, etc., OR stuck in D | S state)\n"
        sudo sysctl vm.dirty_background_ratio 2>/dev/null || printf "[-] No dirty_background_ratio info available\n"
      }
      alias ls-sys-vm-dirty-ratios='ls_sys_vm_dirty_ratios'
      alias ls-sys-vm-dirtyness='ls_sys_vm_dirty_ratios'
      ls_sys_kernel_hungs() {
        printf "[*] Checking for kernel hungs (stuck at D state)...\n"
        sudo sysctl kernel.hung_task_timeout_secs 2>/dev/null || printf "[-] No hung task timeout info available\n"
        printf "[*] Checking for warning about hung tasks (limit)...\n"
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
      alias cat-systemd-config='cat-systemd-conf'
      alias ls-systemd-conf='cat-systemd-conf'
      alias ls-systemd-config='cat-systemd-conf'
      alias show-systemd-conf='cat-systemd-conf'
      alias show-systemd-config='cat-systemd-conf'
      ## @description Display /etc/sysctl.conf and all files in /etc/sysctl.d/.
      cat_sysctl_conf() {
        printf "[*] Checking /etc/sysctl.conf...\n"
        sudo cat /etc/sysctl.conf 2>/dev/null || printf "[-] No sysctl.conf file found\n"
        sleep 2
        printf "[*] Checking /etc/sysctl.d/ directory for additional config files...\n"
        sudo find /etc/sysctl.d/ -type f -exec sh -c 'printf "[=== %s ===]\n" "$1"; sleep 1; cat "$1" 2>/dev/null' _ {} \;
      }
      alias cat-sysctl-conf='cat_sysctl_conf'
      alias cat-sysctl-config='cat_sysctl_conf'
      alias ls-sysctl-conf='cat_sysctl_conf'
      alias ls-sysctl-config='cat_sysctl_conf'
      alias show-sysctl-conf='cat_sysctl_conf'
      alias show-sysctl-config='cat_sysctl_conf'
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
      alias cat-gdm3-config='cat-gdm3-conf'
      ## @description Alias for cat-gdm3-conf.
      alias ls-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      alias ls-gdm3-config='ls-gdm3-conf'
      ## @description Alias for cat-gdm3-conf.
      alias show-gdm3-conf='sudo cat /etc/gdm3/custom.conf'
      alias show-gdm3-config='show-gdm3-conf'
      ## @description Show libvirt daemon configuration from /etc/libvirt/libvirtd.conf.
      alias show-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias show-libvirt-config='show-libvirt-conf'
      ## @description Alias for show-libvirt-conf.
      alias ls-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias ls-libvirt-config='ls-libvirt-conf'
      ## @description Alias for show-libvirt-conf.
      alias cat-libvirt-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias cat-libvirt-config='cat-libvirt-conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias show-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias show-libv-config='show-libv-conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias ls-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias ls-libv-config='ls-libv-conf'
      ## @description Alias for show-libvirt-conf (short form).
      alias cat-libv-conf='sudo cat /etc/libvirt/libvirtd.conf'
      alias cat-libv-config='cat-libv-conf'
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
      alias cat-sysctl-config='_cat_sysctl_conf'

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
