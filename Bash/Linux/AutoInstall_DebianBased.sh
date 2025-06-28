#!/usr/bin/env bash
#
# Developer dependencies installer
#

if [[ "$0" == */* && ! -x "$0" ]]; then
    echo -e "${RED}Error: script is not executable. Run 'chmod +x $0'${NC}" >&2
    exit 1
fi

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

declare -a INSTALL_LOG=()
AVAILABLE_STORAGE=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
MEMORY_INFO=$(free -g | awk '/Mem:/ {print $2}')
USER_NAME=$(whoami)

generate_report() {
    echo -e "${BLUE}=== SYSTEM HARDWARE REPORT ===${NC}"
    local board cpu memtype netcard gpu storage usage
    board=$(dmidecode -t baseboard | awk -F: '/Product Name/ {print $2; exit}' | xargs)
    cpu=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
    memtype=$(dmidecode -t memory | awk -F: '/Type:/ && !/DRAM/ {print $2; exit}' | xargs)
    netcard=$(lspci | awk -F': ' '/Network|Ethernet/ {print $3; exit}')
    gpu=$(lspci | awk -F': ' '/VGA/ {print $3; exit}')
    storage=$(lsblk -dno MODEL | head -n1 | xargs)
    usage=$(df -h / | awk 'NR==2 {print $3 " used, " $4 " free"}')
    echo -e "${CYAN}Hostname:    ${NC}$(hostname)"
    echo -e "${CYAN}Baseboard:   ${NC}${board:-Unknown}"
    echo -e "${CYAN}CPU:         ${NC}${cpu:-Unknown}"
    echo -e "${CYAN}Cores:       ${NC}$(nproc)"
    echo -e "${CYAN}Memory:      ${NC}${MEMORY_INFO}G (${memtype:-Unknown})"
    echo -e "${CYAN}Storage:     ${NC}${storage:-Unknown}"
    echo -e "${CYAN}Network:     ${NC}${netcard:-Unknown}"
    echo -e "${CYAN}GPU:         ${NC}${gpu:-Unknown}"
    echo -e "${CYAN}Usage:       ${NC}${usage:-Unknown}"
}

echo
generate_report | tee install_report.log
echo

if (( EUID != 0 )); then
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

if ! systemctl is-enabled --quiet snapd.socket; then
    echo -e "${CYAN}→ Enabling snapd…${NC}"
    apt install -y snapd
    systemctl enable --now snapd.socket
    log_install "snapd" 0
fi

log_install() {
    local item="$1" status="$2"
    INSTALL_LOG+=("$item: $status")
    if (( status == 0 )); then
        echo -e "${GREEN}OK: $item${NC}"
    else
        echo -e "${RED}FAIL: $item${NC}"
    fi
}

handle_error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

exit_opportunity() {
    echo -e "${USER_NAME}, installer starts in 5 seconds. Press ESC to abort..."
    for i in {5..1}; do
        read -rs -n1 -t1 key && [[ "$key" == $'\e' ]] && {
            echo -e "Aborted by user"
            exit 0
        }
        echo -n "$i "
    done
    echo -e "\n${GREEN}Proceeding...${NC}"
}

check_internet() {
    echo -e "${BLUE}Checking internet connectivity...${NC}"
    if ping -c 2 8.8.8.8 &> /dev/null; then
        echo -e "${GREEN}Online${NC}"
        return 0
    else
        echo -e "${RED}Offline${NC}"
        return 1
    fi
}

repair_network() {
    echo -e "Attempting network repair..."
    systemctl enable NetworkManager
    systemctl restart NetworkManager
    systemctl restart networking
    sleep 5
}

system_update() {
    echo -e "\n${BLUE}[Storage: ${AVAILABLE_STORAGE}G free]${NC}"
    echo -e "${CYAN}Updating package lists and upgrading…${NC}"
	echo
    apt update -y && apt upgrade -y
    echo -e "${CYAN}Updating initramfs…${NC}"
    update-initramfs -u
	echo
    sleep 2
}

install_packages() {
    local category="$1"; shift
    local pkgs=("$@")
    echo -e "${BLUE}Installing ${category}…${NC}"
    if apt install -y "${pkgs[@]}"; then
        log_install "${category}" 0
    else
        log_install "${category}" 1
        handle_error "Failed installing ${category}"
    fi
}

prompt_or_auto_confirm() {
    local message="$1" __result="$2"
    if $AUTO_INSTALL_ALL; then
        eval "$__result='y'"
    else
        printf "\n"
        read -r -n1 -p "$message [y/N] " choice
        echo
        eval "$__result=\$choice"
    fi
}

detect_network() {
    echo -e "\n${BLUE}Detecting network hardware…${NC}"
    if ! command -v lspci &> /dev/null; then
        echo "lspci not found; skipping network detection"
        return
    fi
    case "$(lspci)" in
        *Intel*Network*|*Wireless*)
            echo -e "${CYAN}Intel wireless detected${NC}"
            set +e
            if apt-cache show firmware-iwlwifi &> /dev/null; then
                apt install -y firmware-iwlwifi && log_install "firmware-iwlwifi" 0 || log_install "firmware-iwlwifi" 1
            else
                echo "SKIP: firmware-iwlwifi not available"
            fi
            set -e
            ;;
        *Broadcom*)
            echo -e "${CYAN}Broadcom wireless detected${NC}"
            for pkg in firmware-b43-installer bcmwl-kernel-source; do
                set +e
                if apt-cache show "$pkg" &> /dev/null; then
                    apt install -y "$pkg" && log_install "$pkg" 0 || log_install "$pkg" 1
                else
                    echo "SKIP: $pkg not available"
                fi
                set -e
            done
            ;;
        *)
            echo "No special wireless firmware needed"
            ;;
    esac
}

detect_graphics() {
    echo -e "\n${BLUE}Checking for low-memory graphics settings…${NC}"
    if (( MEMORY_INFO <= 8 )); then
        prompt_or_auto_confirm "Low memory (${MEMORY_INFO}G). Disable GPU acceleration?" c
        if [[ "$c" =~ [Yy] ]]; then
            echo -e "${CYAN}Disabling hardware acceleration…${NC}"
            printf 'export LIBGL_ALWAYS_SOFTWARE=1\nexport GALLIUM_DRIVER=llvmpipe\n' \
                > /etc/profile.d/disable_hw_accel.sh
        fi
    fi
}

exit_opportunity

printf "\n"
read -r -n1 -p "Install most available packages without prompting? [y/N] " choice
echo
AUTO_INSTALL_ALL=false
if [[ "$choice" =~ [Yy] ]]; then
    AUTO_INSTALL_ALL=true
fi

if ! check_internet; then
    for attempt in 1 2 3; do
        prompt_or_auto_confirm "Attempt network repair?" choice
        if [[ "$choice" =~ [Yy] ]]; then
            repair_network
            check_internet && break
        else
            break
        fi
    done
fi

system_update
install_packages "Compression Tools" zip unzip gzip tar gdebi flatpak git
install_packages "Utilities" file xdg-utils ca-certificates gnupg lsb-release ncal trash-cli plocate nload libreoffice alacarte rfkill hwinfo
install_packages "Monitoring Tools" htop iotop net-tools traceroute mesa-utils mesa-va-drivers mesa-vulkan-drivers memtester vainfo
install_packages "System Packages" libgl1-mesa-dri stress-ng systemd-sysv curl bluez-tools bluetooth iw ethtool wget

case "${XDG_SESSION_TYPE:-}" in
    wayland)
        prompt_or_auto_confirm "Install Wayland tools?" choice
        if [[ "$choice" =~ [Yy] ]]; then
            set +e
            for pkg in ydotool wtype; do
                if apt-cache show "$pkg" &> /dev/null; then
                    apt install -y "$pkg" && log_install "$pkg" 0 || log_install "$pkg" 1
                else
                    echo "SKIP: $pkg not available"
                fi
            done
            set -e
        fi
        ;;
    x11)
        prompt_or_auto_confirm "Install X11 tools?" choice
        if [[ "$choice" =~ [Yy] ]]; then
            set +e
            if apt-cache show xdotool &> /dev/null; then
                apt install -y xdotool && log_install "xdotool" 0 || log_install "xdotool" 1
            else
                echo "SKIP: xdotool not available"
            fi
            set -e
        fi
        ;;
esac

prompt_or_auto_confirm "Install multimedia apps?" choice
if [[ "$choice" =~ [Yy] ]]; then
    set +e
    for pkg in audacity gimp krita; do
        if apt-cache show "$pkg" &> /dev/null; then
            apt install -y "$pkg" && log_install "$pkg" 0 || log_install "$pkg" 1
        else
            echo "SKIP: $pkg not available"
        fi
    done
    set -e
    snap install vlc && log_install "vlc (snap)" 0 || log_install "vlc (snap)" 1
fi

if dpkg -s brave-browser &>/dev/null; then
    log_install "Brave Browser" 0
else
    prompt_or_auto_confirm "Install Brave Browser?" choice
    if [[ "$choice" =~ [Yy] ]]; then
        KEYRING_DIR="/etc/apt/keyrings"
        KEY_PATH="$KEYRING_DIR/brave-browser-archive-keyring.gpg"
        LIST_PATH="/etc/apt/sources.list.d/brave-browser-release.list"

        mkdir -p "$KEYRING_DIR"
        rm -f "$KEY_PATH" "$LIST_PATH"

        curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
          > "$KEY_PATH"

        cat > "$LIST_PATH" <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=$KEY_PATH] \
    https://brave-browser-apt-release.s3.brave.com/ stable main
EOF

        apt update -y

        set +e
        if apt-cache show brave-browser &>/dev/null; then
            apt install -y brave-browser \
                && log_install "Brave Browser" 0 \
                || log_install "Brave Browser" 1
        else
            echo "SKIP: brave-browser not available"
        fi
        set -e
    fi
fi

prompt_or_auto_confirm "Install vi-like code editors? (vim, neovim)?" choice
if [[ "$choice" =~ [Yy] ]]; then
    set +e
    for pkg in vim neovim; do
        if apt-cache show "$pkg" &>/dev/null; then
            apt install -y "$pkg" && log_install "$pkg" 0 || log_install "$pkg" 1
        else
            echo "SKIP: $pkg not available"
        fi
    done
    set -e
fi

printf "\n"
read -r -n1 -p "Install emacs? [y/N] " emacs_choice
echo

if [[ "$emacs_choice" =~ [Yy] ]]; then
    pkg="emacs"
    set +e

    if dpkg -s "$pkg" &>/dev/null; then
        log_install "$pkg (already installed)" 0
        echo "  • $pkg already installed, skipping"

    elif apt-cache show "$pkg" &>/dev/null; then
        apt install -y "$pkg" \
            && log_install "$pkg" 0 \
            || log_install "$pkg" 1

    else
        echo "SKIP: $pkg not available"
    fi

    set -e
fi

if dpkg -s python3 &>/dev/null \
   && dpkg -s python3-pip &>/dev/null \
   && dpkg -s ipython3 &>/dev/null; then

    log_install "python3" 0
    log_install "python3-pip" 0
    log_install "ipython3" 0

else
    prompt_or_auto_confirm "Install Python and common packages?" choice
    if [[ "$choice" =~ [Yy] ]]; then
        set +e
        for pkg in python3 python3-pip ipython3; do
            if apt-cache show "$pkg" &>/dev/null; then
                apt install -y "$pkg" \
                  && log_install "$pkg" 0 \
                  || log_install "$pkg" 1
            else
                echo "SKIP: $pkg not available"
            fi
        done
        set -e
        if ! command -v pip3 &>/dev/null; then
            handle_error "pip3 not found after installing python3-pip"
        fi
        set +e
        if pip3 install --upgrade pandas openpyxl numpy colorama; then
            log_install "Python packages" 0
        else
            log_install "Python packages" 1
        fi
        set -e

    fi
fi

prompt_or_auto_confirm "Install Java (OpenJDK 21)?" choice
if [[ "$choice" =~ [Yy] ]]; then
    set +e
    if apt-cache show openjdk-21-jdk &> /dev/null; then
        apt install -y openjdk-21-jdk && log_install "OpenJDK 21" 0 || log_install "OpenJDK 21" 1
    else
        echo "SKIP: openjdk-21-jdk not available"
    fi
    set -e
fi

prompt_or_auto_confirm "Install PHP extensions & developer tools?" php_choice
if [[ "$php_choice" =~ [Yy] ]]; then
    set +e
    phppkgs=(php-cli php-mysql php-xml php-curl php-gd php-mbstring php-zip php-xmlrpc)
    for pkg in "${phppkgs[@]}"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            apt install -y "$pkg" \
              && log_install "$pkg" 0 \
              || log_install "$pkg" 1
        else
            log_install "$pkg (already installed)" 0
        fi
    done
    if ! command -v wp &>/dev/null; then
        curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
          -o /usr/local/bin/wp \
          && chmod +x /usr/local/bin/wp \
          && log_install "WP-CLI" 0 \
          || log_install "WP-CLI" 1
    else
        log_install "WP-CLI (already installed)" 0
    fi

    printf "\n"
    read -r -n1 -p "Install/update Laravel installer? [y/N] " laravel_choice
    echo
    if [[ "$laravel_choice" =~ [Yy] ]]; then
        INSTALL_USER=${SUDO_USER:-$USER}
        INSTALL_HOME=$(eval echo "~$INSTALL_USER")
        HERD_BIN="$INSTALL_HOME/.config/herd-lite/bin"
        echo -e "${CYAN}Installing Laravel installer for user: $INSTALL_USER${NC}"
        sudo -u "$INSTALL_USER" bash -c 'curl -fsSL https://php.new/install/linux/8.3 | bash'
        if [[ $? -eq 0 ]]; then
            log_install "Laravel installer" 0
            if [[ -d "$HERD_BIN" ]]; then
                if ! grep -q "export PATH=\"$HERD_BIN:\$PATH\"" "$INSTALL_HOME/.bashrc"; then
                    echo "export PATH=\"$HERD_BIN:\$PATH\"" >> "$INSTALL_HOME/.bashrc"
                    log_install "Added Herd Lite to PATH in $INSTALL_HOME/.bashrc" 0
                fi
                export PATH="$HERD_BIN:$PATH"
            else
                log_install "Herd Lite bin directory not found" 1
                echo -e "${YELLOW}WARNING: Herd Lite bin directory not found at $HERD_BIN${NC}"
            fi
        else
            log_install "Laravel installer" 1
            echo -e "${RED}ERROR: Laravel installer failed${NC}"
        fi
    else
        log_install "Laravel installer (skipped)" 0
    fi

    set -e
fi

if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_install "Node & npm packages" 0
    echo "  • Node.js v22 and npm already installed, skipping"
else
    prompt_or_auto_confirm "Install Node.js (via NVM) and global npm packages? [y/N]" node_choice
    if [[ "$node_choice" =~ [Yy] ]]; then
        set +e
        if ! command -v nvm &>/dev/null; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh \
              | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        fi
        nvm install 22
        npm install -g typescript sass react react-dom react-native vue express jest \
            @testing-library/angular @angular/cli create-vite create-next-app nuxi \
            @wordpress/scripts \
          && log_install "Node & npm packages" 0 \
          || log_install "Node & npm packages" 1

        set -e
    fi
fi

printf "\n"
read -r -n1 -p "Install MySQL server and client? [y/N] " mysql_choice
echo
if [[ "$mysql_choice" =~ [Yy] ]]; then
    set +e
    for pkg in mysql-server mysql-client; do
        if apt-cache show "$pkg" &> /dev/null; then
            apt install -y "$pkg" && log_install "$pkg" 0 || log_install "$pkg" 1
        else
            echo "SKIP: $pkg not available"
        fi
    done
    if ! systemctl is-active --quiet mysql; then
        echo "MySQL service is not running. Attempting to start it..."
        for attempt in {1..3}; do
            systemctl start mysql
            sleep 2
            if systemctl is-active --quiet mysql; then
                break
            fi
            echo "Attempt $attempt/3 failed. Retrying..."
        done
    fi
    if [ ! -S /var/run/mysqld/mysqld.sock ]; then
        echo "Socket not found. Fixing socket directory..."
        mkdir -p /var/run/mysqld
        chown mysql:mysql /var/run/mysqld
        systemctl restart mysql
        sleep 2
    fi
    if systemctl is-active --quiet mysql; then
        temp_password=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9!@#$%^&*()_+')
        echo -e "${YELLOW}Setting MySQL root password to: $temp_password${NC}"
        echo -e "${YELLOW}You MUST change this password immediately after installation!${NC}"
        mysql --user=root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$temp_password';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

        if [ $? -eq 0 ]; then
            log_install "MySQL secure installation" 0
            echo -e "${GREEN}MySQL secured successfully${NC}"
            echo -e "${RED}IMPORTANT: MySQL root password is ${temp_password}${NC}"
            echo -e "${RED}           Change it immediately using: mysql_secure_installation${NC}"
        else
            log_install "MySQL secure installation" 1
            echo -e "${YELLOW}Failed to secure MySQL automatically. Run manually: mysql_secure_installation${NC}"
        fi
    else
        log_install "MySQL service" 1
        echo -e "${RED}Error: MySQL failed to start. Check logs with: journalctl -xeu mysql${NC}"
        echo -e "${YELLOW}You may need to run mysql_secure_installation manually after troubleshooting${NC}"
    fi

    set -e
fi

printf "\n"
read -r -n1 -p "Install Notepad++? [y/N] " choice
echo
if [[ "$choice" =~ [Yy] ]]; then
    set +e
    if snap list notepad-plus-plus &>/dev/null; then
        log_install "Notepad++ (snap)" 0
    else
        snap install notepad-plus-plus \
            && log_install "Notepad++ (snap)" 0 \
            || log_install "Notepad++ (snap)" 1
    fi
    set -e
    printf "\n"
    read -r -n1 -p "Set Notepad++ as default editor? [y/N] " choice2
    echo
    if [[ "$choice2" =~ [Yy] ]]; then
        if command -v notepad-plus-plus &>/dev/null; then
            update-alternatives --install /usr/bin/editor editor "$(command -v notepad-plus-plus)" 60
            update-alternatives --set editor "$(command -v notepad-plus-plus)"
            echo -e "${GREEN}Default editor set to Notepad++${NC}"
        else
            echo -e "${YELLOW}Warning: Notepad++ binary not found for update-alternatives${NC}"
        fi
    fi
fi

echo -e "\n${BLUE}=== INSTALLATION SUMMARY (0 denotes no error!) ===${NC}"
for entry in "${INSTALL_LOG[@]}"; do
    if [[ $entry == *": 0" ]]; then
        echo -e "${GREEN}${entry}${NC}"
    else
        echo -e "${RED}${entry}${NC}"
    fi
done

echo
generate_report | tee install_report.log
echo -e "${GREEN}Done! Report saved to install_report.log${NC}"
