<# ═══════════════════════════════════════════════════════════════════════════
  Profile.pub.ps1 — Publicable PowerShell Profile
  Transpiled from ~/.bashrc publicable section
  For Windows PowerShell 5.1+ / PowerShell 7+ (pwsh)
═══════════════════════════════════════════════════════════════════════════ #>

#region Pretty_Output_Helpers

function _pretty_hdr {
  param([string]$Title)
  $w = 62
  $line = '═' * $w
  Write-Host ""
  Write-Host "╔${line}╗" -ForegroundColor Cyan
  Write-Host ("║ {0,-${w}}" -f $Title) -ForegroundColor Yellow -NoNewline
  Write-Host "" -ForegroundColor Cyan
  Write-Host "╚${line}╝" -ForegroundColor Cyan
}

function _pretty_ftr {
  $line = '─' * 64
  Write-Host $line -ForegroundColor DarkGray
  Write-Host ""
}

function _pretty_nl {
  [CmdletBinding()]
  param([Parameter(ValueFromPipeline)] [string[]]$Lines)
  begin { $i = 1 }
  process {
    foreach ($l in $Lines) {
      $num = "{0,5}" -f $i
      Write-Host "$num │ " -ForegroundColor Gray -NoNewline
      if ($l -match '^\s*#') {
        Write-Host $l -ForegroundColor Green
      } else {
        Write-Host $l
      }
      $i++
    }
  }
}

#endregion Pretty_Output_Helpers

# ═══════════════════════════════════════════════════════════════════════════
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
function Show-Hostype {
  [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
}
Set-Alias -Name show-hostype -Value Show-Hostype

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
#region Basic_Commands
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Shortcut for mkdir (New-Item -ItemType Directory).
#>
function mkd { param([string]$Path) New-Item -ItemType Directory -Path $Path -Force }
Set-Alias -Name mkdir-p -Value mkd

<#
.SYNOPSIS Decode a percent-encoded URI string.
.PARAMETER Uri
  The percent-encoded string to decode.
#>
function Invoke-UriDecode {
  param([Parameter(Mandatory)][string]$Uri)
  [System.Uri]::UnescapeDataString($Uri)
}
Set-Alias -Name uri-decode -Value Invoke-UriDecode

<#
.SYNOPSIS Printf with field-width, delimiter, and string substitution.
.PARAMETER Delimiter
  Fill character flag (-, 0, +, or empty).
.PARAMETER Width
  Field width.
.PARAMETER Target
  String to format (required).
.PARAMETER Pattern
  Pattern to replace in target (required).
.PARAMETER Substitute
  Replacement string (required).
#>
function Invoke-PrintfTr {
  param(
    [string]$Delimiter = '',
    [int]$Width = 0,
    [Parameter(Mandatory)][string]$Target,
    [Parameter(Mandatory)][string]$Pattern,
    [Parameter(Mandatory)][string]$Substitute
  )
  $result = $Target -replace [regex]::Escape($Pattern), $Substitute
  if ($Width -gt 0) {
    switch ($Delimiter) {
      '-' { $result = $result.PadRight($Width) }
      '0' { $result = $result.PadLeft($Width, '0') }
      default { $result = $result.PadLeft($Width) }
    }
  }
  $result
}
Set-Alias -Name printf-tr -Value Invoke-PrintfTr

<#
.SYNOPSIS List files with index numbers and display file contents by index.
.PARAMETER Index
  1-based index of the file to display (default: 1).
#>
function Show-CatIndexed {
  param([int]$Index = 1)
  $files = Get-ChildItem -File | Sort-Object Name
  $i = 1
  foreach ($f in $files) {
    Write-Host ("{0,4} │ {1}" -f $i, $f.Name)
    $i++
  }
  if ($Index -ge 1 -and $Index -le $files.Count) {
    $target = $files[$Index - 1]
    Write-Host ""
    Write-Host "─── Contents of [$Index] $($target.Name) ───"
    Get-Content $target.FullName -ErrorAction SilentlyContinue
  }
}
Set-Alias -Name cat-indexed -Value Show-CatIndexed

<#
.SYNOPSIS Run multiple commands against a single target argument.
.PARAMETER Target
  The target argument for all commands.
.PARAMETER Commands
  Script blocks to run against the target.
#>
function Invoke-RunCmds {
  param(
    [Parameter(Mandatory)][string]$Target,
    [Parameter(Mandatory, ValueFromRemainingArguments)][scriptblock[]]$Commands
  )
  foreach ($cmd in $Commands) {
    & $cmd $Target
  }
}
Set-Alias -Name run-cmds -Value Invoke-RunCmds

<#
.SYNOPSIS Custom ls output: LastWriteTime, Length, Name.
.PARAMETER Path
  Directory to list (default: current).
#>
function Show-LsLah859 {
  param([string]$Path = '.')
  Get-ChildItem -Path $Path |
    Format-Table @{L='Time'; E={$_.LastWriteTime.ToString('HH:mm')}},
                 @{L='Size'; E={
                   if ($_.PSIsContainer) { '<DIR>' }
                   else {
                     $s = $_.Length
                     if ($s -ge 1MB) { "{0:N1}M" -f ($s/1MB) }
                     elseif ($s -ge 1KB) { "{0:N1}K" -f ($s/1KB) }
                     else { "${s}B" }
                   }
                 }},
                 Name -AutoSize
}
Set-Alias -Name ls-lah-859 -Value Show-LsLah859

<#
.SYNOPSIS Count total lines in directory excluding vendor folders.
#>
function Measure-LinesNoVendors {
  $exclude = @('vendor', 'node_modules', '.git', 'dist', 'build')
  $files = 0; $total = 0
  Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
      $skip = $false
      foreach ($e in $exclude) {
        if ($_.FullName -match "[\\/]$e[\\/]") { $skip = $true; break }
      }
      -not $skip
    } | ForEach-Object {
      $lines = (Get-Content $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
      $total += $lines; $files++
      Write-Host "$($_.FullName) $total"
    }
  Write-Host "-> TOTAL: $total lines in $files files"
}
Set-Alias -Name wc-l-novendors -Value Measure-LinesNoVendors

#endregion Basic_Commands

# ═══════════════════════════════════════════════════════════════════════════
#region Pretty_Basic_Commands
# ═══════════════════════════════════════════════════════════════════════════

function Invoke-UriDecodePretty {
  param([Parameter(Mandatory)][string]$Uri)
  _pretty_hdr "URI Decode"
  $result = [System.Uri]::UnescapeDataString($Uri)
  Write-Host "  Input:  $Uri" -ForegroundColor Blue
  Write-Host "  Output: $result" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name uri-decode-pretty -Value Invoke-UriDecodePretty

function Show-CatIndexedPretty {
  param([int]$Index = 0)
  _pretty_hdr "Indexed File Listing"
  $files = Get-ChildItem -File | Sort-Object Name
  $i = 1
  foreach ($f in $files) {
    Write-Host ("{0,4} │ {1}" -f $i, $f.Name) -ForegroundColor Yellow
    $i++
  }
  if ($Index -ge 1 -and $Index -le $files.Count) {
    $target = $files[$Index - 1]
    Write-Host ""
    Write-Host "  ► Contents of [$Index] $($target.Name):" -ForegroundColor Cyan
    Get-Content $target.FullName -ErrorAction SilentlyContinue | _pretty_nl
  }
  _pretty_ftr
}
Set-Alias -Name cat-indexed-pretty -Value Show-CatIndexedPretty

function Invoke-RunCmdsPretty {
  param(
    [Parameter(Mandatory)][string]$Target,
    [Parameter(Mandatory, ValueFromRemainingArguments)][scriptblock[]]$Commands
  )
  _pretty_hdr "Run Multiple Commands"
  Write-Host "  Target: $Target" -ForegroundColor Blue
  Write-Host ""
  foreach ($cmd in $Commands) {
    Write-Host "  ► $cmd" -ForegroundColor Yellow
    & $cmd $Target 2>$null | _pretty_nl
    Write-Host ""
  }
  _pretty_ftr
}
Set-Alias -Name run-cmds-pretty -Value Invoke-RunCmdsPretty

function Invoke-PrintfTrPretty {
  param(
    [string]$Delimiter = '',
    [int]$Width = 0,
    [Parameter(Mandatory)][string]$Target,
    [Parameter(Mandatory)][string]$Pattern,
    [Parameter(Mandatory)][string]$Substitute
  )
  _pretty_hdr "Printf with TR Substitution"
  try {
    $result = Invoke-PrintfTr @PSBoundParameters
    Write-Host "  Result: $result" -ForegroundColor Green
  } catch {
    Write-Host "  ✗ Error: $_" -ForegroundColor Red
  }
  _pretty_ftr
}
Set-Alias -Name printf-tr-pretty -Value Invoke-PrintfTrPretty

#endregion Pretty_Basic_Commands

# ═══════════════════════════════════════════════════════════════════════════
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
#region Filesystem_Utilities

# --- NEW EQUIVALENTS ---
function get-mimeapps {
  <#
  .SYNOPSIS
  Displays the user's default applications list and MIME configurations.
  #>
  Get-Content ~/.config/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-mimeapps get-mimeapps

function get-share-mimeapps {
  Get-Content ~/.local/share/applications/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-share-mimeapps get-share-mimeapps

function get-compose-chars {
  <#
  .SYNOPSIS
  Displays the correct native sequence of Compose keys.
  #>
  Get-Content /usr/share/X11/locale/en_US.UTF-8/Compose -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-compose-chars get-compose-chars
Set-Alias show-compose-chars get-compose-chars

function get-all-mimeapps {
  Get-Content ~/.config/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
  Get-Content ~/.local/share/applications/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-all-mimeapps get-all-mimeapps
# -----------------------

# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Move files into subdirectories of 100 files each (pack1/, pack2/, ...).
#>
function Invoke-PackFiles {
  $files = Get-ChildItem -File
  $acc = 0; $packCount = 1
  foreach ($f in $files) {
    if ($acc -eq 100 -or $acc -eq 0) {
      $dir = "pack$packCount"
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
      Write-Host "Packing files into directory: $dir"
      $packCount++; $acc = 0
    }
    Move-Item $f.FullName -Destination $dir
    $acc++
  }
  Write-Host "Packed $($files.Count) files into $($packCount - 1) directories"
}
Set-Alias -Name packf -Value Invoke-PackFiles

#endregion Filesystem_Utilities

# ═══════════════════════════════════════════════════════════════════════════
#region Git_Aliases
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Pretty git log showing author, date, subject for all branches.
#>
function Show-GitLogPretty {
  git log --all --pretty=format:"%ae - %cd - %s" --date=short
}
Set-Alias -Name git-log-pretty -Value Show-GitLogPretty

<#
.SYNOPSIS Git stats: lines added/removed, project line count, file count, commits.
.PARAMETER Author
  Author email filter (default: git config user.email).
#>
function Show-GitStats {
  param([string]$Author)
  if (-not $Author) { $Author = git config user.email }
  Write-Host "Author email: $Author"
  Write-Host ""
  git log --author="$Author" --pretty=tformat: --numstat 2>$null |
    ForEach-Object {
      $parts = $_ -split '\t'
      if ($parts.Count -ge 2) { "$($parts[0])`t$($parts[1])" }
    } | Out-Null
  # Simpler approach via git
  $stats = git log --author="$Author" --pretty=tformat: --numstat 2>$null |
    Where-Object { $_ -match '^\d' } |
    ForEach-Object {
      $p = $_ -split '\t'
      [PSCustomObject]@{ Add = [int]$p[0]; Sub = [int]$p[1] }
    }
  $add = ($stats | Measure-Object -Property Add -Sum).Sum
  $sub = ($stats | Measure-Object -Property Sub -Sum).Sum
  Write-Host "Lines added:   $add"
  Write-Host "Lines removed: $sub"
  Write-Host "Net lines:     $($add - $sub)"
  Write-Host ""
  $excludeDirs = @('vendor','node_modules','.git','dist','build')
  $allFiles = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
      $skip = $false
      foreach ($e in $excludeDirs) {
        if ($_.FullName -match "[\\/]$e[\\/]") { $skip = $true; break }
      }
      -not $skip
    }
  $totalLines = ($allFiles | ForEach-Object {
    (Get-Content $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
  } | Measure-Object -Sum).Sum
  Write-Host "Total lines in project (ignoring vendors): $totalLines"
  Write-Host "Total files in project (ignoring vendors): $($allFiles.Count)"
  Write-Host ""
  Write-Host "Total commits (all branches): $(git rev-list --count --all 2>$null)"
  Write-Host "Total commits (current branch): $(git rev-list --count HEAD 2>$null)"
}
Set-Alias -Name git-stats -Value Show-GitStats

#region Git_Basic
function Invoke-Gra  { git remote add @args }; Set-Alias -Name gra -Value Invoke-Gra
function Invoke-GraO { git remote add origin @args }; Set-Alias -Name gra-o -Value Invoke-GraO
function Invoke-Ga   { git add @args }; Set-Alias -Name ga -Value Invoke-Ga
function Invoke-Gal  { git add . }; Set-Alias -Name gal -Value Invoke-Gal
function Invoke-Gc   { git commit @args }; Set-Alias -Name gc -Value Invoke-Gc
function Invoke-Gca  { git commit -a -m @args }; Set-Alias -Name gca -Value Invoke-Gca
function Invoke-Galps {
  param([Parameter(Mandatory)][string]$Message)
  $top = git rev-parse --show-toplevel 2>$null
  if ($top) { Set-Location $top }
  git add .
  git commit -am $Message @args
}
Set-Alias -Name galps -Value Invoke-Galps
#endregion Git_Basic

#region Git_Log_Status
function Invoke-Gl      { git log @args };            Set-Alias -Name gl -Value Invoke-Gl
function Invoke-GlO     { git log --oneline @args };  Set-Alias -Name gl-o -Value Invoke-GlO
function Invoke-Gs      { git status @args };          Set-Alias -Name gs -Value Invoke-Gs
function Invoke-Gsw     { git show @args };            Set-Alias -Name gsw -Value Invoke-Gsw
function Invoke-Grl     { git reflog @args };          Set-Alias -Name grl -Value Invoke-Grl
function Invoke-Gsl     { git shortlog @args };        Set-Alias -Name gsl -Value Invoke-Gsl
function Invoke-Gci     { git check-ignore -v @args }; Set-Alias -Name gci -Value Invoke-Gci
function Invoke-Glr     { git ls-remote @args };       Set-Alias -Name glr -Value Invoke-Glr
function Invoke-Glt     { git ls-tree @args };         Set-Alias -Name glt -Value Invoke-Glt
function Invoke-Glost   { git fsck --lost-found };     Set-Alias -Name glost -Value Invoke-Glost
function Invoke-Gfsckf  { git fsck --full };           Set-Alias -Name gfsckf -Value Invoke-Gfsckf
function Invoke-GitGcAgro { git gc --aggressive --prune=now }; Set-Alias -Name gitgcagro -Value Invoke-GitGcAgro
#endregion Git_Log_Status

#region Git_Remote
function Invoke-Gps    { git push @args };                 Set-Alias -Name gps -Value Invoke-Gps
function Invoke-GpsOh  { git push origin HEAD @args };     Set-Alias -Name gps-oh -Value Invoke-GpsOh
function Invoke-GpsOhm { git push origin HEAD:main @args }; Set-Alias -Name gps-ohm -Value Invoke-GpsOhm
function Invoke-Gpl    { git pull @args };                 Set-Alias -Name gpl -Value Invoke-Gpl
function Invoke-Gf     { git fetch @args };                Set-Alias -Name gf -Value Invoke-Gf
#endregion Git_Remote

#region Git_Branch_Diff
function Invoke-Gd   { git diff @args };     Set-Alias -Name gd -Value Invoke-Gd
function Invoke-Gb   { git branch @args };   Set-Alias -Name gb -Value Invoke-Gb
function Invoke-Gbv  { git branch -v @args }; Set-Alias -Name gbv -Value Invoke-Gbv
function Invoke-Gsc  { git switch -c @args }; Set-Alias -Name gsc -Value Invoke-Gsc
function Invoke-Gco  { git checkout @args };  Set-Alias -Name gco -Value Invoke-Gco
function Invoke-Gtop { git rev-parse --show-toplevel }; Set-Alias -Name gtop -Value Invoke-Gtop
function Invoke-Gm   { git merge @args };    Set-Alias -Name gm -Value Invoke-Gm
function Invoke-Grb  { git rebase @args };   Set-Alias -Name grb -Value Invoke-Grb
#endregion Git_Branch_Diff

#region Git_Reset_Revert
function Invoke-Grs     { git reset @args };            Set-Alias -Name grs -Value Invoke-Grs
function Invoke-GrsH    { git reset --hard @args };     Set-Alias -Name grs-h -Value Invoke-GrsH
function Invoke-GrsS    { git reset --soft @args };     Set-Alias -Name grs-s -Value Invoke-GrsS
function Invoke-Grs1    { git reset HEAD~1 };           Set-Alias -Name 'grs--1' -Value Invoke-Grs1
function Invoke-GrsH1   { git reset --hard HEAD~1 };    Set-Alias -Name 'grs-h--1' -Value Invoke-GrsH1
function Invoke-GrsS1   { git reset --soft HEAD~1 };    Set-Alias -Name 'grs-s--1' -Value Invoke-GrsS1
function Invoke-GrsOg   { git reset origin @args };     Set-Alias -Name 'grs--og' -Value Invoke-GrsOg
function Invoke-GrsHOg  { git reset --hard origin @args }; Set-Alias -Name 'grs-h--og' -Value Invoke-GrsHOg
function Invoke-GrsSOg  { git reset --soft origin @args }; Set-Alias -Name 'grs-s--og' -Value Invoke-GrsSOg
function Invoke-Grv     { git revert @args };           Set-Alias -Name grv -Value Invoke-Grv
function Invoke-GrvNc   { git revert --no-commit @args }; Set-Alias -Name grv-nc -Value Invoke-GrvNc
function Invoke-GrvH    { git revert HEAD };            Set-Alias -Name 'grv--h' -Value Invoke-GrvH
function Invoke-GrvM1   { git revert -m 1 @args };     Set-Alias -Name 'grv-m--1' -Value Invoke-GrvM1
#endregion Git_Reset_Revert

#region Git_Stash
function Invoke-Gst      { git stash @args };                     Set-Alias -Name gst -Value Invoke-Gst
function Invoke-GstPs    { git stash push @args };                Set-Alias -Name gst-ps -Value Invoke-GstPs
function Invoke-GstPpU   { git stash push --include-untracked @args }; Set-Alias -Name gst-pp-u -Value Invoke-GstPpU
function Invoke-GstPpA   { git stash push --all @args };          Set-Alias -Name gst-pp-a -Value Invoke-GstPpA
function Invoke-GstPpKi  { git stash push --keep-index @args };   Set-Alias -Name gst-pp-ki -Value Invoke-GstPpKi
function Invoke-GstPp    { git stash pop @args };                 Set-Alias -Name gst-pp -Value Invoke-GstPp
function Invoke-GstA     { git stash apply @args };               Set-Alias -Name gst-a -Value Invoke-GstA
function Invoke-GstD     { git stash drop @args };                Set-Alias -Name gst-d -Value Invoke-GstD
function Invoke-GstL     { git stash list };                      Set-Alias -Name gst-l -Value Invoke-GstL
function Invoke-GstS     { git stash show @args };                Set-Alias -Name gst-s -Value Invoke-GstS
function Invoke-GstC     { git stash clear };                     Set-Alias -Name gst-c -Value Invoke-GstC
#endregion Git_Stash

#endregion Git_Aliases

# ═══════════════════════════════════════════════════════════════════════════
#region Navigation_Aliases
# ═══════════════════════════════════════════════════════════════════════════

function Set-Desk { Set-Location ~/Desktop };    Set-Alias -Name desk -Value Set-Desk
function Set-Docs { Set-Location ~/Documents };  Set-Alias -Name docs -Value Set-Docs
function Set-Dl   { Set-Location ~/Downloads };  Set-Alias -Name dl -Value Set-Dl
function Set-DotDot    { Set-Location .. };       Set-Alias -Name '..' -Value Set-DotDot
function Set-DotDotDot { Set-Location ../.. };    Set-Alias -Name '...' -Value Set-DotDotDot
function Set-Ilv  { Set-Location _inc/laravel }; Set-Alias -Name '.ilv' -Value Set-Ilv

#endregion Navigation_Aliases

# ═══════════════════════════════════════════════════════════════════════════
#region Laravel_PHP_Aliases
# ═══════════════════════════════════════════════════════════════════════════

function Invoke-Artmrs   { php artisan migrate:reset }
Set-Alias -Name artmrs -Value Invoke-Artmrs

function Invoke-Artmsd   { php artisan migrate:fresh --seed }
Set-Alias -Name artmsd -Value Invoke-Artmsd

function Invoke-Artmst   { php artisan migrate:status }
Set-Alias -Name artmst -Value Invoke-Artmst

function Invoke-ArtmrsSd {
  php artisan migrate:status
  php artisan migrate:reset
  php artisan migrate:fresh --seed
}
Set-Alias -Name artmrs-sd -Value Invoke-ArtmrsSd

function Invoke-Artcl {
  php artisan permission:cache-reset
  php artisan config:clear
  php artisan cache:clear
  php artisan optimize:clear
  php artisan route:clear
  php artisan view:clear
  php artisan clear-compiled
}
Set-Alias -Name artcl -Value Invoke-Artcl

function Invoke-Artsv { php artisan serve }
Set-Alias -Name artsv -Value Invoke-Artsv

function Invoke-Artclrs {
  Invoke-Artcl
  $cache = @(
    'bootstrap/cache/services.php',
    'bootstrap/cache/packages.php',
    'bootstrap/cache/compiled.php',
    'bootstrap/cache/routes.php'
  )
  foreach ($f in $cache) { Remove-Item $f -ErrorAction SilentlyContinue }
  composer dump-autoload -o
  php artisan migrate:status
  php artisan migrate:reset
  php artisan migrate:fresh --seed
  php artisan route:list --sort=uri
  php artisan serve
}
Set-Alias -Name artclrs -Value Invoke-Artclrs

function Invoke-Artrtl { php artisan route:list --sort=uri }
Set-Alias -Name artrtl -Value Invoke-Artrtl

function Remove-LaravelCache {
  $cache = @(
    'bootstrap/cache/services.php',
    'bootstrap/cache/packages.php',
    'bootstrap/cache/compiled.php',
    'bootstrap/cache/routes.php'
  )
  foreach ($f in $cache) { Remove-Item $f -ErrorAction SilentlyContinue }
}
Set-Alias -Name laravel-rm-cache -Value Remove-LaravelCache

function Invoke-Compdp { composer dump-autoload -o }
Set-Alias -Name compdp -Value Invoke-Compdp

function Invoke-Mysqlr { mysql -u root -p }
Set-Alias -Name mysqlr -Value Invoke-Mysqlr

#endregion Laravel_PHP_Aliases

# ═══════════════════════════════════════════════════════════════════════════
#region HTML_CSS_Tools
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Strip all HTML comments from a file and reformat with Prettier.
.PARAMETER Path
  Path to the HTML file.
#>
function Remove-HtmlComments {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"; return
  }
  $content = Get-Content $Path -Raw
  $content = [regex]::Replace($content, '<!--(?!.*?--\s*>.*?<!--).*?-->', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)
  Set-Content -Path $Path -Value $content -NoNewline
  npx prettier --parser html --print-width 120 --tab-width 2 --no-semi --single-attribute-per-line --html-whitespace-sensitivity ignore --write $Path
}
Set-Alias -Name strip-html-comments -Value Remove-HtmlComments

<#
.SYNOPSIS Extract <style> content from HTML, minify with clean-css-cli.
.PARAMETER Src
  Source HTML file.
.PARAMETER ExtractDst
  Destination for extracted CSS.
.PARAMETER MinDst
  Destination for minified CSS.
#>
function Export-MinifyCss {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$ExtractDst,
    [Parameter(Mandatory)][string]$MinDst
  )
  if (-not (Test-Path $Src)) {
    Write-Error "Source not found: $Src"; return
  }
  $html = Get-Content $Src -Raw
  if ($html -match '(?s)<style[^>]*>(.*?)</style>') {
    Set-Content -Path $ExtractDst -Value $Matches[1] -NoNewline
    npx clean-css-cli -o $MinDst $ExtractDst
    Get-Item $ExtractDst, $MinDst | ForEach-Object {
      Write-Host "$($_.Length) $($_.Name)"
    }
  } else {
    Write-Warning "No <style> block found in $Src"
  }
}
Set-Alias -Name extract-min-css -Value Export-MinifyCss

<#
.SYNOPSIS Count HTML comments and total lines in a file.
.PARAMETER Path
  Path to the HTML file.
#>
function Measure-HtmlComments {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"; return
  }
  $content = Get-Content $Path
  $comments = ($content | Select-String '<!--').Count
  $lines = $content.Count
  Write-Host "Comments: $comments"
  Write-Host "Lines:    $lines"
}
Set-Alias -Name count-html-comments -Value Measure-HtmlComments

<#
.SYNOPSIS Check which CSS minifier CLI is available (csso or clean-css-cli).
#>
function Test-CssMinifier {
  $csso = npx csso --version 2>$null
  if ($csso) { Write-Host "csso: $csso" }
  else { Write-Host "csso: not found" }
  $cleancss = npx clean-css-cli --version 2>$null
  if ($cleancss) { Write-Host "clean-css-cli: $cleancss" }
  else { Write-Host "clean-css-cli: not found" }
}
Set-Alias -Name check-css-minifier -Value Test-CssMinifier

<#
.SYNOPSIS Inject a minified CSS file into the <style> block of an HTML file.
.PARAMETER Src
  HTML file to inject into.
.PARAMETER MinCss
  Minified CSS file to inject.
#>
function Set-MinifiedCss {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$MinCss
  )
  if (-not (Test-Path $Src)) { Write-Error "Source not found: $Src"; return }
  if (-not (Test-Path $MinCss)) { Write-Error "CSS not found: $MinCss"; return }
  $css = Get-Content $MinCss -Raw
  $html = Get-Content $Src -Raw
  $html = [regex]::Replace($html, '(?s)(<style[^>]*>).*?(</style>)', "`$1$css`$2")
  Set-Content -Path $Src -Value $html -NoNewline
  $lines = (Get-Content $Src).Count
  Write-Host "✅ Injected into $Src ($lines lines)"
}
Set-Alias -Name inject-min-css -Value Set-MinifiedCss

#endregion HTML_CSS_Tools

# ═══════════════════════════════════════════════════════════════════════════
#region Pretty_HTML_CSS_Tools
# ═══════════════════════════════════════════════════════════════════════════

function Remove-HtmlCommentsPretty {
  param([Parameter(Mandatory)][string]$Path)
  _pretty_hdr "Strip HTML Comments & Prettier Format"
  if (-not (Test-Path $Path)) {
    Write-Host "  ✗ File not found: $Path" -ForegroundColor Red
    _pretty_ftr; return
  }
  $before = (Get-Content $Path | Select-String '<!--').Count
  Remove-HtmlComments -Path $Path
  $after = (Get-Content $Path | Select-String '<!--').Count
  Write-Host ""
  Write-Host "  File:   $Path" -ForegroundColor Blue
  Write-Host "  Before: $before comments" -ForegroundColor Yellow
  Write-Host "  After:  $after comments" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name strip-html-comments-pretty -Value Remove-HtmlCommentsPretty

function Export-MinifyCssPretty {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$ExtractDst,
    [Parameter(Mandatory)][string]$MinDst
  )
  _pretty_hdr "Extract & Minify CSS from HTML"
  Export-MinifyCss -Src $Src -ExtractDst $ExtractDst -MinDst $MinDst
  Write-Host ""
  Write-Host "  Source:    $Src" -ForegroundColor Blue
  if (Test-Path $ExtractDst) {
    Write-Host "  Extracted: $ExtractDst ($((Get-Item $ExtractDst).Length) bytes)" -ForegroundColor Yellow
  }
  if (Test-Path $MinDst) {
    Write-Host "  Minified:  $MinDst ($((Get-Item $MinDst).Length) bytes)" -ForegroundColor Green
  }
  _pretty_ftr
}
Set-Alias -Name extract-min-css-pretty -Value Export-MinifyCssPretty

function Measure-HtmlCommentsPretty {
  param([Parameter(Mandatory)][string]$Path)
  _pretty_hdr "HTML Comment & Line Count"
  if (-not (Test-Path $Path)) {
    Write-Host "  ✗ File not found: $Path" -ForegroundColor Red
    _pretty_ftr; return
  }
  $content = Get-Content $Path
  $comments = ($content | Select-String '<!--').Count
  $lines = $content.Count
  Write-Host "  File:     $Path" -ForegroundColor Blue
  Write-Host "  Comments: $comments" -ForegroundColor Yellow
  Write-Host "  Lines:    $lines" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name count-html-comments-pretty -Value Measure-HtmlCommentsPretty

function Test-CssMinifierPretty {
  _pretty_hdr "CSS Minifier Availability"
  $csso = npx csso --version 2>$null
  if ($csso) { Write-Host "  ✓ csso: $csso" -ForegroundColor Green }
  else { Write-Host "  ✗ csso: not found" -ForegroundColor Red }
  $cleancss = npx clean-css-cli --version 2>$null
  if ($cleancss) { Write-Host "  ✓ clean-css-cli: $cleancss" -ForegroundColor Green }
  else { Write-Host "  ✗ clean-css-cli: not found" -ForegroundColor Red }
  _pretty_ftr
}
Set-Alias -Name check-css-minifier-pretty -Value Test-CssMinifierPretty

function Set-MinifiedCssPretty {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$MinCss
  )
  _pretty_hdr "Inject Minified CSS into HTML"
  if (-not (Test-Path $Src)) {
    Write-Host "  ✗ Source not found: $Src" -ForegroundColor Red
    _pretty_ftr; return
  }
  if (-not (Test-Path $MinCss)) {
    Write-Host "  ✗ CSS not found: $MinCss" -ForegroundColor Red
    _pretty_ftr; return
  }
  $linesBefore = (Get-Content $Src).Count
  Set-MinifiedCss -Src $Src -MinCss $MinCss
  $linesAfter = (Get-Content $Src).Count
  Write-Host "  HTML:       $Src" -ForegroundColor Blue
  Write-Host "  CSS source: $MinCss" -ForegroundColor Yellow
  Write-Host "  Lines:      $linesBefore → $linesAfter" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name inject-min-css-pretty -Value Set-MinifiedCssPretty

#endregion Pretty_HTML_CSS_Tools
