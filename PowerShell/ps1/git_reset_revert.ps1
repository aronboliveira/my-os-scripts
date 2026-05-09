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

