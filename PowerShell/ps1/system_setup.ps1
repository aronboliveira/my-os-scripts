#region System_Setup
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS List all environment variables, sorted alphabetically.
#>
function Show-AllEnvVars {
  Get-ChildItem Env: | Sort-Object Name | Format-Table -AutoSize
}
Set-Alias -Name show-all-env-vars -Value Show-AllEnvVars

<#
.SYNOPSIS List all exported variables (same as env vars in PS), sorted.
#>
function Show-AllPrintenvVars {
  [System.Environment]::GetEnvironmentVariables() |
    ForEach-Object { $_.GetEnumerator() } |
    Sort-Object Key |
    Format-Table Key, Value -AutoSize
}
Set-Alias -Name show-all-printenv-vars -Value Show-AllPrintenvVars

<#
.SYNOPSIS List all PowerShell variables, sorted alphabetically.
#>
function Show-AllShVars {
  Get-Variable | Sort-Object Name | Format-Table Name, Value -AutoSize
}
Set-Alias -Name show-all-sh-vars -Value Show-AllShVars

<#
.SYNOPSIS Show host machine architecture.
#>
function Show-Hosttype {
  [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
}
Set-Alias -Name show-hosttype -Value Show-Hosttype

<#
.SYNOPSIS Show current user's home directory path.
#>
function Show-Home { $HOME }
Set-Alias -Name show-home -Value Show-Home

<#
.SYNOPSIS Show current username.
#>
function Show-User { $env:USERNAME ?? $env:USER }
Set-Alias -Name show-user -Value Show-User

<#
.SYNOPSIS Show current shell.
#>
function Show-Shell {
  "PowerShell $($PSVersionTable.PSVersion) ($($PSVersionTable.PSEdition))"
}
Set-Alias -Name show-shell -Value Show-Shell

<#
.SYNOPSIS Show current working directory.
#>
function Show-Wrkdir { $PWD.Path }
Set-Alias -Name show-wrkdir -Value Show-Wrkdir

<#
.SYNOPSIS Schedule a process kill at a specified time.
#>
function Invoke-ScheduleKillSequence {
  param(
    [Parameter(Mandatory)][string]$ProcessName,
    [Parameter(Mandatory)][string]$Time
  )
  $delay = ([datetime]$Time - (Get-Date)).TotalSeconds
  if ($delay -le 0) { Write-Error "Time must be in the future."; return }
  Start-Job -ScriptBlock {
    Start-Sleep -Seconds $using:delay
    Stop-Process -Name $using:ProcessName -Force -ErrorAction SilentlyContinue
  } | Out-Null
  Write-Host "Scheduled kill for '$ProcessName' at $Time"
}
Set-Alias -Name schedule-kill-sequence -Value Invoke-ScheduleKillSequence

<#
.SYNOPSIS Set OOM priority for a process (Linux-only concept, stub for PS).
#>
function Set-PsCritical {
  param([Parameter(Mandatory)][int]$Pid)
  Write-Warning "OOM score adjustment is a Linux-specific concept. PID: $Pid score: -1000"
}
Set-Alias -Name set-ps-critical -Value Set-PsCritical

#endregion System_Setup

# ═══════════════════════════════════════════════════════════════════════════
