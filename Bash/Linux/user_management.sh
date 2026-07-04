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
