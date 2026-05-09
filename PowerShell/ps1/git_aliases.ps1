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

