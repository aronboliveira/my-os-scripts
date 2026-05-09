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

