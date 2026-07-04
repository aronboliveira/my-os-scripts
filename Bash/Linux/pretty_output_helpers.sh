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
