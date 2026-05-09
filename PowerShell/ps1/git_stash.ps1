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
