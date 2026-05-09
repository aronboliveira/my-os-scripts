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

