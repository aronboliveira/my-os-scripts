#region File_Analysis
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Check if a file has multiple consecutive blank lines.
.PARAMETER File
  Path to the file to check.
#>
function Test-MultipleBlankLines {
  param([Parameter(Mandatory)][string]$File)
  if (-not (Test-Path $File)) {
    Write-Error "File not found: $File"; return
  }
  $blank = 0
  foreach ($line in Get-Content $File) {
    if ($line -match '^\s*$') {
      $blank++
      if ($blank -ge 2) {
        Write-Host "File does have multiple blank lines"
        return
      }
    } else { $blank = 0 }
  }
  Write-Host "File does not have multiple blank lines"
}
Set-Alias -Name is-mblank -Value Test-MultipleBlankLines

<#
.SYNOPSIS List files in current directory with multiple consecutive blank lines.
#>
function Show-MultipleBlankLinesFiles {
  Get-ChildItem -File | ForEach-Object {
    $blank = 0; $found = $false
    foreach ($line in Get-Content $_.FullName -ErrorAction SilentlyContinue) {
      if ($line -match '^\s*$') {
        $blank++
        if ($blank -ge 2) { $found = $true; break }
      } else { $blank = 0 }
    }
    if ($found) { Write-Host "$($_.Name): has multiple consecutive blank lines" }
  }
}
Set-Alias -Name ls-mblank -Value Show-MultipleBlankLinesFiles

<#
.SYNOPSIS List files with name, path, and size.
#>
function Show-ListFilesDetail {
  Get-ChildItem -Recurse -File | ForEach-Object {
    "NAME: $($_.Name)  |  PATH: $($_.FullName)  |  SIZE: $($_.Length)"
    ""
  }
}
Set-Alias -Name list-files -Value Show-ListFilesDetail

<#
.SYNOPSIS Check which directories in current dir contain files.
.PARAMETER Recurse
  Recurse into subdirectories.
#>
function Show-ContainsFiles {
  param([switch]$Recurse)
  $depth = if ($Recurse) { [int]::MaxValue } else { 1 }
  Get-ChildItem -Directory -Depth $depth | Where-Object {
    (Get-ChildItem $_.FullName -File -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null
  } | ForEach-Object { $_.FullName }
}
Set-Alias -Name contains-files -Value Show-ContainsFiles

#endregion File_Analysis

# ═══════════════════════════════════════════════════════════════════════════
