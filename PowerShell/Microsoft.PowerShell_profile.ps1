# !!IMPORTANT!!! THIS FILE NEEDS TO BE PLACED IN [drive]:\Users\[name]\Documents\WindowsPowerShell to be read
function Open-MyPC {
    explorer.exe "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
}
function Open-RecycleBin {
    explorer.exe "::{645FF040-5081-101B-9F08-00AA002F954E}"
}
function Open-Documents {
    explorer.exe "::{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
}
function Open-Networks {
    explorer.exe "::{208D2C60-3AEA-1069-A2D7-08002B30309D}"
}
function Open-HomeGroup {
    explorer.exe "::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
}
function Open-NetworkConnections {
    explorer.exe "::{7007ACC7-3202-11D1-AAD2-00805FC1270E}"
}
function Open-FileHistory {
    explorer.exe "::{9343812E-1C37-4A49-A12E-4B2D830D63F0}"
}
function Diagnose-Memory {
    explorer.exe "::{D17D1D6D-CC3F-4815-8FE3-607E7D5D10B3}"
}
function Open-Personalization {
    explorer.exe "::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}"
}
function Open-Fonts {
    explorer.exe "::{D20EA4E1-3957-11d2-A40B-0C5020524153}"
}
function Get-USBControllerDevice {
    Get-WmiObject Win32_USBControllerDevice
}
function Get-Processor {
    Get-WmiObject Win32_Processor
}
function Get-USBController {
    Get-WmiObject Win32_USBController
}
function Get-PhysicalMemory {
    Get-WmiObject Win32_PhysicalMemory
}
function Get-DiskDrive {
    Get-WmiObject Win32_DiskDrive
}
function Get-LogicalDisk {
    Get-WmiObject Win32_LogicalDisk
}
function Get-Battery {
    Get-WmiObject Win32_Battery
}
function Get-PowerSetting {
    Get-WmiObject Win32_PowerSetting
}
function Get-PrinterWMI {
    Get-WmiObject Win32_Printer
}
function Get-VideoController {
    Get-WmiObject Win32_VideoController
}
function Get-NetworkAdapterConfiguration {
    Get-WmiObject Win32_NetworkAdapterConfiguration
}
function Get-BIOS {
    Get-WmiObject Win32_BIOS
}
function Get-NTLogEvent {
    Get-WmiObject Win32_NTLogEvent
}
function Get-UserAccount {
    Get-WmiObject Win32_UserAccount
}
function Get-ComputerSystem {
    Get-WmiObject Win32_ComputerSystem
}
function Get-GroupUser {
    Get-WmiObject Win32_GroupUser
}
function Get-OperatingSystem {
    Get-WmiObject Win32_OperatingSystem
}
function Get-Product {
    Get-WmiObject Win32_Product
}
function Get-ServiceWMI {
    Get-WmiObject Win32_Service
}
function NetshWinsockVersionShowCatalog {
    Netsh winsock show catalog
}
function NetshWlan {
    Netsh wlan show all
}
function GetNetDrivers {
    Get-NetAdapter | Format-List Name, DriverVersion
}
function NewFile { 
    New-Item -ItemType File @args 
}
function OutFile { 
    Out-File -FilePath @args 
}
Set-Alias -Name np -Value notepad
Set-Alias -Name touch -Value NewFile
Set-Alias -Name comp -Value Compress-Archive
Set-Alias -Name exp -Value Expand-Archive
Set-Alias -Name outf -Value OutFile
Set-Alias -Name no -Value New-Object
Set-Alias -Name spt -Value Split-Path
Set-Alias -Name tpt -Value Test-Path

Set-Alias -Name spp -Value Start-Process
Set-Alias -Name sep -Value Set-ExecutionPolicy
Set-Alias -Name gep -Value Get-ExecutionPolicy

Set-Alias -Name getv -Value Get-Volume
Set-Alias -Name getpt -Value Get-Partition
Set-Alias -Name getpd -Value Get-PhysicalDisk
Set-Alias -Name getds -Value Get-Disk

Set-Alias -Name getusbcd -Value Get-USBControllerDevice
Set-Alias -Name getusbc -Value Get-USBController
Set-Alias -Name getproc -Value Get-Processor
Set-Alias -Name getpmem -Value Get-PhysicalMemory
Set-Alias -Name getdd -Value Get-DiskDrive
Set-Alias -Name getld -Value Get-LogicalDisk

Set-Alias -Name getbt -Value Get-Battery
Set-Alias -Name getpws -Value Get-PowerSetting
Set-Alias -Name getprn -Value Get-PrinterWMI
Set-Alias -Name getvc -Value Get-VideoController

Set-Alias -Name getua -Value Get-UserAccount
Set-Alias -Name getgu -Value Get-GroupUser
Set-Alias -Name getusr -Value Get-LocalUser
Set-Alias -Name getntlog -Value Get-NTLogEvent

Set-Alias -Name getbios -Value Get-BIOS
Set-Alias -Name getcs -Value Get-ComputerSystem
Set-Alias -Name getos -Value Get-OperatingSystem
Set-Alias -Name getprod -Value Get-Product
Set-Alias -Name getsvc -Value Get-ServiceWMI

Set-Alias -Name getnac -Value Get-NetworkAdapterConfiguration
Set-Alias -Name getna -Value Get-NetAdapter
Set-Alias -Name getnpc -Value Get-NetTCPConnection
Set-Alias -Name netshv -Value NetshWinsockVersionShowCatalog
Set-Alias -Name netsha -Value NetshWlan
Set-Alias -Name getndv -Value GetNetDrivers

Set-Alias -Name im -Value Install-Module
Set-Alias -Name cbin -Value Clear-RecycleBin
Set-Alias -Name sttr -Value Start-Transcript
Set-Alias -Name sptr -Value Stop-Transcript

Set-Alias -Name mypc -Value Open-MyPC
Set-Alias -Name recyclebin -Value Open-RecycleBin
Set-Alias -Name documents -Value Open-Documents
Set-Alias -Name networks -Value Open-Networks
Set-Alias -Name homegroup -Value Open-HomeGroup
Set-Alias -Name netconnections -Value Open-NetworkConnections
Set-Alias -Name filehistory -Value Open-FileHistory
Set-Alias -Name memdiag -Value Diagnose-Memory
Set-Alias -Name fonts -Value Open-Fonts
Set-Alias -Name personalization -Value Open-Personalization
