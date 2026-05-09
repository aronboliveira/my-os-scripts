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

<#
.SYNOPSIS Calculate Modulus N check digits for a numeric string (e.g. CPF mod-11, CNPJ).
.PARAMETER State
  Digit string (e.g. "123456789").
.PARAMETER Total
  Modulus base (e.g. 11).
.EXAMPLE
  Get-CheckSum -State "123456789" -Total 11
#>
function Get-CheckSum {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$State,
    [Parameter(Mandatory)][int]$Total
  )
  if ($State -notmatch '^\d+$') {
    Write-Error "State must be a numeric string."; return
  }
  if ($Total -lt 2) {
    Write-Error "Total must be an integer >= 2."; return
  }
  $stateLen = $State.Length
  $diff = $Total - $stateLen
  if ($diff -lt 1) {
    Write-Error "Total must be greater than the length of State."; return
  }
  for ($pos = 1; $pos -le $diff; $pos++) {
    $curLen = $stateLen + $pos - 1
    $sr = 0
    for ($i = 0; $i -lt $curLen; $i++) {
      $digit = [int]::Parse($State[$i].ToString())
      $weight = $stateLen + $pos - $i
      $sr += $digit * $weight
    }
    $rest = $sr % $Total
    $checkDigit = if ($rest -lt 2) { 0 } else { $Total - $rest }
    $State += $checkDigit.ToString()
  }
  $State
}
Set-Alias -Name calculate-check-sum -Value Get-CheckSum
Set-Alias -Name calc-checksum -Value Get-CheckSum

<#
.SYNOPSIS Change directory up N levels using dots or .{N}.
.PARAMETER Dots
  Dot pattern (e.g. ... or .{3}).
.EXAMPLE
  cdup ...
.EXAMPLE
  cdup .{3}
#>
function Invoke-CdUp {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$Dots)

  $usage = "Usage: cdup .... | cdup .{N}"
  if ($Dots -match '^\.+$') {
    $n = $Dots.Length
  } elseif ($Dots -match '^\.\{(\d+)\}$') {
    $n = [int]$Matches[1]
  } else {
    Write-Error $usage
    return
  }

  if ($n -lt 1) {
    Write-Error "N must be >= 1"
    return
  }

  $sep = [System.IO.Path]::DirectorySeparatorChar
  $path = (@('..') * $n) -join $sep
  Set-Location -Path $path
}
Set-Alias -Name cdup -Value Invoke-CdUp

#endregion Basic_Commands

# ═══════════════════════════════════════════════════════════════════════════
