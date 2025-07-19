function Clear-ChromeFetches {
    [CmdletBinding()]
    [Alias('rmchrome-fetch')]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [Alias('d')]
        [string]$Drive = 'C:',
        [Parameter(Mandatory=$false, Position=1)]
        [Alias('u')]
        [string]$User  = $env:USERNAME
    )
    $origFg = [Console]::ForegroundColor
    $principal = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    if (-not $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )) {
        [Console]::ForegroundColor = 'Red'
        write 'Please run this script as an administrator.'
        start PowerShell `
            -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
            -Verb RunAs
        [Console]::ForegroundColor = $origFg
        return
    }
    $tempPath      = "$Drive\Users\$User\AppData\Local\Temp"
    $chromeFetches = ls $tempPath |
        where { $_.Name -match 'chrome[_-]' -or $_.Name -like 'chrome_*' }
    if ($chromeFetches.Count -eq 0) {
        [Console]::ForegroundColor = 'Yellow'
        write "No Chrome fetches found in $tempPath"
        [Console]::ForegroundColor = $origFg
        return
    }
    $chromeFetches | foreach {
        try {
            write "Removing $($_.FullName)..."
            rm -Recurse -Force $_.FullName -ErrorAction Stop
            [Console]::ForegroundColor = 'Green'
            write 'Removed successfully.'
        } catch {
            [Console]::ForegroundColor = 'Red'
            write "Failed to remove $($_.FullName): $($_.Exception.Message)"
        } finally {
            [Console]::ForegroundColor = $origFg
        }
    }
    [Console]::ForegroundColor = 'Cyan'
    if ($chromeFetches.Count -eq 1) {
        write '1 fetch directory removed'
    } else {
        write "$($chromeFetches.Count) fetch directories removed"
    }
    [Console]::ForegroundColor = $origFg
}
function cbin--shadow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidatePattern('^[A-Za-z]:?$')]
        [string]$Drive = 'C'
    )
    $Drive = $Drive.TrimEnd(':')
    $RecycleBinPath = "$Drive`:\`$Recycle.Bin"
    if (Test-Path $RecycleBinPath) {
        Write-Verbose "Clearing Recycle Bin at: $RecycleBinPath"
        Get-ChildItem -Path $RecycleBinPath -Force -Recurse -ErrorAction SilentlyContinue | 
            Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Warning "Recycle Bin not found at: $RecycleBinPath"
    }
    Clear-RecycleBin -DriveLetter $Drive -Force
    write "Recycle Bin cleared for drive $Drive`:"
}
function Optimize-DockerVhd {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$false)]
        [string]$VhdPath = "$env:LOCALAPPDATA\Docker\wsl\disk\docker_data.vhdx"
    )
    if (-not (Test-Path -LiteralPath $VhdPath)) {
        Throw "VHD not found at path: $VhdPath"
    }
    write "Step 1: Pruning unused Docker data..." -ForegroundColor Cyan
    docker system prune --all --volumes --force
    write "Step 2: Shutting down WSL to unlock VHD..." -ForegroundColor Cyan
    wsl --shutdown
    $beforeBytes = (Get-Item -LiteralPath $VhdPath).Length
    $beforeGB    = [math]::Round($beforeBytes / 1GB, 2)
    write "  VHD size before compaction: $beforeGB GB" -ForegroundColor Yellow
    write "Step 3: Compacting VHD at $VhdPath ..." -ForegroundColor Cyan
    if (-not (Get-Command Optimize-VHD -ErrorAction SilentlyContinue)) {
        Import-Module Hyper-V -ErrorAction Stop
    }
    Optimize-VHD -Path $VhdPath -Mode Full
    $afterBytes = (Get-Item -LiteralPath $VhdPath).Length
    $afterGB    = [math]::Round($afterBytes / 1GB, 2)
    $freedGB    = [math]::Round(($beforeBytes - $afterBytes) / 1GB, 2)
    write "  VHD size after compaction : $afterGB GB" -ForegroundColor Yellow
    write "  Space reclaimed           : $freedGB GB" -ForegroundColor Green
    return [PSCustomObject]@{
        VhdPath        = $VhdPath
        BeforeBytes    = $beforeBytes
        AfterBytes     = $afterBytes
        FreedBytes     = $beforeBytes - $afterBytes
        BeforeGB       = $beforeGB
        AfterGB        = $afterGB
        FreedGB        = $freedGB
    }
}