#region Filesystem_Utilities

# --- NEW EQUIVALENTS ---
function get-mimeapps {
  <#
  .SYNOPSIS
  Displays the user's default applications list and MIME configurations.
  #>
  Get-Content ~/.config/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-mimeapps get-mimeapps

function get-share-mimeapps {
  Get-Content ~/.local/share/applications/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-share-mimeapps get-share-mimeapps

function get-compose-chars {
  <#
  .SYNOPSIS
  Displays the correct native sequence of Compose keys.
  #>
  Get-Content /usr/share/X11/locale/en_US.UTF-8/Compose -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-compose-chars get-compose-chars
Set-Alias show-compose-chars get-compose-chars

function get-all-mimeapps {
  Get-Content ~/.config/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
  Get-Content ~/.local/share/applications/mimeapps.list -ErrorAction SilentlyContinue | Write-Output
}
Set-Alias cat-all-mimeapps get-all-mimeapps
# -----------------------

<#
.SYNOPSIS Find common web image formats in a directory.
.PARAMETER Path
  Directory to search (default: .).
#>
function Find-WebImages {
  param([string]$Path = '.')
  $exts = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.avif', '.bmp', '.ico', '.tiff', '.tif')
  Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue |
    Where-Object { $exts -contains $_.Extension.ToLower() } |
    Select-Object -ExpandProperty FullName
}
Set-Alias -Name ls-web-images -Value Find-WebImages
Set-Alias -Name show-web-images -Value Find-WebImages

<#
.SYNOPSIS Find a broad set of image formats (web + RAW + design files).
.PARAMETER Path
  Directory to search (default: .).
#>
function Find-AllImages {
  param([string]$Path = '.')
  $exts = @(
    '.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.avif', '.bmp', '.ico', '.tiff', '.tif', '.jfif',
    '.jpe', '.jif', '.jp2', '.j2k', '.jpf', '.jpx', '.jpm', '.mj2', '.cr2', '.cr3', '.nef', '.nrw',
    '.arw', '.srf', '.sr2', '.orf', '.rw2', '.pef', '.ptx', '.raf', '.3fr', '.fff', '.dcr', '.dng',
    '.mrw', '.iiq', '.kdc', '.mos', '.erf', '.bay', '.psd', '.psb', '.ai', '.eps', '.indd', '.xcf',
    '.cdr', '.heic', '.heif', '.jxr', '.jxl'
  )
  Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue |
    Where-Object { $exts -contains $_.Extension.ToLower() } |
    Select-Object -ExpandProperty FullName
}
Set-Alias -Name ls-all-images -Value Find-AllImages
Set-Alias -Name show-all-images -Value Find-AllImages

function Get-PathDepth {
  param([Parameter(Mandatory)][string]$Base, [Parameter(Mandatory)][string]$FullPath)
  $rel = [System.IO.Path]::GetRelativePath($Base, $FullPath)
  if ($rel -eq '.' -or [string]::IsNullOrWhiteSpace($rel)) { return 0 }
  return ($rel -split '[\\/]').Count - 1
}

<#
.SYNOPSIS Find common web image formats with depth controls.
.PARAMETER Path
  Directory to search (default: .).
.PARAMETER MaxDepth
  Maximum directory depth (default: -1 = no limit).
.PARAMETER MinDepth
  Minimum directory depth (default: 0).
#>
function Find-WebImagesDeep {
  param(
    [string]$Path = '.',
    [int]$MaxDepth = -1,
    [int]$MinDepth = 0
  )
  $base = (Resolve-Path $Path).Path
  $exts = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.avif', '.bmp', '.ico', '.tiff', '.tif')
  Get-ChildItem -Path $base -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
      $depth = Get-PathDepth -Base $base -FullPath $_.FullName
      ($depth -ge $MinDepth) -and (($MaxDepth -lt 0) -or ($depth -le $MaxDepth))
    } |
    Where-Object { $exts -contains $_.Extension.ToLower() } |
    Select-Object -ExpandProperty FullName
}
Set-Alias -Name ls-web-images-deep -Value Find-WebImagesDeep
Set-Alias -Name show-web-images-deep -Value Find-WebImagesDeep

<#
.SYNOPSIS Find a broad set of image formats with depth controls.
.PARAMETER Path
  Directory to search (default: .).
.PARAMETER MaxDepth
  Maximum directory depth (default: -1 = no limit).
.PARAMETER MinDepth
  Minimum directory depth (default: 0).
#>
function Find-AllImagesDeep {
  param(
    [string]$Path = '.',
    [int]$MaxDepth = -1,
    [int]$MinDepth = 0
  )
  $base = (Resolve-Path $Path).Path
  $exts = @(
    '.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.avif', '.bmp', '.ico', '.tiff', '.tif', '.jfif',
    '.jpe', '.jif', '.jp2', '.j2k', '.jpf', '.jpx', '.jpm', '.mj2', '.cr2', '.cr3', '.nef', '.nrw',
    '.arw', '.srf', '.sr2', '.orf', '.rw2', '.pef', '.ptx', '.raf', '.3fr', '.fff', '.dcr', '.dng',
    '.mrw', '.iiq', '.kdc', '.mos', '.erf', '.bay', '.psd', '.psb', '.ai', '.eps', '.indd', '.xcf',
    '.cdr', '.heic', '.heif', '.jxr', '.jxl'
  )
  Get-ChildItem -Path $base -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object {
      $depth = Get-PathDepth -Base $base -FullPath $_.FullName
      ($depth -ge $MinDepth) -and (($MaxDepth -lt 0) -or ($depth -le $MaxDepth))
    } |
    Where-Object { $exts -contains $_.Extension.ToLower() } |
    Select-Object -ExpandProperty FullName
}
Set-Alias -Name ls-all-images-deep -Value Find-AllImagesDeep
Set-Alias -Name show-all-images-deep -Value Find-AllImagesDeep

# ═══════════════════════════════════════════════════════════════════════════

<#
.SYNOPSIS Move files into subdirectories of 100 files each (pack1/, pack2/, ...).
#>
function Invoke-PackFiles {
  $files = Get-ChildItem -File
  $acc = 0; $packCount = 1
  foreach ($f in $files) {
    if ($acc -eq 100 -or $acc -eq 0) {
      $dir = "pack$packCount"
      New-Item -ItemType Directory -Path $dir -Force | Out-Null
      Write-Host "Packing files into directory: $dir"
      $packCount++; $acc = 0
    }
    Move-Item $f.FullName -Destination $dir
    $acc++
  }
  Write-Host "Packed $($files.Count) files into $($packCount - 1) directories"
}
Set-Alias -Name packf -Value Invoke-PackFiles

<#
.SYNOPSIS
  Rename all files in the current directory to random 16-char alphanumeric names, preserving extensions.
#>
function Rename-FilesRandomly {
  Get-ChildItem -File | ForEach-Object {
    $ext = $_.Extension
    $newName = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ })
    Rename-Item $_.FullName -NewName "$newName$ext"
  }
}
Set-Alias -Name fully-randomized-file-names -Value Rename-FilesRandomly
Set-Alias -Name randomize-filenames -Value Rename-FilesRandomly
Set-Alias -Name rand-fn -Value Rename-FilesRandomly

#endregion Filesystem_Utilities

# ═══════════════════════════════════════════════════════════════════════════
