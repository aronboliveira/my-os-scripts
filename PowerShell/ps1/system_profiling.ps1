#region System_Profiling
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Show environment variables, exported variables, shell variables, aliases, and functions.
#>
function Show-EnvProfile {
  Write-Host "`n── 📋 ENVIRONMENT VARIABLES ──`n" -ForegroundColor Blue
  Show-AllEnvVars
  Write-Host "`n── 💾 EXPORTED VARIABLES ──`n" -ForegroundColor Blue
  Show-AllPrintenvVars
  Write-Host "`n── 🐚 SHELL VARIABLES ──`n" -ForegroundColor Blue
  Show-AllShVars
  Start-Sleep -Seconds 3
  Write-Host "`n── 📂 SHELL ALIASES ──`n" -ForegroundColor Blue
  Get-Alias | Sort-Object Name | Format-Table -AutoSize
  Write-Host "`n── ⚡ SHELL FUNCTIONS ──`n" -ForegroundColor Blue
  Get-Command -CommandType Function | Sort-Object Name | Select-Object -ExpandProperty Name
}
Set-Alias -Name ls-env-profile -Value Show-EnvProfile
Set-Alias -Name show-env-profile -Value Show-EnvProfile
Set-Alias -Name ls-env-prof -Value Show-EnvProfile
Set-Alias -Name show-env-prof -Value Show-EnvProfile

<#
.SYNOPSIS Show RBAC info: admin groups, scheduled tasks (sudoers equivalent), MOTD, profile, and certificates.
#>
function Show-RbacProfile {
  Write-Host "`n── 👥 ADMIN GROUPS ──`n" -ForegroundColor Blue
  try { Get-LocalGroupMember -Group "Administrators" 2>$null } catch { Write-Host "❌ Unable to query Administrators group" -ForegroundColor Red }
  Write-Host "`n── 📜 SCHEDULED TASKS (sudoers equivalent) ──`n" -ForegroundColor Blue
  try { Get-ScheduledTask | Where-Object { $_.Principal.RunLevel -eq 'Highest' } | Select-Object TaskName, TaskPath, State | Format-Table -AutoSize } catch { Write-Host "❌ Unable to list scheduled tasks" -ForegroundColor Red }
  Write-Host "`n── 🧾 POWERSHELL PROFILE PATH ──`n" -ForegroundColor Blue
  Write-Host $PROFILE
  if (Test-Path $PROFILE) { Get-Content $PROFILE } else { Write-Host "❌ Profile file not found" -ForegroundColor Red }
  Write-Host "`n── 🔑 CERTIFICATES ──`n" -ForegroundColor Blue
  try { Get-ChildItem Cert:\CurrentUser\My 2>$null | Select-Object Thumbprint, Subject, NotAfter | Format-Table -AutoSize } catch { Write-Host "❌ Unable to list certificates" -ForegroundColor Red }
}
Set-Alias -Name ls-rbac-profile -Value Show-RbacProfile
Set-Alias -Name show-rbac-profile -Value Show-RbacProfile
Set-Alias -Name ls-rbac-prof -Value Show-RbacProfile
Set-Alias -Name show-rbac-prof -Value Show-RbacProfile

<#
.SYNOPSIS Show display/graphics adapter information (Windows equivalent of display manager config).
#>
function Show-FullDisplayProfile {
  Write-Host "`n══════════ 🖥️  DISPLAY PROFILE ══════════`n" -ForegroundColor Cyan
  Write-Host "`n── 🖥️  GRAPHICS ADAPTERS ──`n" -ForegroundColor Blue
  try { Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, VideoModeDescription, CurrentRefreshRate | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query video controllers" -ForegroundColor Red }
  Write-Host "`n── 🖥️  MONITOR INFO ──`n" -ForegroundColor Blue
  try { Get-CimInstance Win32_DesktopMonitor | Select-Object Name, ScreenWidth, ScreenHeight | Format-Table -AutoSize } catch { Write-Host "❌ Unable to query monitors" -ForegroundColor Red }
  Write-Host "`n── 🖥️  DISPLAY SETTINGS ──`n" -ForegroundColor Blue
  try {
    Add-Type -AssemblyName System.Windows.Forms 2>$null
    [System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
      [PSCustomObject]@{
        DeviceName = $_.DeviceName
        Primary    = $_.Primary
        Resolution = "$($_.Bounds.Width)x$($_.Bounds.Height)"
        WorkingArea = "$($_.WorkingArea.Width)x$($_.WorkingArea.Height)"
      }
    } | Format-Table -AutoSize
  } catch { Write-Host "❌ Unable to query display settings" -ForegroundColor Red }
}
Set-Alias -Name ls-full-display-profile -Value Show-FullDisplayProfile
Set-Alias -Name show-full-display-profile -Value Show-FullDisplayProfile
Set-Alias -Name ls-dm-profile -Value Show-FullDisplayProfile
Set-Alias -Name show-dm-profile -Value Show-FullDisplayProfile

#endregion System_Profiling

# ═══════════════════════════════════════════════════════════════════════════
