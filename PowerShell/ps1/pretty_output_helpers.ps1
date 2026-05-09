<# ═══════════════════════════════════════════════════════════════════════════
  Profile.pub.ps1 — Publicable PowerShell Profile
  Transpiled from ~/.bashrc publicable section
  For Windows PowerShell 5.1+ / PowerShell 7+ (pwsh)
═══════════════════════════════════════════════════════════════════════════ #>

#region Pretty_Output_Helpers

function _pretty_hdr {
  param([string]$Title)
  $w = 62
  $line = '═' * $w
  Write-Host ""
  Write-Host "╔${line}╗" -ForegroundColor Cyan
  Write-Host ("║ {0,-${w}}" -f $Title) -ForegroundColor Yellow -NoNewline
  Write-Host "" -ForegroundColor Cyan
  Write-Host "╚${line}╝" -ForegroundColor Cyan
}

function _pretty_ftr {
  $line = '─' * 64
  Write-Host $line -ForegroundColor DarkGray
  Write-Host ""
}

function _pretty_nl {
  [CmdletBinding()]
  param([Parameter(ValueFromPipeline)] [string[]]$Lines)
  begin { $i = 1 }
  process {
    foreach ($l in $Lines) {
      $num = "{0,5}" -f $i
      Write-Host "$num │ " -ForegroundColor Gray -NoNewline
      if ($l -match '^\s*#') {
        Write-Host $l -ForegroundColor Green
      } else {
        Write-Host $l
      }
      $i++
    }
  }
}

#endregion Pretty_Output_Helpers

# ═══════════════════════════════════════════════════════════════════════════
