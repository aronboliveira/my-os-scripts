#region HTML_CSS_Tools
# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Strip all HTML comments from a file and reformat with Prettier.
.PARAMETER Path
  Path to the HTML file.
#>
function Remove-HtmlComments {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"; return
  }
  $content = Get-Content $Path -Raw
  $content = [regex]::Replace($content, '<!--(?!.*?--\s*>.*?<!--).*?-->', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)
  Set-Content -Path $Path -Value $content -NoNewline
  npx prettier --parser html --print-width 120 --tab-width 2 --no-semi --single-attribute-per-line --html-whitespace-sensitivity ignore --write $Path
}
Set-Alias -Name strip-html-comments -Value Remove-HtmlComments

<#
.SYNOPSIS Extract <style> content from HTML, minify with clean-css-cli.
.PARAMETER Src
  Source HTML file.
.PARAMETER ExtractDst
  Destination for extracted CSS.
.PARAMETER MinDst
  Destination for minified CSS.
#>
function Export-MinifyCss {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$ExtractDst,
    [Parameter(Mandatory)][string]$MinDst
  )
  if (-not (Test-Path $Src)) {
    Write-Error "Source not found: $Src"; return
  }
  $html = Get-Content $Src -Raw
  if ($html -match '(?s)<style[^>]*>(.*?)</style>') {
    Set-Content -Path $ExtractDst -Value $Matches[1] -NoNewline
    npx clean-css-cli -o $MinDst $ExtractDst
    Get-Item $ExtractDst, $MinDst | ForEach-Object {
      Write-Host "$($_.Length) $($_.Name)"
    }
  } else {
    Write-Warning "No <style> block found in $Src"
  }
}
Set-Alias -Name extract-min-css -Value Export-MinifyCss

<#
.SYNOPSIS Count HTML comments and total lines in a file.
.PARAMETER Path
  Path to the HTML file.
#>
function Measure-HtmlComments {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"; return
  }
  $content = Get-Content $Path
  $comments = ($content | Select-String '<!--').Count
  $lines = $content.Count
  Write-Host "Comments: $comments"
  Write-Host "Lines:    $lines"
}
Set-Alias -Name count-html-comments -Value Measure-HtmlComments

<#
.SYNOPSIS Check which CSS minifier CLI is available (csso or clean-css-cli).
#>
function Test-CssMinifier {
  $csso = npx csso --version 2>$null
  if ($csso) { Write-Host "csso: $csso" }
  else { Write-Host "csso: not found" }
  $cleancss = npx clean-css-cli --version 2>$null
  if ($cleancss) { Write-Host "clean-css-cli: $cleancss" }
  else { Write-Host "clean-css-cli: not found" }
}
Set-Alias -Name check-css-minifier -Value Test-CssMinifier

<#
.SYNOPSIS Inject a minified CSS file into the <style> block of an HTML file.
.PARAMETER Src
  HTML file to inject into.
.PARAMETER MinCss
  Minified CSS file to inject.
#>
function Set-MinifiedCss {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$MinCss
  )
  if (-not (Test-Path $Src)) { Write-Error "Source not found: $Src"; return }
  if (-not (Test-Path $MinCss)) { Write-Error "CSS not found: $MinCss"; return }
  $css = Get-Content $MinCss -Raw
  $html = Get-Content $Src -Raw
  $html = [regex]::Replace($html, '(?s)(<style[^>]*>).*?(</style>)', "`$1$css`$2")
  Set-Content -Path $Src -Value $html -NoNewline
  $lines = (Get-Content $Src).Count
  Write-Host "✅ Injected into $Src ($lines lines)"
}
Set-Alias -Name inject-min-css -Value Set-MinifiedCss

#endregion HTML_CSS_Tools

# ═══════════════════════════════════════════════════════════════════════════
