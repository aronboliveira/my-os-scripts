#region Pretty_HTML_CSS_Tools
# ═══════════════════════════════════════════════════════════════════════════

function Remove-HtmlCommentsPretty {
  param([Parameter(Mandatory)][string]$Path)
  _pretty_hdr "Strip HTML Comments & Prettier Format"
  if (-not (Test-Path $Path)) {
    Write-Host "  ✗ File not found: $Path" -ForegroundColor Red
    _pretty_ftr; return
  }
  $before = (Get-Content $Path | Select-String '<!--').Count
  Remove-HtmlComments -Path $Path
  $after = (Get-Content $Path | Select-String '<!--').Count
  Write-Host ""
  Write-Host "  File:   $Path" -ForegroundColor Blue
  Write-Host "  Before: $before comments" -ForegroundColor Yellow
  Write-Host "  After:  $after comments" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name strip-html-comments-pretty -Value Remove-HtmlCommentsPretty

function Export-MinifyCssPretty {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$ExtractDst,
    [Parameter(Mandatory)][string]$MinDst
  )
  _pretty_hdr "Extract & Minify CSS from HTML"
  Export-MinifyCss -Src $Src -ExtractDst $ExtractDst -MinDst $MinDst
  Write-Host ""
  Write-Host "  Source:    $Src" -ForegroundColor Blue
  if (Test-Path $ExtractDst) {
    Write-Host "  Extracted: $ExtractDst ($((Get-Item $ExtractDst).Length) bytes)" -ForegroundColor Yellow
  }
  if (Test-Path $MinDst) {
    Write-Host "  Minified:  $MinDst ($((Get-Item $MinDst).Length) bytes)" -ForegroundColor Green
  }
  _pretty_ftr
}
Set-Alias -Name extract-min-css-pretty -Value Export-MinifyCssPretty

function Measure-HtmlCommentsPretty {
  param([Parameter(Mandatory)][string]$Path)
  _pretty_hdr "HTML Comment & Line Count"
  if (-not (Test-Path $Path)) {
    Write-Host "  ✗ File not found: $Path" -ForegroundColor Red
    _pretty_ftr; return
  }
  $content = Get-Content $Path
  $comments = ($content | Select-String '<!--').Count
  $lines = $content.Count
  Write-Host "  File:     $Path" -ForegroundColor Blue
  Write-Host "  Comments: $comments" -ForegroundColor Yellow
  Write-Host "  Lines:    $lines" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name count-html-comments-pretty -Value Measure-HtmlCommentsPretty

function Test-CssMinifierPretty {
  _pretty_hdr "CSS Minifier Availability"
  $csso = npx csso --version 2>$null
  if ($csso) { Write-Host "  ✓ csso: $csso" -ForegroundColor Green }
  else { Write-Host "  ✗ csso: not found" -ForegroundColor Red }
  $cleancss = npx clean-css-cli --version 2>$null
  if ($cleancss) { Write-Host "  ✓ clean-css-cli: $cleancss" -ForegroundColor Green }
  else { Write-Host "  ✗ clean-css-cli: not found" -ForegroundColor Red }
  _pretty_ftr
}
Set-Alias -Name check-css-minifier-pretty -Value Test-CssMinifierPretty

function Set-MinifiedCssPretty {
  param(
    [Parameter(Mandatory)][string]$Src,
    [Parameter(Mandatory)][string]$MinCss
  )
  _pretty_hdr "Inject Minified CSS into HTML"
  if (-not (Test-Path $Src)) {
    Write-Host "  ✗ Source not found: $Src" -ForegroundColor Red
    _pretty_ftr; return
  }
  if (-not (Test-Path $MinCss)) {
    Write-Host "  ✗ CSS not found: $MinCss" -ForegroundColor Red
    _pretty_ftr; return
  }
  $linesBefore = (Get-Content $Src).Count
  Set-MinifiedCss -Src $Src -MinCss $MinCss
  $linesAfter = (Get-Content $Src).Count
  Write-Host "  HTML:       $Src" -ForegroundColor Blue
  Write-Host "  CSS source: $MinCss" -ForegroundColor Yellow
  Write-Host "  Lines:      $linesBefore → $linesAfter" -ForegroundColor Green
  _pretty_ftr
}
Set-Alias -Name inject-min-css-pretty -Value Set-MinifiedCssPretty

#endregion Pretty_HTML_CSS_Tools
