#region Git_Remote
function Invoke-Gps    { git push @args };                 Set-Alias -Name gps -Value Invoke-Gps
function Invoke-GpsOh  { git push origin HEAD @args };     Set-Alias -Name gps-oh -Value Invoke-GpsOh
function Invoke-GpsOhm { git push origin HEAD:main @args }; Set-Alias -Name gps-ohm -Value Invoke-GpsOhm
function Invoke-Gpl    { git pull @args };                 Set-Alias -Name gpl -Value Invoke-Gpl
function Invoke-Gf     { git fetch @args };                Set-Alias -Name gf -Value Invoke-Gf
#endregion Git_Remote

