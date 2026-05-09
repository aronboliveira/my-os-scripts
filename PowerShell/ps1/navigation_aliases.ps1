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
