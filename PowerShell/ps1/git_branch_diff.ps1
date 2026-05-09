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

