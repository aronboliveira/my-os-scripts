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

