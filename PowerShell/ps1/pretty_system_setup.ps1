#region Pretty_System_Setup
# ═══════════════════════════════════════════════════════════════════════════

function Show-AllEnvVarsPretty {
  _pretty_hdr "All Environment Variables"
  Get-ChildItem Env: | Sort-Object Name |
    ForEach-Object { "$($_.Name)=$($_.Value)" } | _pretty_nl
  _pretty_ftr
}
Set-Alias -Name show-all-env-vars-pretty -Value Show-AllEnvVarsPretty

function Show-AllPrintenvVarsPretty {
  _pretty_hdr "All Exported Variables (Environment)"
  [System.Environment]::GetEnvironmentVariables().GetEnumerator() |
    Sort-Object Key |
    ForEach-Object { "$($_.Key)=$($_.Value)" } | _pretty_nl
  _pretty_ftr
}
Set-Alias -Name show-all-printenv-vars-pretty -Value Show-AllPrintenvVarsPretty

function Show-AllShVarsPretty {
  _pretty_hdr "All PowerShell Variables"
  Get-Variable | Sort-Object Name |
    ForEach-Object { "$($_.Name) = $($_.Value)" } | _pretty_nl
  _pretty_ftr
}
Set-Alias -Name show-all-sh-vars-pretty -Value Show-AllShVarsPretty

#endregion Pretty_System_Setup

# ═══════════════════════════════════════════════════════════════════════════
