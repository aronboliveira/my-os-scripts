#region Network_Procedures
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Show DNS config, hostname, and IP addresses.
#>
function Show-NetDnsInfo {
  Write-Host "`n── 🔎 DNS CONFIGURATION ──`n" -ForegroundColor Blue
  try { Get-DnsClientServerAddress | Where-Object { $_.ServerAddresses } | Format-Table InterfaceAlias, ServerAddresses -AutoSize } catch { Write-Host "❌ Unable to query DNS config" -ForegroundColor Red }
  Write-Host "`n── 🏷️  HOSTNAME ──`n" -ForegroundColor Blue
  Write-Host ([System.Net.Dns]::GetHostName())
  Write-Host "`n── 📡 IP ADDRESSES ──`n" -ForegroundColor Blue
  try { Get-NetIPAddress | Where-Object { $_.AddressState -eq 'Preferred' } | Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressFamily | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query IP addresses" -ForegroundColor Red }
}
Set-Alias -Name ls-net-dns -Value Show-NetDnsInfo
Set-Alias -Name show-net-dns -Value Show-NetDnsInfo
Set-Alias -Name ls-dns-info -Value Show-NetDnsInfo
Set-Alias -Name show-dns-info -Value Show-NetDnsInfo

<#
.SYNOPSIS Show public IP address via Invoke-RestMethod (IPv4).
#>
function Show-NetPublicIp {
  Write-Host "`n── 🌍 PUBLIC IP ──`n" -ForegroundColor Blue
  Write-Host "Note: This may not work if behind a NAT or firewall." -ForegroundColor Yellow
  try {
    $ip = Invoke-RestMethod -Uri "https://ifconfig.me/ip" -TimeoutSec 10
    Write-Host "Public IP: $ip"
  } catch {
    Write-Host "❌ Unable to retrieve public IP" -ForegroundColor Red
  }
}
Set-Alias -Name ls-net-public-ip -Value Show-NetPublicIp
Set-Alias -Name show-net-public-ip -Value Show-NetPublicIp
Set-Alias -Name ls-public-ip -Value Show-NetPublicIp
Set-Alias -Name show-public-ip -Value Show-NetPublicIp

<#
.SYNOPSIS Show IP addresses and network adapter details.
#>
function Show-NetIpAddrs {
  Write-Host "`n── 📡 NETWORK ADAPTERS ──`n" -ForegroundColor Blue
  try { Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object Name, InterfaceDescription, MacAddress, LinkSpeed | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query adapters" -ForegroundColor Red }
  Write-Host "`n── 📟 IP CONFIGURATION ──`n" -ForegroundColor Blue
  try { Get-NetIPConfiguration | Format-Table InterfaceAlias, IPv4Address, IPv6Address, DNSServer -AutoSize } catch { Write-Host "❌ Unable to query IP config" -ForegroundColor Red }
}
Set-Alias -Name ls-net-ip-addrs -Value Show-NetIpAddrs
Set-Alias -Name show-net-ip-addrs -Value Show-NetIpAddrs
Set-Alias -Name ls-ip-addrs -Value Show-NetIpAddrs
Set-Alias -Name show-ip-addrs -Value Show-NetIpAddrs

<#
.SYNOPSIS Show hosts file and network routes.
#>
function Show-NetHostsInfo {
  Write-Host "`n── 🗃️  HOSTS FILE ──`n" -ForegroundColor Blue
  $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
  if (Test-Path $hostsPath) {
    Get-Content $hostsPath | Where-Object { $_ -and $_ -notmatch '^\s*#' }
  } else {
    Write-Host "❌ Hosts file not found" -ForegroundColor Red
  }
  Write-Host "`n── 🔌 NETWORK ROUTES ──`n" -ForegroundColor Blue
  try { Get-NetRoute | Where-Object { $_.DestinationPrefix -ne '0.0.0.0/0' -and $_.DestinationPrefix -ne '::/0' } | Select-Object DestinationPrefix, NextHop, InterfaceAlias, RouteMetric | Sort-Object DestinationPrefix | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query routes" -ForegroundColor Red }
}
Set-Alias -Name ls-net-hosts -Value Show-NetHostsInfo
Set-Alias -Name show-net-hosts -Value Show-NetHostsInfo
Set-Alias -Name ls-hosts-info -Value Show-NetHostsInfo
Set-Alias -Name show-hosts-info -Value Show-NetHostsInfo

<#
.SYNOPSIS Show network connection profiles and service status.
#>
function Show-NetNmStatus {
  Write-Host "`n── 📶 NETWORK CONNECTION PROFILES ──`n" -ForegroundColor Blue
  try { Get-NetConnectionProfile | Format-Table Name, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity -AutoSize } catch { Write-Host "❌ Unable to query connection profiles" -ForegroundColor Red }
  Write-Host "`n── 🔄 NETWORK SERVICES STATUS ──`n" -ForegroundColor Blue
  try {
    @('Dhcp', 'Dnscache', 'NlaSvc', 'Netman', 'WlanSvc') | ForEach-Object {
      $svc = Get-Service -Name $_ -ErrorAction SilentlyContinue
      if ($svc) { [PSCustomObject]@{ Name = $svc.Name; DisplayName = $svc.DisplayName; Status = $svc.Status } }
    } | Format-Table -AutoSize
  } catch { Write-Host "❌ Unable to query services" -ForegroundColor Red }
}
Set-Alias -Name ls-net-nm-status -Value Show-NetNmStatus
Set-Alias -Name show-net-nm-status -Value Show-NetNmStatus
Set-Alias -Name ls-nm-status -Value Show-NetNmStatus
Set-Alias -Name show-nm-status -Value Show-NetNmStatus

<#
.SYNOPSIS Show Windows Firewall rules and profiles.
#>
function Show-NetFirewall {
  Write-Host "`n── 🔒 FIREWALL PROFILES ──`n" -ForegroundColor Blue
  try { Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query firewall profiles" -ForegroundColor Red }
  Write-Host "`n── 🛡️  ACTIVE FIREWALL RULES (Enabled, Allow) ──`n" -ForegroundColor Blue
  try {
    Get-NetFirewallRule -Enabled True -Action Allow |
      Select-Object -First 30 DisplayName, Direction, Profile, Action |
      Format-Table -AutoSize
    Write-Host "(Showing first 30 rules)" -ForegroundColor DarkGray
  } catch { Write-Host "❌ Unable to query firewall rules" -ForegroundColor Red }
}
Set-Alias -Name ls-net-firewall -Value Show-NetFirewall
Set-Alias -Name show-net-firewall -Value Show-NetFirewall
Set-Alias -Name ls-firewall -Value Show-NetFirewall
Set-Alias -Name show-firewall -Value Show-NetFirewall

<#
.SYNOPSIS Aggregated network profile: DNS, public IP, IP addresses, hosts, connection profiles, firewall.
#>
function Show-NetProfile {
  Write-Host "`n══════════ 🌐 NETWORK PROFILE ══════════`n" -ForegroundColor Cyan
  Show-NetDnsInfo
  Start-Sleep -Seconds 3
  Show-NetPublicIp
  Start-Sleep -Seconds 3
  Show-NetIpAddrs
  Start-Sleep -Seconds 3
  Show-NetHostsInfo
  Start-Sleep -Seconds 3
  Show-NetNmStatus
  Start-Sleep -Seconds 3
  Show-NetFirewall
}
Set-Alias -Name ls-net-profile -Value Show-NetProfile
Set-Alias -Name show-net-profile -Value Show-NetProfile
Set-Alias -Name ls-network-profile -Value Show-NetProfile
Set-Alias -Name show-network-profile -Value Show-NetProfile

<#
.SYNOPSIS Show user registry hive info (Windows equivalent of dconf), logon sessions, user info, and home directory listing.
#>
function Show-HomeProfile {
  Write-Host "`n── 🏠 USER REGISTRY SETTINGS ──`n" -ForegroundColor Blue
  try {
    $items = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -ErrorAction SilentlyContinue
    if ($items) { $items | Format-List } else { Write-Host "❌ No user registry settings found" -ForegroundColor Red }
  } catch { Write-Host "❌ Unable to read user registry" -ForegroundColor Red }
  Start-Sleep -Seconds 2

  Write-Host "`n── 🗂️  LOGON SESSIONS ──`n" -ForegroundColor Blue
  try { Get-CimInstance Win32_LogonSession | Select-Object LogonId, LogonType, StartTime, AuthenticationPackage | Format-Table -AutoSize } catch { Write-Host "❌ Unable to list logon sessions" -ForegroundColor Red }
  Start-Sleep -Seconds 2

  Write-Host "`n── 🏷️  CURRENT SESSION ID ──`n" -ForegroundColor Blue
  try {
    $currentSession = [System.Diagnostics.Process]::GetCurrentProcess().SessionId
    Write-Host "Session ID: $currentSession"
  } catch { Write-Host "❌ Unable to retrieve session ID" -ForegroundColor Red }

  Write-Host "`n── ⚙️  CURRENT SESSION INFO ──`n" -ForegroundColor Blue
  try { query session 2>$null } catch { Write-Host "❌ Unable to query current session info" -ForegroundColor Red }
  Start-Sleep -Seconds 2

  Write-Host "`n── 👤 CURRENT USER INFO ──`n" -ForegroundColor Blue
  try {
    [PSCustomObject]@{
      UserName    = [System.Environment]::UserName
      DomainName  = [System.Environment]::UserDomainName
      MachineName = [System.Environment]::MachineName
      IsAdmin     = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } | Format-List
  } catch { Write-Host "❌ Unable to show current user info" -ForegroundColor Red }
  Start-Sleep -Seconds 2

  Write-Host "`n── 📁 HOME DIRECTORY ──`n" -ForegroundColor Blue
  Write-Host $HOME
  try { Get-ChildItem -Path $HOME -Force | Select-Object Mode, LastWriteTime, Length, Name | Format-Table -AutoSize } catch { Write-Host "❌ Unable to list home directory contents" -ForegroundColor Red }
}
Set-Alias -Name ls-home-profile -Value Show-HomeProfile
Set-Alias -Name show-home-profile -Value Show-HomeProfile
Set-Alias -Name ls-dconf-profile -Value Show-HomeProfile
Set-Alias -Name show-dconf-profile -Value Show-HomeProfile

<#
.SYNOPSIS Full system profile: env, RBAC, display, network, and home config.
#>
function Show-FullProfile {
  Write-Host "`n══════════ 📦 FULL SYSTEM PROFILE ══════════`n" -ForegroundColor Cyan
  Show-EnvProfile
  Start-Sleep -Seconds 3
  Show-RbacProfile
  Start-Sleep -Seconds 3
  Show-FullDisplayProfile
  Start-Sleep -Seconds 3
  Show-NetProfile
  Start-Sleep -Seconds 3
  Show-HomeProfile
}
Set-Alias -Name ls-full-profile -Value Show-FullProfile
Set-Alias -Name show-full-profile -Value Show-FullProfile
Set-Alias -Name ls-all-profiles -Value Show-FullProfile
Set-Alias -Name show-all-profiles -Value Show-FullProfile

#endregion Network_Procedures



# ═══════════════════════════════════════════════════════════════════════════
