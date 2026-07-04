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
    alias ls-tcp-proc-config='ls_tcp_proc_config'
    alias ls-tcp-config-proc='ls_tcp_proc_config'
    alias ls-tcp-conf-proc='ls_tcp_proc_config'
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
    alias ls-net-sockstats='ls_net_sockstats'
    alias ls-sockstats='ls_net_sockstats'
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
    alias ls-net-snmp='ls_net_snmp'
    alias ls-snmp='ls_net_snmp'
    ## @description Show iptables rules filtered for TCP across filter, nat, and raw tables.
    ls_tcp_iptables_rules() {
      echo -e "\n\033[1;34m── 🔒 ALL IPTABLES RULES FOR TCP ──\033[0m\n"
      sleep 3
      sudo iptables -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo iptables rules for TCP or iptables available\033[0m"
      sleep 2
      echo -e "\n\033[1;34m── 🔒 NAT IPTABLES RULES FOR TCP ──\033[0m\n"
      sudo iptables -t nat -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo NAT iptables rules for TCP or iptables available\033[0m"
      sleep 2
      echo -e "\n\033[1;34m── 🔒 RAW IPTABLES FOR TCP ──\033[0m\n"
      sudo iptables -t raw -L -n -v --line-numbers 2>/dev/null | grep -i "tcp" || echo -e "❌ \033[1;31mNo RAW iptables rules for TCP or iptables available\033[0m"
    }
    alias ls-tcp-iptables='ls_tcp_iptables_rules'
    alias ls-iptables-tcp='ls_tcp_iptables_rules'
    alias ls-tcp-iptables-rules='ls_tcp_iptables_rules'
    ## @description Show listening TCP ports via lsof.
    ls_tcp_listening_ports() {
      echo -e "\n\033[1;34m── 👂 Listening TCP Ports ──\033[0m\n"
      sudo lsof -i TCP -s TCP:LISTEN 2>/dev/null || echo -e "❌ \033[1;31mNo listening TCP ports or lsof not available\033[0m"
    }
    alias ls-tcp-listening-ports='ls_tcp_listening_ports'
    alias ls-tcp-listen-ports='ls_tcp_listening_ports'
    alias ls-tcp-lp='ls_tcp_listening_ports'
    ## @description Show established TCP connections via lsof.
    ls_tcp_established_connections() {
      echo -e "\n\033[1;34m── 🔗 Established TCP Connections ──\033[0m\n"
      sudo lsof -i TCP -s TCP:ESTABLISHED 2>/dev/null || echo -e "❌ \033[1;31mNo established TCP connections or lsof not available\033[0m"
    }
    alias ls-tcp-established-connections='ls_tcp_established_connections'
    alias ls-tcp-established-conns='ls_tcp_established_connections'
    alias ls-tcp-est-conns='ls_tcp_established_connections'
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
    alias ls-tcp-active-connections='ls_tcp_active_connections'
    alias ls-tcp-active-conns='ls_tcp_active_connections'
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
    alias ls-active-tcp-net-sockets='ls_active_tcp_net_sockets'
    alias ls-active-tcp-sockets='ls_active_tcp_net_sockets'
    alias ls-act-tcp-sockets='ls_active_tcp_net_sockets'
    alias ls-act-tcp-net-sockets='ls_active_tcp_net_sockets'
    alias ls-act-tcp-s='ls_active_tcp_net_sockets'
    alias ls-act-tcp-ns='ls_active_tcp_net_sockets'
    alias ls-act-tcp-net-s='ls_active_tcp_net_sockets'
    alias ls_tcp_active_net_sockets='ls_active_tcp_net_sockets'
    alias ls_tcp_active_sockets='ls_active_tcp_net_sockets'
    alias ls_tcp_active_nsockets='ls_active_tcp_net_sockets'
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
    alias ls-tcp-config='ls_tcp_config'
    alias ls-tcp-conf='ls_tcp_config'
    alias ls-tcp-all='ls_tcp_config'
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
