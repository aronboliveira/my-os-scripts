# Bash Aliases — Publicable

All publicable aliases from `~/.bashrc`, grouped by region.

---

## PUBLICABLE_CODE

### System_Setup

- **`install_protonvpn_deb_13`**: Installs ProtonVPN on Debian 13 systems.
- **`shutdown-now`**: Kills all common apps and immediately powers off.
- **`shutdown_now`**: Alias variant for shutdown-now.
- **`schedule-kill-sequence`**: Schedules a process kill at a specific time.
- **`wait-sync-and-terminate`**: Monitors rsync/find processes; upon completion, kills apps and powers off.
- **`set-ps-critical`**: Sets OOM score adjustment for a process to critical (-1000).
- **`set-ps-very-important`**: Sets OOM score adjustment to very important (-800).
- **`set-ps-important`**: Sets OOM score adjustment to important (-500).
- **`set-ps-normal`**: Sets OOM score adjustment to normal (0).
- **`set-ps-low`**: Sets OOM score adjustment to low (300).
- **`set-ps-very-low`**: Sets OOM score adjustment to very low (600).
- **`set-ps-irrelevant`**: Sets OOM score adjustment to irrelevant (1000).

- **`install_stremio_gnome`**: Downloads and installs Flathub repo (if missing) and then installs Stremio launching it in background mode, ensuring compatibility for both Wayland and X11 sessions.

[Enable software GL rendering (Mesa llvmpipe), persist to bashrc, optionally disable X11 compositing — flags: --no-persist, --no-composite]

- setup-software-gl

[List all environment variables (env), sorted alphabetically]

- show-all-env-vars

[List all exported variables (printenv), sorted alphabetically]

- show-all-printenv-vars

[List all shell variables (set -o posix; set), sorted alphabetically]

- show-all-sh-vars

[Show current display session type (x11 or wayland)]

- show-display-session

[Show current desktop session name]

- show-desktop-session

[Show the active display manager service unit name via systemctl]

- show-display-manager

[Show the default display manager binary from /etc/X11/default-display-manager]

- show-display-manager-x11

[Show the current desktop environment identifier ($XDG_CURRENT_DESKTOP)]

- show-current-de

[Detect active display manager and show its greeter config (supports LightDM, GDM3, SDDM, LXDM, XDM, SLiM)]

- show-greeter

[Show SDDM KDE settings from /etc/sddm.conf.d/kde_settings.conf]

- cat-kde-settings

[Show GDM3 main config from /etc/gdm3/gdm3.conf]

- cat-gdm3-conf

[Show GDM3 daemon config from /etc/gdm3/daemon.conf]

- cat-gdm3-daemon

[Show GDM3 custom config from /etc/gdm3/custom.conf]

- cat-gdm3-custom

[Install wmctrl if missing and show window manager info via wmctrl -m]

- show-win-mng-m

[Detect running window manager by scanning process list against 50+ known X11/Wayland WMs]

- show-win-mng

[Show running screen compositor processes (picom, compton, kwin, mutter, xfwm, wayfire)]

- show-screen-compositor

[Show running screen locker processes (xscreensaver, light-locker, swaylock, i3lock)]

- show-screen-locker

[List installed GUI toolkit runtime libraries (GTK and Qt, excluding -dev packages)]

- show-installed-tks

[Install plasma-discover Flatpak and Snap backends]

- install-plasma-backends

[Show XDG data directories path list ($XDG_DATA_DIRS)]

- show-datadirs-session

[Show host machine type (e.g., x86_64)]

- show-hosttype

[Show current user's home directory path]

- show-home

[Show current username]

- show-user

[Show current shell binary path]

- show-shell

[Show current working directory (alias for pwd)]

- show-wrkdir

[Show display server type code (x11 or wayland)]

- show-display-server-code

[Show human-readable display server info]

- show-display-server

[Show D-Bus session bus address]

- show-dbus-addr

[Show current desktop environment identifier (alias for show-current-de)]

- show-desktop-env

[Show verbose greeter/display-manager configuration]

- show-greeter-verbose

[Show comprehensive display environment info (session, DM, greeter, compositor, WM)]

- show-full-display-info

[Show compact desktop environment summary]

- show-desktop

[ls- alias variant for show-all-env-vars]

- ls-all-env-vars

[ls- alias variant for show-all-printenv-vars]

- ls-all-printenv-vars

[ls- alias variant for show-all-sh-vars]

- ls-all-sh-vars

[ls- alias variant for show-display-session]

- ls-display-session

[echo- alias variant for show-display-session]

- echo-display-session

[ls- alias variant for show-desktop-session]

- ls-desktop-session

[echo- alias variant for show-desktop-session]

- echo-desktop-session

[ls- alias variant for show-display-manager]

- ls-display-manager

[ls- alias variant for show-display-manager-x11]

- ls-display-manager-x11

[ls- alias variant for show-current-de]

- ls-current-de

[echo- alias variant for show-current-de]

- echo-current-de

[ls- alias variant for show-greeter]

- ls-greeter

[echo- alias variant for show-greeter]

- echo-greeter

[ls- alias variant for show-win-mng-m]

- ls-win-mng-m

[echo- alias variant for show-win-mng-m]

- echo-win-mng-m

[ls- alias variant for show-win-mng]

- ls-win-mng

[ls- alias variant for show-screen-compositor]

- ls-screen-compositor

[ls- alias variant for show-screen-locker]

- ls-screen-locker

[ls- alias variant for show-installed-tks]

- ls-installed-tks

[ls- alias variant for show-datadirs-session]

- ls-datadirs-session

[echo- alias variant for show-datadirs-session]

- echo-datadirs-session

[ls- alias variant for show-hosttype]

- ls-hosttype

[echo- alias variant for show-hosttype]

- echo-hosttype

[ls- alias variant for show-home]

- ls-home

[echo- alias variant for show-home]

- echo-home

[ls- alias variant for show-user]

- ls-user

[echo- alias variant for show-user]

- echo-user

[ls- alias variant for show-shell]

- ls-shell

[echo- alias variant for show-shell]

- echo-shell

[ls- alias variant for show-wrkdir]

- ls-wrkdir

[echo- alias variant for show-wrkdir]

- echo-wrkdir

[ls- alias variant for show-display-server-code]

- ls-display-server-code

[echo- alias variant for show-display-server-code]

- echo-display-server-code

[ls- alias variant for show-display-server]

- ls-display-server

[echo- alias variant for show-display-server]

- echo-display-server

[ls- alias variant for show-dbus-addr]

- ls-dbus-addr

[echo- alias variant for show-dbus-addr]

- echo-dbus-addr

[ls- alias variant for show-desktop-env]

- ls-desktop-env

[echo- alias variant for show-desktop-env]

- echo-desktop-env

[ls- alias variant for show-greeter-verbose]

- ls-greeter-verbose

[echo- alias variant for show-greeter-verbose]

- echo-greeter-verbose

[ls- alias variant for show-full-display-info]

- ls-full-display-info

[echo- alias variant for show-full-display-info]

- echo-full-display-info

[ls- alias variant for show-desktop]

- ls-desktop

[echo- alias variant for show-desktop]

- echo-desktop

### Network_Procedures

[Probe a network host with ARP, ping, netcat, and route lookup — $1: target IP (required), $2: target port (optional) — flags: --gateway, --local]

- net-probe

[Run powerstat (RAPL) and tee output to ~/.logs/ — $1: duration in seconds (default: 3600), $2: sampling interval in seconds (default: 1)]

- track-power-usage

### User_Management

- **`ls-sudoers`**: Alias for cat-sudoers.
- **`show-sudoers`**: Alias for cat-sudoers.
- **`ls-sudoers-timestamp`**: Alias for cat-sudoers-timestamp.
- **`show-sudoers-timestamp`**: Alias for cat-sudoers-timestamp.

[Create a new user and add them to the sudo group — $1: username (required)]

- add-sudo-user

[Display sudoers file content (requires permissions)]

- cat-sudoers

[Show sudoers timestamp_timeout setting]

- cat-sudoers-timestamp

### Desktop_Environment

- **`ls-kde-settings`**: Alias for cat-kde-settings.
- **`show-kde-settings`**: Alias for cat-kde-settings.
- **`ls-gdm3-conf`**: Alias for cat-gdm3-conf.
- **`show-gdm3-conf`**: Alias for cat-gdm3-conf.
- **`ls-gdm3-daemon`**: Alias for cat-gdm3-daemon.
- **`show-gdm3-daemon`**: Alias for cat-gdm3-daemon.
- **`ls-gdm3-custom`**: Alias for cat-gdm3-custom.
- **`show-gdm3-custom`**: Alias for cat-gdm3-custom.
- **`show-window-manager`**: Shows current window manager.
- **`ls-window-manager`**: Shows current window manager.
- **`apply-gtk-dark`**: Applies dark theme for GTK4/GTK3.
- **`fix-gtk-dark`**: Alias for apply-gtk-dark.
- **`check-gtk-dark`**: Checks current GTK dark theme status.
- **`install-portal-dark-autostart`**: Installs GNOME autostart entry to restart xdg-desktop-portals for dark-mode.
- **`check-portal-dark-autostart`**: Shows current portal dark autostart entry without modifying.
- **`remove-portal-dark-autostart`**: Removes the portal dark autostart entry.
- **`dbus-asses-desktop-portal`**: Introspects the D-Bus Desktop Portal.
- **`dbus-asses-xdg-desktop-portal`**: Reads XDG Desktop Portal color scheme setting.

[Purge Cinnamon DE and its config files, reconfigure GDM3 — flags: --keep-config]

- remove-cinnamon

[Set Nautilus as default file manager, update XFCE helpers and MIME cache]

- set-nautilus-default

[Hide Thunar from MIME associations via user-level desktop override]

- hide-thunar-mime

[List running compositor/window manager processes (gnome-shell, xfwm4, mutter, kwin)]

- ps-compositors

[Show Mutter experimental features via gsettings]

- get-mutter-features

[Reset Mutter experimental features to empty array (with confirmation)]

- reset-mutter-features

[Show root window geometry (width, height, depth) via xwininfo]

- xwin-root-info

[List connected monitors via xrandr]

- ls-monitors

[Check availability of DE-related programs (KDE/GNOME/XFCE system monitors, Discover, etc.)]

- check-de-programs

[Mark a .desktop file as trusted for GNOME/DING — $1: filename or path]

- trust-desktop

[Install essential KDE packages for GTK integration and productivity (configs, Discover backends, KDE Connect, Dolphin plugins, Okular)]

- install-kde-pkgs

[Ensure ~/Templates directory and "Empty File" template exist]

- ensure-templates

[Install Nautilus extensions (nautilus-admin, gnome-terminal, image-converter) and ensure Templates directory]

- install-nautilus-ext

[Create a Nautilus script for creating new files via Zenity dialog]

- create-nautilus-newfile

[Show recent journal entries related to screen recording, PipeWire, and desktop portals — $1: tail lines (default: 50)]

- show-journal-screens

[ls- alias variant for show-journal-screens]

- ls-journal-screens

[echo- alias variant for show-journal-screens]

- echo-journal-screens

[Set the default GNOME application for a MIME type via xdg-mime default — $1: app name (e.g., Nautilus), $2: MIME type (e.g., inode/directory)]

- def-org-gnome-xmime

[Query the default application for a MIME type via xdg-mime query default — $1: MIME type]

- get-org-gnome-xmime

[Set the default GNOME application for a MIME type (alias for def-org-gnome-xmime) — $1: app name, $2: MIME type]

- set-org-gnome-xmime

[Reset a GNOME gsettings key to its default value via gsettings reset — $1: schema suffix (e.g., desktop.interface), $2: key name]

- def-org-gnome-gset

[Get a GNOME gsettings value via gsettings get — $1: schema suffix (e.g., desktop.interface), $2: key name]

- get-org-gnome-gset

[Set a GNOME gsettings value with schema/key/value validation — $1: schema suffix, $2: key name, $3: value]

- set-org-gnome-gset

### System_Info_Aliases

#### Kernel_and_OS

- **`ls-grub-boot`**: Alias for cat-grub-boot.
- **`show-grub-boot`**: Alias for cat-grub-boot.
- **`ls-grub-etc`**: Alias for cat-grub-etc.
- **`show-grub-etc`**: Alias for cat-grub-etc.
- **`ls-k-os`**: Alias for cat-k-os.
- **`show-k-os`**: Alias for cat-k-os.
- **`ls-etc-os`**: Alias for cat-etc-os.
- **`show-etc-os`**: Alias for cat-etc-os.
- **`ls-os-v`**: Alias for cat-os-v.
- **`show-os-v`**: Alias for cat-os-v.
- **`ls-linux-v`**: Alias for cat-linux-v.
- **`show-linux-v`**: Alias for cat-linux-v.
- **`ls-distro-n`**: Alias for cat-distro-n.
- **`show-distro-n`**: Alias for cat-distro-n.
- **`ls-distro-v`**: Alias for cat-distro-v.
- **`show-distro-v`**: Alias for cat-distro-v.
- **`ls-distro`**: Alias for cat-distro.
- **`show-distro`**: Alias for cat-distro.
- **`ls-k-host`**: Alias for cat-k-host.
- **`show-k-host`**: Alias for cat-k-host.
- **`ls-cmdline`**: Alias for cat-cmdline.
- **`show-cmdline`**: Alias for cat-cmdline.
- **`ls-mimeapps`**: Alias for cat-mimeapps.
- **`show-mimeapps`**: Alias for cat-mimeapps.
- **`ls-share-mimeapps`**: Alias for cat-share-mimeapps.
- **`show-share-mimeapps`**: Alias for cat-share-mimeapps.
- **`ls-all-mimeapps`**: Alias for cat-all-mimeapps.
- **`show-all-mimeapps`**: Alias for cat-all-mimeapps.
- **`ls-share-mimecache`**: Alias for cat-share-mimecache.
- **`show-share-mimecache`**: Alias for cat-share-mimecache.

- **`cat-mimeapps`**: Displays the user's default applications list and MIME configurations (`~/.config/mimeapps.list`).
- **`cat-share-mimeapps`**: Displays system-wide MIME configurations list installed under user or system applications (`~/.local/share/applications/mimeapps.list`).
- **`cat-all-mimeapps`**: Tries reading all major known locations for MIME config.
- **`cat-share-mimecache`**: Reads the compiled MIME cache to understand database mapping.

[Show GRUB boot configuration from /boot/grub/grub.cfg]

- cat-grub-boot

[Show GRUB defaults from /etc/default/grub]

- cat-grub-etc

[Show kernel OS release from /proc/sys/kernel/osrelease]

- cat-k-os

[Show OS release info from /etc/os-release]

- cat-etc-os

[Show kernel version from /proc/version]

- cat-os-v

[Show Linux version from /proc/version]

- cat-linux-v

[Show distro ID (debian, ubuntu, fedora, etc.)]

- cat-distro-n

[Show distro version number]

- cat-distro-v

[Show full distro name with version]

- cat-distro

[Show kernel hostname from /proc/sys/kernel/hostname]

- cat-k-host

[Show kernel command line from /proc/cmdline]

- cat-cmdline

#### VM_and_Memory

- **`ls-vm-swap`**: Alias for cat-vm-swap.
- **`show-vm-swap`**: Alias for cat-vm-swap.
- **`ls-vm-over-mem`**: Alias for cat-vm-over-mem.
- **`show-vm-over-mem`**: Alias for cat-vm-over-mem.
- **`ls-vm-over-ratio`**: Alias for cat-vm-over-ratio.
- **`show-vm-over-ratio`**: Alias for cat-vm-over-ratio.
- **`ls-cpu-inf`**: Alias for cat-cpu-inf.
- **`show-cpu-inf`**: Alias for cat-cpu-inf.
- **`ls-mem-inf`**: Alias for cat-mem-inf.
- **`show-mem-inf`**: Alias for cat-mem-inf.
- **`ls-oom-conf`**: Alias for cat-oom-conf.
- **`show-oom-conf`**: Alias for cat-oom-conf.

[Show VM swappiness value from /proc/sys/vm/swappiness]

- cat-vm-swap

[Show VM overcommit memory mode from /proc/sys/vm/overcommit_memory]

- cat-vm-over-mem

[Show VM overcommit ratio from /proc/sys/vm/overcommit_ratio]

- cat-vm-over-ratio

[Show CPU information from /proc/cpuinfo]

- cat-cpu-inf

[Show memory information from /proc/meminfo]

- cat-mem-inf

[Show systemd OOM daemon configuration from /etc/systemd/oomd.conf]

- cat-oom-conf

[Show the vm.oom_kill_allocating_task sysctl value (0=kill random, 1=kill allocating task)]

- show-oom-kill-alloc

[ls- alias variant for show-oom-kill-alloc]

- ls-oom-kill-alloc

[Follow earlyoom daemon output with verbose reporting at a set interval — $1: interval in seconds (default: 2)]

- follow-early-oom-rec
- watch-early-oom-rec
- follow-early-oom
- watch-early-oom

[Watch memory-hungry processes sorted by RSS in real time — $1: refresh interval in seconds (default: 0.25)]

- watch-mem-hogs

[Watch CPU-hungry processes sorted by CPU usage in real time — $1: refresh interval in seconds (default: 0.25)]

- watch-cpu-hogs

[List zombie processes (state Z) from ps aux output — $1: max number of results (default: 20)]

- find-zombies

[Show the OOM kill score for a process — $1: pid (required)]

- cat-pid-oom-kill-score

[Follow (watch) the OOM kill score for a process in real time — $1: pid (required)]

- follow-pid-oom-kill-score
- watch-pid-oom-kill-score

[Show the OOM adjustment score for a process (-1000 to 1000) — $1: pid (required)]

- cat-pid-oom-adj-score

[Show both OOM kill score and adjustment score for a process — $1: pid (required)]

- cat-pid-oom-scores

[Follow the earlyoom systemd journal]

- journal-earlyoom

[Follow the systemd-oomd journal]

- journal-sysoomd

#### Storage_and_Partitions

- **`ls-partitions`**: Alias for cat-partitions.
- **`show-partitions`**: Alias for cat-partitions.
- **`ls-fstab`**: Alias for cat-fstab.
- **`show-fstab`**: Alias for cat-fstab.

[Show partition table from /proc/partitions]

- cat-partitions

[Show filesystem table from /etc/fstab]

- cat-fstab

#### Drivers_and_Modules

- **`ls-nvidia-v`**: Alias for cat-nvidia-v.
- **`show-nvidia-v`**: Alias for cat-nvidia-v.

[Show NVIDIA driver version from /proc/driver/nvidia/version]

- cat-nvidia-v

[Extract strings from /lib/snapd/snapd binary]

- stringify-snapd

[List systemd service unit files in /lib/systemd/system/]

- ls-sys-services

[List DKMS kernel modules for current kernel]

- ls-mod-dkms

[Show OpenGL renderer, version, and direct rendering status via glxinfo]

- glx-info

#### System_Config_Files

- **`ls-hosts`**: Alias for cat-hosts.
- **`show-hosts`**: Alias for cat-hosts.
- **`ls-ssh-cfg`**: Alias for cat-ssh-cfg.
- **`show-ssh-cfg`**: Alias for cat-ssh-cfg.
- **`ls-ssh-service`**: Alias for cat-ssh-service.
- **`show-ssh-service`**: Alias for cat-ssh-service.

[Show GDM3 configuration from /etc/gdm3/custom.conf]

- cat-gdm3-conf

[Show hosts file from /etc/hosts]

- cat-hosts

[List system usernames from /etc/passwd]

- cat-users

[Show SSH server configuration from /etc/ssh/sshd_config]

- cat-ssh-cfg

[Show the SSH systemd service unit file]

- cat-ssh-service

[Show sudoers file from /etc/sudoers]

- cat-sudoers

[Show all sysctl config files from /etc/sysctl.d/]

- cat-sysctl-conf

[Show all SSH host key files from /etc/ssh/]

- cat-ssh-hosts

[Show all APT source list files from /etc/apt/sources.list.d/]

- cat-src-lists

[List system users with description field (username:gecos) from /etc/passwd]

- cat-users-verbose

[Show all modprobe config files from /etc/modprobe.d/]

- cat-modeprobe-confs

#### Logs_and_Crashes

- **`ls-var-locks`**: Alias for cat-var-locks.
- **`show-var-locks`**: Alias for cat-var-locks.
- **`ls-dpkg-log`**: Alias for cat-dpkg-log.
- **`show-dpkg-log`**: Alias for cat-dpkg-log.
- **`ls-sys-log`**: Alias for cat-sys-log.
- **`show-sys-log`**: Alias for cat-sys-log.
- **`ls-history-log`**: Alias for cat-history-log.
- **`show-history-log`**: Alias for cat-history-log.
- **`ls-term-log`**: Alias for cat-term-log.
- **`show-term-log`**: Alias for cat-term-log.

[Extract strings from crash files in /var/crash/ (excluding opt and most usr_bin crashes)]

- stringify-crashes

[Extract strings from APT package cache binary]

- stringify-pkgcache

[Extract strings from APT source package cache binary]

- stringify-srcpkgcache

[List APT archive lock files in /var/cache/apt/archives/]

- cat-var-locks

[Show dpkg log from /var/log/dpkg.log]

- cat-dpkg-log

[Show system log from /var/log/syslog]

- cat-sys-log

[Show APT history log from /var/log/apt/history.log]

- cat-history-log

[Show APT terminal log from /var/log/apt/term.log]

- cat-term-log

[Extract strings from Xorg log files in /var/log/]

- stringify-xorg-logs

[Show GPU/display/compositor errors from current boot journal — $1: number of lines to scan (default: 200)]

- journal-gpu-errors

[Show GNOME Shell errors from user journal — $1: number of lines to scan (default: 100)]

- journal-gnome-errors

[List xsession error files and Xorg log directory]

- ls-xsession-errors

[Grep Xorg.0.log for errors (EE) and warnings (WW)]

- grep-xorg-errors

[Extract crash-relevant strings (segfault, sigsegv, GPU, etc.) from VS Code crash file]

- stringify-vscode-crash

#### Applications_and_Icons

[List system .desktop application files in /usr/share/applications/]

- ls-apps

[List user .desktop application files in ~/.local/share/applications/]

- ls-apps-u

[List icon themes in /usr/share/icons/]

- ls-icons

[Extract strings from kernel headers sign-file script]

- stringify-sign-files

[Find system/KDE/Plasma binaries in /usr/bin]

- find-system-kde-bins

[Search for a specific flag or option in a command's man page — $1: command (default: ls), $2: 0=flag 1=option (default: 0), $3: flag/option name (default: l)]

- man-fopt

[Extract printable strings from the current shell's own executable (/proc/self/exe)]

- stringify-self

[List details of the current shell's executable symlink (/proc/self/exe)]

- ls-self

#### VSCode_and_GTK

- **`ls-gtk4-settings`**: Alias for cat-gtk4-settings.
- **`show-gtk4-settings`**: Alias for cat-gtk4-settings.
- **`ls-vscode-settings`**: Alias for cat-vscode-settings.
- **`show-vscode-settings`**: Alias for cat-vscode-settings.
- **`ls-vscode-keybindings`**: Alias for cat-vscode-keybindings.
- **`show-vscode-keybindings`**: Alias for cat-vscode-keybindings.
- **`ls-vscode-extensions`**: Alias for cat-vscode-extensions.
- **`show-vscode-extensions`**: Alias for cat-vscode-extensions.
- **`ls-vscode-snippets`**: Alias for cat-vscode-snippets.
- **`show-vscode-snippets`**: Alias for cat-vscode-snippets.
- **`ls-vscode-sqlite-state`**: Alias for cat-vscode-sqlite-state.
- **`show-vscode-sqlite-state`**: Alias for cat-vscode-sqlite-state.
- **`ls-vscode-sharedprocess-gpu`**: Alias for cat-vscode-sharedprocess-gpu.
- **`show-vscode-sharedprocess-gpu`**: Alias for cat-vscode-sharedprocess-gpu.
- **`ls-vscode-argv`**: Alias for cat-vscode-argv.
- **`show-vscode-argv`**: Alias for cat-vscode-argv.

[Show GTK4 settings from ~/.config/gtk-4.0/settings.ini]

- cat-gtk4-settings

[Show VS Code settings.json]

- cat-vscode-settings

[Show VS Code keybindings.json]

- cat-vscode-keybindings

[Show VS Code extensions.json]

- cat-vscode-extensions

[Show VS Code user snippets]

- cat-vscode-snippets

[Show VS Code SQLite state database (binary)]

- cat-vscode-sqlite-state

[Extract strings from all VS Code log files]

- stringify-vscode-logs

[Extract strings from recently-used.xbel file]

- stringify-recent-xbel

[Extract strings from GitHub Copilot chat context files]

- stringify-copilot-context

[List unique workspaceStorage files (potentially containing chat context, logs, etc.).]

- find-all-vscode-workspace-files

[Find VS Code GPU process log files]

- find-vscode-gpu-logs

[Show GPU/render/display entries from VS Code shared process log]

- cat-vscode-sharedprocess-gpu

[Show VS Code argv.json launch flags]

- cat-vscode-argv

[Disable GPU in VS Code argv.json by adding disable-gpu flags (with backup)]

- vscode-disable-gpu

### Pretty_Aliases

#### Pretty_Kernel_OS

- **`cat-mimeapps-pretty`**: Formatted output.

[Pretty-print GRUB boot config with line numbers and syntax coloring]

- cat-grub-boot-pretty

[Pretty-print GRUB defaults with line numbers and syntax coloring]

- cat-grub-etc-pretty

[Pretty-print kernel OS release with header/footer]

- cat-k-os-pretty

[Pretty-print OS release info with highlighted keys]

- cat-etc-os-pretty

[Pretty-print kernel version with header/footer]

- cat-os-v-pretty

[Pretty-print Linux version with header/footer]

- cat-linux-v-pretty

[Pretty-print kernel hostname with header/footer]

- cat-k-host-pretty

[Pretty-print kernel command line, one argument per line]

- cat-cmdline-pretty

#### Pretty_VM_Memory

[Pretty-print VM swappiness value with label]

- cat-vm-swap-pretty

[Pretty-print VM overcommit memory mode with explanation]

- cat-vm-over-mem-pretty

[Pretty-print VM overcommit ratio percentage]

- cat-vm-over-ratio-pretty

[Pretty-print CPU information with highlighted field names]

- cat-cpu-inf-pretty

[Pretty-print memory information with highlighted field names]

- cat-mem-inf-pretty

[Pretty-print systemd OOM daemon configuration]

- cat-oom-conf-pretty

[Pretty-print vm.oom_kill_allocating_task sysctl value with explanation]

- show-oom-kill-alloc-pretty

[Follow earlyoom daemon output with pretty header — $1: interval in seconds (default: 2)]

- follow-early-oom-pretty

[Watch memory-hungry processes sorted by RSS with pretty header — $1: refresh interval in seconds (default: 0.25)]

- watch-mem-hogs-pretty

[Watch CPU-hungry processes sorted by CPU usage with pretty header — $1: refresh interval in seconds (default: 0.25)]

- watch-cpu-hogs-pretty

[List zombie processes with pretty header — $1: max number of results (default: 20)]

- find-zombies-pretty

[Pretty-print OOM kill score for a process — $1: pid (required)]

- cat-pid-oom-kill-score-pretty

[Pretty-print earlyoom output with formatted header — $1: interval in seconds (default: 2)]

- follow-early-oom-pretty
- watch-early-oom-pretty

[Pretty-print OOM adjustment score for a process — $1: pid (required)]

- cat-pid-oom-adj-score-pretty

[Pretty-print both OOM scores for a process — $1: pid (required)]

- cat-pid-oom-scores-pretty

[Pretty-print earlyoom systemd journal]

- journal-earlyoom-pretty

[Pretty-print systemd-oomd journal]

- journal-sysoomd-pretty

#### Pretty_Storage

[Pretty-print partitions with header row underline]

- cat-partitions-pretty

[Pretty-print filesystem table with line numbers]

- cat-fstab-pretty

#### Pretty_Drivers_Modules

[Pretty-print NVIDIA driver version with line numbers]

- cat-nvidia-v-pretty

[Pretty-print snapd strings (first 200 lines)]

- stringify-snapd-pretty

[Pretty-list systemd services with color-coded types (service/timer/socket)]

- ls-sys-services-pretty

[Pretty-list DKMS modules with size details]

- ls-mod-dkms-pretty

[Pretty-print modprobe config files with per-file headers]

- cat-modeprobe-confs-pretty

[Pretty-print OpenGL/GLX information with color-coded renderer and direct rendering status]

- glx-info-pretty

#### Pretty_System_Config

- **`cat-compose-chars-pretty`**: Formatted output.

[Pretty-print GDM3 configuration with line numbers]

- cat-gdm3-conf-pretty

[Pretty-print hosts file with highlighted IP addresses]

- cat-hosts-pretty

[Pretty-print system usernames sorted in columns with root highlighted]

- cat-users-pretty

[Pretty-print users with descriptions in two-column format]

- cat-users-verbose-pretty

[Pretty-print SSH server config with line numbers]

- cat-ssh-cfg-pretty

[Pretty-print sudoers file with line numbers]

- cat-sudoers-pretty

[Pretty-print sysctl config files with per-file headers]

- cat-sysctl-conf-pretty

[Pretty-print SSH host key files with per-file headers]

- cat-ssh-hosts-pretty

[Pretty-print APT source list files with per-file headers]

- cat-src-lists-pretty

#### Pretty_Logs

[Pretty-print crash file strings with per-file headers (first 50 lines each)]

- stringify-crashes-pretty

[Pretty-print package cache strings (first 200 lines)]

- stringify-pkgcache-pretty

[Pretty-print source package cache strings (first 200 lines)]

- stringify-srcpkgcache-pretty

[Pretty-print APT archive lock with lock icon]

- cat-var-locks-pretty

[Pretty-print dpkg log (last 100 lines) with color-coded install/remove/upgrade]

- cat-dpkg-log-pretty

[Pretty-print system log (last 100 lines) with color-coded errors and warnings]

- cat-sys-log-pretty

[Pretty-print APT history log with color-coded Start-Date/End-Date/Commandline]

- cat-history-log-pretty

[Pretty-print APT terminal log (last 200 lines)]

- cat-term-log-pretty

[Pretty-print Xorg log strings with per-file headers (last 40 lines each)]

- stringify-xorg-logs-pretty

[Pretty-print GPU/display errors from journal with color-coded severity — $1: lines (default: 200)]

- journal-gpu-errors-pretty

[Pretty-print GNOME Shell errors with color-coded severity — $1: lines (default: 100)]

- journal-gnome-errors-pretty

[Pretty-list xsession error files with file icons]

- ls-xsession-errors-pretty

[Pretty-print Xorg errors (EE) and warnings (WW) with color coding]

- grep-xorg-errors-pretty

[Pretty-print VS Code crash analysis with color-coded signal names]

- stringify-vscode-crash-pretty

#### Pretty_Apps_Icons

[Pretty-list system applications with colored .desktop suffix]

- ls-apps-pretty

[Pretty-list user applications with colored .desktop suffix]

- ls-apps-u-pretty

[Pretty-list icon themes in columns]

- ls-icons-pretty

[Pretty-print sign-file strings (first 100 lines)]

- stringify-sign-files-pretty

[Pretty-list system/KDE/Plasma binaries with color-coded categories]

- find-system-kde-bins-pretty

[Pretty-print man page flag/option search results with banner]

- man-fopt-pretty

[Pretty-print strings from /proc/self/exe (first 80 lines)]

- stringify-self-pretty

[Pretty-print shell executable details with colored output]

- ls-self-pretty

#### Pretty_VSCode_GTK

[Pretty-print GTK4 settings with line numbers]

- cat-gtk4-settings-pretty

[Pretty-print VS Code settings.json (formatted via python3)]

- cat-vscode-settings-pretty

[Pretty-print VS Code keybindings.json (formatted via python3)]

- cat-vscode-keybindings-pretty

[Pretty-print VS Code extensions.json (formatted via python3)]

- cat-vscode-extensions-pretty

[Pretty-print VS Code snippets with per-file headers]

- cat-vscode-snippets-pretty

[Pretty-print VS Code state DB strings (first 100 extracted strings)]

- cat-vscode-sqlite-state-pretty

[Pretty-print VS Code log files with per-file headers]

- stringify-vscode-logs-pretty

[Pretty-print recent files from xbel, extracting file:// hrefs]

- stringify-recent-xbel-pretty

[Pretty-print Copilot chat context files (first 30 lines each)]

- stringify-copilot-context-pretty

[Pretty-print VS Code GPU process logs (last 20 lines each)]

- find-vscode-gpu-logs-pretty

[Pretty-print VS Code shared process GPU/render entries with color-coded severity]

- cat-vscode-sharedprocess-gpu-pretty

[Pretty-print VS Code argv.json launch flags (formatted via python3)]

- cat-vscode-argv-pretty

#### Pretty_Desktop_Environment

[Pretty-list running compositors/window managers with PID]

- ps-compositors-pretty

[Pretty-print Mutter experimental features value]

- get-mutter-features-pretty

[Pretty-print root window geometry with monitor icon]

- xwin-root-info-pretty

[Pretty-list connected monitors with indexed entries]

- ls-monitors-pretty

[Pretty-check DE-related programs with checkmark/cross status]

- check-de-programs-pretty

[Pretty-print display session type with header]

- show-display-session-pretty

[Pretty-print desktop session name with header]

- show-desktop-session-pretty

[Pretty-print display manager service name with header]

- show-display-manager-pretty

[Pretty-print display manager binary path from X11 config]

- show-display-manager-x11-pretty

[Pretty-print current desktop environment with header]

- show-current-de-pretty

[Pretty-print greeter configuration with DM detection and per-section headers]

- show-greeter-pretty

[Pretty-print SDDM KDE settings with colored section headers and keys]

- cat-kde-settings-pretty

[Pretty-print GDM3 main config with colored section headers and keys]

- cat-gdm3-conf-pretty

[Pretty-print GDM3 daemon config with colored section headers and keys]

- cat-gdm3-daemon-pretty

[Pretty-print GDM3 custom config with colored section headers and keys]

- cat-gdm3-custom-pretty

[Pretty-print wmctrl window manager info with colored fields]

- show-win-mng-m-pretty

[Pretty-print detected window manager(s) with indicator arrows]

- show-win-mng-pretty

[Pretty-print running screen compositors with PID]

- show-screen-compositor-pretty

[Pretty-print running screen lockers with PID]

- show-screen-locker-pretty

[Pretty-print installed GTK/Qt runtime libraries with version columns]

- show-installed-tks-pretty

[Pretty-print journal entries related to screen recording and desktop portals with color-coded errors/warnings]

- show-journal-screens-pretty

#### Pretty_System_Setup

[Pretty-print all environment variables with header and numbered lines]

- show-all-env-vars-pretty

[Pretty-print all exported variables with header and numbered lines]

- show-all-printenv-vars-pretty

[Pretty-print all shell variables with header and numbered lines]

- show-all-sh-vars-pretty

#### Pretty_System_Config

[Pretty-print SSH systemd service unit file with header and numbered lines]

- cat-ssh-service-pretty

#### Pretty_Basic_Commands

[Pretty-open GNOME Text Editor with header message]

- gted-pretty

[Pretty-decode a URI string showing input and decoded output]

- uri-decode-pretty

[Pretty-print printf-tr result with formatted header]

- printf-tr-pretty

[Pretty-list files by index with optional file content display]

- cat-indexed-pretty

[Pretty-run multiple commands against a target with formatted output per command]

- run-cmds-pretty

#### Pretty_HTML_CSS_Tools

[Pretty-strip HTML comments showing before/after count]

- strip-html-comments-pretty

[Pretty-extract and minify CSS with byte-size comparison]

- extract-min-css-pretty

[Pretty-count HTML comments and lines in a file]

- count-html-comments-pretty

[Pretty-check CSS minifier availability with checkmark/cross status]

- check-css-minifier-pretty

[Pretty-inject minified CSS into HTML with line count comparison]

- inject-min-css-pretty

#### Pretty_Git

[Pretty-print Git work tree info with colored fields]

- git-tree-info-pretty

### Utilities

#### Package_Management

[Remove all disabled snap package revisions]

- prune-snap

[Install Portuguese (pt) language packs with confirmation prompt]

- install-pt-lang-pack

#### Network_Monitoring

[Measure network bandwidth usage between start and Enter keypress (based on Luke Smith script)]

- cat-band

[Like cat-band but tee the bandwidth result to a timestamped log in ~/.logs/cat-band/]

- cat-band-tee

[Like cat-band-tee but with automatic duration instead of Enter — $1: seconds to track (default: 60)]

- cat-band-tee-d

#### Backup

[Rsync backup with progress/checksum, excluding node_modules, venv, __pycache__, .gradle, .m2, vendor, target, .next, dist, build]

- backup-projects

#### File_Analysis

[Show recently used files from XDG recent files database — $1: search filter pattern (default: ".")]

- ls-rec-files

[Check if a file has multiple consecutive blank lines — $1: file path (required)]

- is-mblank

[List files in current directory that have multiple consecutive blank lines]

- ls-mblank

[List files with name, path, and size]

- list-files

[Check which directories in current dir contain files — flag: -r for recursive]

- contains-files

#### Hardware_Shortcuts

[Check ECC memory support via dmidecode]

- check-ecc

[Shortcut for bluetoothctl]

- btctl

[Shortcut for systemctl]

- stctl

[Shortcut for sudo systemctl]

- su-stctl

[Disconnect all connected Bluetooth devices]

- disconnect-all-bt

#### Basic_Commands

[Shortcut for mkdir]

- mkd

[Grep with automatic color output]

- grep

[Open GNOME Text Editor]

- gted

[Decode a percent-encoded URI string (e.g. %20 → space) — $1: uri (required)]

- uri-decode

[Printf with field-width, delimiter, and tr-based substitution — $1: delimiter, $2: width, $3: type, $4: target (required), $5: pattern (required), $6: substitute (required), $7: tr_from, $8: tr_to]

- printf-tr

[List files with index numbers and display file contents by index — $1: index (default: 1)]

- cat-indexed

[Run multiple commands against a single target argument — $1: target (required), $@: commands]

- run-cmds

[Download Ubuntu 24.04.3 Desktop amd64 ISO]

- wget-ubuntu-iso

[Custom ls output showing time, size, and name columns — $1: path (default: ".")]

- ls-lah-859

[Count total lines in directory excluding vendor, node_modules, and .git folders]

- wc-l-novendors

[List block devices that are not mounted]

- ls-nomount

[Mount NTFS drive with ntfsfix, proper mount options, and add to /etc/fstab — $1: mount destination path (required), $2: block device path (required)]

- mount-recover-ntfs

[Mount /dev/sda2 to /mnt/sda2 (plain ext4)]

- mount-sda2

### Git_Aliases

[Pretty git log showing author email, date, and subject for all branches]

- git-log-pretty

[Show git stats: lines added/removed, project line count, file count, commit counts]

- git-stats

#### Git_Basic

[git remote add]

- gra

[git remote add origin]

- gra-o

[git add]

- ga

[git add .]

- gal

[git commit]

- gc

[git commit -a -m]

- gca

[cd to repo root, then git add . && git commit -am]

- galps

#### Git_Log_Status

[git log]

- gl

[git log --oneline]

- gl-o

[git status]

- gs

[git show]

- gsw

[git reflog]

- grl

[git shortlog]

- gsl

[git check-ignore -v]

- gci

[git ls-remote]

- glr

[git ls-tree]

- glt

[git fsck --lost-found]

- glost

[git fsck --full]

- gfsckf

[git gc --aggressive --prune=now]

- gitgcagro

#### Git_Remote

[git push]

- gps

[git push origin HEAD]

- gps-oh

[git push origin HEAD:main]

- gps-ohm

[git pull]

- gpl

[git fetch]

- gf

#### Git_Branch_Diff

[git diff]

- gd

[git branch]

- gb

[git branch -v]

- gbv

[git switch -c (create new branch)]

- gsc

[git checkout]

- gco

[git rev-parse --show-toplevel (show repo root)]

- gtop

[git merge]

- gm

[git rebase]

- grb

#### Git_Reset_Revert

[git reset]

- grs

[git reset --hard]

- grs-h

[git reset --soft]

- grs-s

[git reset HEAD~1 (undo last commit, keep changes)]

- grs--1

[git reset --hard HEAD~1 (undo last commit, discard changes)]

- grs-h--1

[git reset --soft HEAD~1 (undo last commit, keep staged)]

- grs-s--1

[git reset origin]

- grs--og

[git reset --hard origin]

- grs-h--og

[git reset --soft origin]

- grs-s--og

[git revert]

- grv

[git revert --no-commit]

- grv-nc

[git revert HEAD]

- grv--h

[git revert -m 1 (revert a merge commit, keep first parent)]

- grv-m--1

#### Git_Stash

[git stash]

- gst

[git stash push]

- gst-ps

[git stash push --include-untracked]

- gst-pp-u

[git stash push --all]

- gst-pp-a

[git stash push --keep-index]

- gst-pp-ki

[git stash pop]

- gst-pp

[git stash apply]

- gst-a

[git stash drop]

- gst-d

[git stash list]

- gst-l

[git stash show]

- gst-s

[git stash clear]

- gst-c

[git filter-branch to forcefully remove README.md from entire history]

- gst-filter-rdm

[Show Git work tree info: repo dir, common dir, top level, and superproject status]

- git-tree-info

### Navigation_Aliases

[cd to ~/Desktop]

- desk

[cd to ~/Documents]

- docs

[cd to ~/Downloads]

- dl

[cd up one directory level]

- ..

[cd up two directory levels]

- ...

[cd to _inc/laravel]

- .ilv

### Laravel_PHP_Aliases

[Run php artisan migrate:reset]

- artmrs

[Run php artisan migrate:fresh --seed]

- artmsd

[Run php artisan migrate:status]

- artmst

[Run migrate:status, migrate:reset, then migrate:fresh --seed in sequence]

- artmrs-sd

[Clear all Laravel caches (permissions, config, cache, optimize, route, view, compiled)]

- artcl

[Run php artisan serve]

- artsv

[Full Laravel reset: clear all caches, remove bootstrap cache files, dump autoload, reset & reseed migrations, list routes, then serve]

- artclrs

[Run php artisan route:list --sort=uri]

- artrtl

[Remove Laravel bootstrap cache files (services, packages, compiled, routes)]

- laravel-rm-cache

[Run composer dump-autoload -o]

- compdp

[MySQL login as root with password prompt]

- mysqlr

### Filesystem_Utilities

- **`show-compose-chars`**: Alias for cat-compose-chars.

- **`cat-compose-chars`**: Displays the correct native sequence of Compose keys available under `en_US.UTF-8/Compose`.
- **`ls-compose-chars`**: Lists Compose map details in standard `ls -ld` format.
- **`less-compose-chars`**: Views the long Compose character mapping scheme with `less` pagination.
- **`edit-compose-chars`**: Opens original Compose database dictionary for possible modification resolutions.

[List files with name, path, and size (inline alias version)]

- list-files

[Find directories containing files recursively]

- contains-files--r

[Find directories in current dir containing files]

- contains-files

[Count total lines excluding vendor/node_modules/.git with running total (inline alias version)]

- wc-l-total-novendors

[Find compressed files (7z/rar/zip) with matching extracted files and optionally delete the archives]

- clear-compressed

[Pack all files in current directory into subdirectories of 100 files each]

- packf

[Find and sort files by path length, excluding vendor/node_modules/backup directories — $1: extension (required) $2: src (default: .) $3: max_depth (default: 15) $4: cut_indexes (default: 0)]

- list-paths-no-vendors

---

## POWERSHELL_PROFILE_EQUIVALENTS

### Power_Management

[Suspend/sleep the system via systemctl suspend]

- p-sleep

[Show memory usage summary (free -h)]

- diag-mem

### Quick_Open_Folders

[Open recycle bin (trash://) in the desktop's file manager]

- ls-cbin

[Open Documents folder in the desktop's file manager]

- ls-docs

[Open Desktop folder in the desktop's file manager]

- ls-desk

[Open Pictures folder in the desktop's file manager]

- ls-pics

[Open user fonts folder in the desktop's file manager]

- ls-fonts

### Hardware_Inspection

[List USB devices via lsusb]

- ls-usb-dev

[Show CPU information via lscpu]

- ls-cpu

[List USB controllers via lspci]

- ls-usb

[Show physical memory usage via free -h]

- ls-mem

[List disk drives via lsblk -d]

- ls-disks

[Show logical disk (filesystem) usage via df -h]

- ls-ldisk

[Show battery status via acpi -b]

- ls-batt

[Show power profile settings via powerprofilesctl]

- ls-pwr

[List printers via lpstat]

- ls-prin

[Show GPU/video controller info via lspci]

- ls-gpu

[List connected monitors via xrandr]

- ls-mons

### System_Info

[Show network adapter configuration via nmcli or ip addr]

- ls-net

[Show BIOS information via dmidecode -t bios]

- ls-bios

[Show system journal via journalctl]

- ls-logs

[List all user accounts via getent passwd]

- ls-users

[Show computer/system info via uname -a]

- ls-host

[List all groups via getent group]

- ls-groups

[Show OS information via lsb_release -a or hostnamectl]

- ls-os

[List installed packages via dpkg-query or rpm]

- ls-pkgs

### Hardware_Data_Functions

[Show detailed CPU information via lscpu]

- cpu-info

[Show memory hardware details via dmidecode -t memory]

- ssram-info

[Show storage info: block devices with mount points (lsblk) and filesystem usage (df -h)]

- storage-info

[List USB devices via lsusb]

- usb-info

[Show GPU/video controller info via lspci]

- video-info

[Show PCI devices with kernel driver info via lspci -k]

- pnp-info

[Show OpenGL version string via glxinfo]

- wddm-info

[Show grouped hardware summary via lshw -short]

- lshw

### Services_Network

[List active services via systemctl or service --status-all]

- ls-svc

[List open sockets via ss -tunap]

- ls-sock

[List available WiFi networks via nmcli or iwlist]

- ls-wlan

[Show wireless capabilities via iw list or nmcli]

- ls-wcap

[Show network drivers via lspci -nnk]

- ls-netdrv

### File_Utilities

[Calculate total storage used under a drive/directory path — $1: target path (default: "c:")]

- calc-storage

[Compress current directory into a zip file, excluding node_modules and vendor]

- compdir

[Unzip all archives (zip/7z/rar) found recursively in current directory]

- uz-all

[Delete all compressed files (zip/7z/rar) in current directory]

- del-comp

[Convert snake_case string to PascalCase — $1: input string (required)]

- topascal

[Convert PascalCase/camelCase string to snake_case — $1: input string (required)]

- tosnake

[Sanitize directory names: replace special chars with underscores, lowercase — flag: -r for recursive]

- sanitize-d

[Sanitize file names: replace special chars with underscores, lowercase — flag: -r for recursive]

- sanitize-f

[Sanitize all names (directories then files) interactively — flag: -r for recursive]

- sanitize-a

### Backup_Analysis

[Rsync backup with automatic retry on failure — $1: source (required), $2: destination (required), $3: retry count (default: 3), $4: wait seconds (default: 5)]

- bcp

[Show heaviest folders by size in GB — $1: root path (default: "."), $2: top N results (default: 10)]

- hfold

[Show heaviest files by size in GB — $1: root path (default: "."), $2: top N results (default: 10)]

- hfile

[Show disk usage of immediate children, sorted by size — $1: path (default: ".")]

- du-surface

[Measure file distribution between root folder and a subfolder — $1: root path (required), $2: subdirectory name (required), $3: glob filter (default: "*")]

- mfd

[Interactive file search: prompts for a filename pattern and searches current directory tree]

- sint

[Search files recursively with output format options — $1: path (default: "."), $2: output index 0=full path, 1=name only, 2=stat (default: 1), $3: glob filter (default: "*")]

- rsf

[cd into a directory by numeric index from current dir listing — $1: index (default: 0)]

- cd-i

[Extract all .7z files in a directory — $1: path (default: ".")]

- exp-7z

[Open a file by numeric index in VS Code — $1: path (default: "."), $2: file index (default: 0)]

- code-i

[Open an Excel file (.xls/.xlsx/.xlsm) in LibreOffice Calc — $1: file path (required)]

- xcl

### Data_Extraction

[Concatenate GPT token values from a JSON file using jq — $1: JSON file path (required)]

- join-tokens

[Count and list all .java files with total file and line counts]

- jdata

[Count and list all JS/TS/Vue files (.js, .cjs, .mjs, .jsx, .ts, .cts, .mts, .tsx, .vue) with total counts]

- jsdata

[Count and list all .php files with total file and line counts]

- phpdata

[Count and list all .py files with total file and line counts]

- pydata

[Count and list files matching custom glob patterns with total counts — $@: glob patterns (e.g., "*.go" "*.rs")]

- pldata

[Remove double underscores from filenames interactively — $1: path (default: "."), $2: --no-interactive to skip prompts]

- rmmultius

### Browser_Dev

[Clear Chrome/Chromium fetch code cache directories]

- rm-chromefetch

[Activate Python virtual environment from ./env/bin/activate]

- py-venv

[Run Django manage.py commands — $@: manage.py arguments (e.g., runserver, migrate)]

- pymng

[Alias for pymng (Django manage.py)]

- django

[Kill all Chrome processes (SIGKILL)]

- killchrome

[Clear Chrome/Chromium fetch cache (duplicate variant)]

- rmchrome-fetch

### HTML_CSS_Tools

[Strip all HTML comments from a file and reformat with Prettier]

- strip-html-comments

[Extract &lt;style&gt; content from an HTML file, minify with clean-css-cli, and display original vs minified byte sizes]

- extract-min-css

[Count HTML comments and total lines in a file]

- count-html-comments

[Check which CSS minifier CLI is available (csso or clean-css-cli)]

- check-css-minifier

[Inject a minified CSS file into the &lt;style&gt; block of an HTML file, then restore @media and @container at-rules collapsed by minification]

- inject-min-css

### Android_ADB

[List heaviest files on an Android device via ADB with interim reports and pause/resume support]

- ls-heavy-adb

[List heaviest directories on an Android device via ADB with interim reports and pause/resume support]

- ls-heavy-adb-dirs

### Alias_Shortcuts

#### Complex_Functions

[Alias for convert_to_snake_case]

- tosnake

[Alias for compress_current_directory]

- compweb

[Alias for unzip_all]

- unzipall

[Alias for delete_all_compressed]

- deletezip

[Alias for heavy_files]

- getheavfiles

[Alias for heavy_folders]

- getheavdirs

[Alias for measure_file_distribution]

- filedistrib

[Alias for search_interactive]

- isearch

[Alias for recursive_search_files]

- lsrf

[Alias for code_by_index]

- idxcode

[Alias for get_concatenated_gpt_tokens]

- getgpttokens

[Alias for get_java_files_data]

- getjavadata

[Alias for get_js_files_data]

- getjsdata

[Alias for get_php_files_data]

- getphpdata

[Alias for get_python_files_data]

- getpydata

[Alias for get_prog_lang_files_data]

- getplngdata

#### Hardware_Aliases

[Alias for processor_data (lscpu)]

- getprocfull

[Alias for ssram_data (dmidecode -t memory)]

- getssramfull

[Alias for storage_data (lsblk + df)]

- getstoragefull

[Alias for storage_data (lsblk + df)]

- lshw-storage

[Alias for usb_data (lsusb)]

- getusbportfull

[Alias for usb_data (lsusb)]

- lsusb

[Alias for video_data (lspci VGA/3D/display)]

- getvcfull

[Alias for grouped_hardware (lshw -short)]

- gethwfull

#### Storage_Aliases

[Alias for open_recycle_bin (trash://)]

- cbin

#### USB_Aliases

[Alias for get_usb_controller_device (lsusb)]

- getusbcd

[Alias for get_usb_controller (lspci USB)]

- getusbc

#### Proc_Mem_Aliases

[Alias for get_processor (lscpu)]

- getproc

[Alias for get_physical_memory (free -h)]

- getpmem

[Alias for get_disk_drive (lsblk -d)]

- getdd

[Alias for get_logical_disk (df -h)]

- getld

[Alias for get_video_controller (lspci VGA/3D)]

- getvc

[Alias for wddm_version (glxinfo OpenGL version)]

- getwddm

#### Core_System_Aliases

[Alias for get_battery (acpi -b)]

- getbt

[Alias for get_power_setting (powerprofilesctl)]

- getpws

[Alias for get_printers (lpstat)]

- getprn

[Alias for get_bios (dmidecode -t bios)]

- getbios

[Alias for get_computer_system (uname -a)]

- getcs

[Alias for get_operating_system (lsb_release / hostnamectl)]

- getos

[Alias for get_product (dpkg-query / rpm)]

- getprod

[Alias for get_services (systemctl list-units)]

- getsvc

#### Administration_Aliases

[Alias for get_user_account (getent passwd)]

- getua

[Alias for get_group_user (getent group)]

- getgu

[Alias for get_ntlog_event (journalctl)]

- getntlog

#### Network_Aliases

[Alias for get_network_adapter_configuration (nmcli / ip addr)]

- getnac

[Alias for netsh_winsock_catalog (ss -tunap)]

- netshv

[Alias for netsh_wlan (nmcli wifi list)]

- netsha

[Alias for get_wireless_capabilities (iw list)]

- netshc

[Alias for get_net_drivers (lspci network)]

- getndv

#### Quick_Open_Aliases

[Alias for open_recycle_bin]

- recyclebin

[Alias for open_documents]

- documents

[Alias for open_documents]

- docs

[Alias for open_desktop]

- desktop

[Alias for open_desktop]

- dkt

[Alias for open_pictures]

- pictures

[Alias for open_pictures]

- pct

[Alias for diagnose_memory (free -h)]

- memdiag

[Alias for open_fonts]

- fonts

[Alias for open_personalization]

- personalization

### XFCE_Settings

[Open XFCE display settings]

- deb-st-display

[Open XFCE power manager settings (night light equivalent)]

- deb-st-nightlight

[Open XFCE display settings (screen resolution)]

- deb-st-screenresolution

[Open XFCE workspace settings (multitasking/virtual desktops)]

- deb-st-multitasking

[Show XFCE about dialog]

- deb-st-about

[Show XFCE about dialog (system info)]

- deb-st-systeminfo

[Open PulseAudio volume control (sound settings)]

- deb-st-sound

[Open PulseAudio volume control (sound devices)]

- deb-st-sound-devices

[Open PulseAudio volume control (audio)]

- deb-st-audio

[Open NetworkManager connection editor]

- deb-st-network

[Open NetworkManager connection editor (WiFi)]

- deb-st-wifi

[Open NetworkManager connection editor (Ethernet)]

- deb-st-ethernet

[Open Blueman Bluetooth manager]

- deb-st-bluetooth

[Open Blueman Bluetooth manager (shorthand)]

- st-bt

[Open NetworkManager connection editor (proxy)]

- deb-st-proxy

[Open XFCE settings manager (personalization)]

- deb-st-personalization

[Open XFCE appearance settings (themes)]

- deb-st-themes

[Open XFCE appearance settings (colors)]

- deb-st-colors

[Open XFCE desktop settings (background/wallpaper)]

- deb-st-background

[Open XFCE screensaver preferences (lock screen)]

- deb-st-lockscreen

[Open XFCE panel preferences (taskbar)]

- deb-st-taskbar

[Open XFCE appearance settings (fonts)]

- deb-st-fonts

[Open XFCE mouse settings (cursor/pointer)]

- deb-st-cursormousepointer

[Open system-config-printer (printers)]

- deb-st-printers

[Open XFCE mouse settings]

- deb-st-mouse

[Open XFCE mouse settings (touchpad)]

- deb-st-touchpad

[Open XFCE keyboard settings]

- deb-st-keyboard

[Open XFCE mouse settings (pen/tablet)]

- deb-st-pen

[Open Thunar preferences (autoplay)]

- deb-st-autoplay

[Open Thunar file manager (USB)]

- deb-st-usb

[Open XFCE time/date admin]

- deb-st-dateandtime

[Open XFCE settings manager (region/language)]

- deb-st-regionlanguage

[Open XFCE settings manager (language)]

- deb-st-language

[Open XFCE power manager settings (power/sleep)]

- deb-st-powersleep

[Open XFCE power manager settings (battery saver)]

- deb-st-batterysaver

[Open XFCE power manager settings (power options)]

- deb-st-poweroptions

[Open Thunar file manager (storage sense equivalent)]

- deb-st-storagesense

[Open XFCE MIME settings (default apps)]

- deb-st-defaultapps

[Open Google Maps in default browser]

- deb-st-maps

[Open XFCE application finder (apps & features)]

- deb-st-appsfeatures

[Open Synaptic package manager (optional features)]

- deb-st-optionalfeatures

[Open Synaptic package manager (programs & features)]

- deb-st-programsfeatures

[Open XFCE MIME settings (app defaults)]

- deb-st-appdefaults

[Open users-admin (your info)]

- deb-st-yourinfo

[Open users-admin (sign-in options)]

- deb-st-signinoptions

[Open users-admin (workplace)]

- deb-st-workplace

[Open users-admin (other users)]

- deb-st-otherusers

[Launch Steam (gaming)]

- deb-st-gaming

[Launch gamemode]

- deb-st-gamemode

[Open XFCE accessibility settings (ease of access)]

- deb-st-easeofaccess

[Open XFCE display settings (display ease of access)]

- deb-st-display-easeofaccess

[Open XFCE mouse settings (mouse pointer)]

- deb-st-mousepointer

[Open XFCE keyboard settings (keyboard ease of access)]

- deb-st-keyboard-easeofaccess

[Open XFCE settings manager (privacy)]

- deb-st-privacy

[Run ClamAV freshclam update (Windows Defender equivalent)]

- deb-st-windowsdefender

[Run sudo apt update && sudo apt upgrade (Windows Update equivalent)]

- deb-st-windowsupdate

[Open Déjà Dup backup preferences]

- deb-st-backup

[Open XFCE settings manager (troubleshoot)]

- deb-st-troubleshoot

[Echo "Use GRUB recovery mode" (recovery)]

- deb-st-recovery

[Echo "No activation needed in Linux"]

- deb-st-activation

[Echo "Feature not available in Linux" (find my device)]

- deb-st-findmydevice

[Open XFCE settings manager (developer settings)]

- deb-st-developers

[Open XFCE application finder (Cortana equivalent)]

- deb-st-cortana

[Open XFCE application finder (search)]

- deb-st-search

[Echo "Mixed reality not natively supported" (holographic)]

- deb-st-holographic

[Open Thunar file manager (Explorer equivalent)]

- deb-st-explorer

[Open Thunar file manager (This PC equivalent)]

- deb-st-thispc

[Open Thunar on ~/Documents]

- deb-st-documents

[Open Thunar on ~/Downloads]

- deb-st-downloads

[Open Thunar on ~/Music]

- deb-st-music

[Open Thunar on ~/Pictures]

- deb-st-pictures

[Open Thunar on ~/Videos]

- deb-st-videos

[Open Thunar on ~/Desktop]

- deb-st-desktop

[Open XFCE settings manager (Control Panel equivalent)]

- deb-st-controlpanel

[Open XFCE settings manager (Admin Tools equivalent)]

- deb-st-admintools

[Open lshw-gtk (Device Manager equivalent)]

- deb-st-devicemanager

[Open GNOME Disks (Disk Management equivalent)]

- deb-st-diskmgmt

[Open GNOME Logs (Event Viewer equivalent)]

- deb-st-eventvwr

[Open systemd-manager (Services equivalent)]

- deb-st-services

[Open htop (Task Manager equivalent)]

- deb-st-taskmanager

[Open dconf-editor (Registry Editor equivalent)]

- deb-st-regedit

[Open XFCE terminal]

- deb-st-terminal

[Open Thunar file manager]

- deb-st-filemanager

[Open galculator (Calculator equivalent)]

- deb-st-calculator

[Open Mousepad text editor (Notepad equivalent)]

- deb-st-notepad

[Open GIMP (Paint equivalent)]

- deb-st-paint

[Open XFCE screenshooter (Screenshot tool)]

- deb-st-screenshot

[Open Hardinfo (msinfo32 equivalent)]

- deb-st-msinfo32

[Open systemd-manager (msconfig equivalent)]

- deb-st-msconfig

[Open XFCE terminal (cmd equivalent)]

- deb-st-cmd

[Open XFCE terminal (PowerShell equivalent)]

- deb-st-powershell

[Open XFCE application finder collapsed (Run dialog equivalent)]

- deb-st-run
