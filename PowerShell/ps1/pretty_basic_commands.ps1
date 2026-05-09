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
