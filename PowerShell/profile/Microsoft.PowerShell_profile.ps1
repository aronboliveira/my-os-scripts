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
    param ([string]$FilePath)
    $input | Out-File -FilePath $FilePath
}
function SanitizeNames {
    gci * -File | foreach {
        $newBaseName = ($_.BaseName -replace '[^a-zA-Z0-9_]', '__').ToLower()
        $newName = "$newBaseName$($_.Extension)"
            if($newBaseName -ne $_.BaseName) {
            [Console]::ForegroundColor = 'Green'
            echo "`nRenaming '$($_.Name)' to '$newName'`n"
            [Console]::ResetColor()
            ren $_.FullName -NewName $newName
        } 
    }
}
function CompressCurrentDirectory {
    $sourceDir = gl
    $zipDestination = "$($sourceDir.Path).zip"
    $excludeDirs = @('node_modules', 'vendor')
    
    $filesToZip = gci -Path $sourceDir -Recurse -File | where {
        $file = $_
        -not ($excludeDirs | where { $file.FullName -like "*\$_*" })
    }
    
    Compress-Archive -Path $filesToZip.FullName -DestinationPath $zipDestination -Force
    
    [Console]::ForegroundColor = "Green"
    write "Archive created: $zipDestination"
    [Console]::ResetColor()
    
    return $zipDestination
}
function UnzipAll {
    gci -r -inc *.zip, *.7z, *.rar | % {
        if ($_.Extension -eq ".zip") {
            Expand-Archive -Path $_.FullName -DestinationPath $_.DirectoryName
        } elseif ($_.Extension -eq ".7z") {
            7z x $_.FullName -o$($_.DirectoryName)
        } elseif ($_.Extension -eq ".rar") {
            unrar x $_.FullName $($_.DirectoryName)
        }
    }
}
function DeleteAllCompressed {
    gci * | ? { $_.Extension -eq ".7z" -or $_.Extension -eq ".rar" -or $_.Extension -eq ".zip" } | rm -Force
}
function GetProcessorData {
    $originalColor = [Console]::ForegroundColor
    [Console]::ForegroundColor = 'DarkGray'
    write "------------------------"
    [Console]::ForegroundColor = 'Cyan'
    write "CPUs"
    [Console]::ForegroundColor = 'DarkGray'
    write "------------------------"
    [Console]::ForegroundColor = $originalColor
    Get-WmiObject Win32_Processor | Select-Object @{Name="ID"; Expression={$_.DeviceID}},
        @{Name="ID do Processador"; Expression={$_.ProcessorID}},
        @{Name="Número de Série"; Expression={
            if ($_.SerialNumber) { 
                $_.SerialNumber 
            } else { 
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Nome"; Expression={$_.Name}},
        @{Name="Legenda"; Expression={$_.Caption}},
        @{Name="Fabricante"; Expression={$_.Manufacturer}},
        @{Name="Tipo"; Expression={
            switch ($_.ProcessorType) {
                1 {"Outro"}
                2 {"Desconhecido"}
                3 {"Central"}
                4 {"Math"}
                5 {"DSP"}
                6 {"GPU"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Núcleos Físicos"; Expression={$_.NumberOfCores}},
        @{Name="Núcleos Ativos"; Expression={$_.NumberOfEnabledCores}},
        @{Name="Processos Lógicos"; Expression={$_.NumberOfLogicalProcessors}},
        @{Name="Soquete"; Expression={
            if ($_.SocketDesignation) {
                $_.SocketDesignation
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Função"; Expression={
            switch ($_.Role) {
                "CPU" {"Unidade Central"}
                "FPU" {"Unidade de Ponto Flutuante"}
                "CP+FPU" {"Combinado"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Família"; Expression={
            switch ($_.Family) {
                1 {"Outro"}
                2 {"Desconhecido"}
                3 {"8086"}
                4 {"80286"}
                5 {"80386"}
                6 {"80486"}
                7 {"8087"}
                8 {"80287"}
                9 {"80387"}
                10 {"80487"}
                11 {"Pentium"}
                12 {"Pentium Pro"}
                13 {"Pentium II"}
                14 {"Pentium MMX"}
                15 {"Celeron"}
                16 {"Pentium Xeon"}
                17 {"Pentium III"}
                18 {"M1"}
                19 {"M2"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Arquitetura"; Expression={
            switch ($_.Architecture) {
                0 {"x86"}
                1 {"MIPS"}
                2 {"Alpha"}
                3 {"PowerPC"}
                5 {"ARM"}
                6 {"IA-64"}
                9 {"x64"}
                10 {"ARM64"}
                12 {"RISC-V"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Nível"; Expression={$_.Level}},
        @{Name="PartNumber"; Expression={
            if ($_.PartNumber) {
                $_.PartNumber
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Características"; Expression={
            $features = @()
            if ($_.Characteristics -band 1) {$features += "FPU Presente"}
            if ($_.Characteristics -band 2) {$features += "Virtualização"}
            if ($_.Characteristics -band 4) {$features += "Dep. Exec. Desativável"}
            if ($_.Characteristics -band 8) {$features += "Monitor Térmico"}
            if ($features.Count -eq 0) {
                [Console]::ForegroundColor = 'Red'
                "Nenhuma"
                [Console]::ForegroundColor = $originalColor
            } else {
                $features -join ", "
            }
        }},
        @{Name="Descrição"; Expression={
            if ($_.Description) {
                $_.Description
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Clock Atual (GHz)"; Expression={[math]::Round($_.CurrentClockSpeed / 1000, 2)}},
        @{Name="Clock Máximo (GHz)"; Expression={[math]::Round($_.MaxClockSpeed / 1000, 2)}},
        @{Name="Clock Externo (MHz)"; Expression={
            if ($_.ExtClock) {
                $_.ExtClock
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Cache L2 (MB)"; Expression={
            if ($_.L2CacheSize) {
                [math]::Round($_.L2CacheSize / 1024, 1)
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Vel. Cache L2 (GHz)"; Expression={
            if ($_.L2CacheSpeed) {
                [math]::Round($_.L2CacheSpeed / 1000, 2)
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Cache L3 (MB)"; Expression={
            if ($_.L3CacheSize) {
                [math]::Round($_.L3CacheSize / 1024, 1)
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Vel. Cache L3 (GHz)"; Expression={
            if ($_.L3CacheSpeed) {
                [math]::Round($_.L3CacheSpeed / 1000, 2)
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Threads"; Expression={$_.ThreadCount}},
        @{Name="Voltagem Atual"; Expression={
            if ($_.CurrentVoltage) {
                "$($_.CurrentVoltage / 10)V"
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Voltagens Suportadas"; Expression={
            if ($_.VoltageCaps) {
                ($_.VoltageCaps -split "," | foreach {"$($_ / 10)V"}) -join ", "
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Virtualização Ativa"; Expression={
            if ($_.VirtualizationFirmwareEnabled) { 
                [Console]::ForegroundColor = 'Green'
                "Sim" 
            } else { 
                [Console]::ForegroundColor = 'Red'
                "Não"
            }
            [Console]::ForegroundColor = $originalColor
        }},
        @{Name="ID PNP"; Expression={
            if ($_.PNPDeviceID) {
                $_.PNPDeviceID
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Largura Endereço"; Expression={"$($_.AddressWidth)-bit"}},
        @{Name="Largura Dados"; Expression={"$($_.DataWidth)-bit"}},
        @{Name="Estado"; Expression={
            switch ($_.CpuStatus) {
                0 {"Desconhecido"}
                1 {"CPU Habilitada"}
                2 {"CPU Desabilitada"}
                3 {"CPU Parcial"}
                4 {"CPU Ociosa"}
                5 {"CPU Reservada"}
                6 {"Offline"}
                7 {"Falha"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Disponibilidade"; Expression={
            switch ($_.Availability) {
                1 {"Outro"}
                2 {"Desconhecido"}
                3 {"Em Execução"}
                4 {"Aviso"}
                5 {"Em Teste"}
                6 {"Não Aplicável"}
                7 {"Desligado"}
                8 {"Offline"}
                9 {"Fora de Serviço"}
                10 {"Degradado"}
                11 {"Não Instalado"}
                12 {"Erro de Instalação"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }},
        @{Name="Status"; Expression={
            if ($_.Status) {
                $_.Status
            } else {
                [Console]::ForegroundColor = 'Red'
                "Indefinido"
                [Console]::ForegroundColor = $originalColor
            }
        }},
        @{Name="Info Status"; Expression={
            switch ($_.StatusInfo) {
                1 {"Outro"}
                2 {"Desconhecido"}
                3 {"Habilitado"}
                4 {"Desabilitado"}
                5 {"Não Aplicável"}
                default { 
                    [Console]::ForegroundColor = 'Yellow'
                    "Indefinido"
                    [Console]::ForegroundColor = $originalColor
                }
            }
        }}
    [Console]::ForegroundColor = $originalColor
}
function GetSSRAMData {
    $originalColor = [Console]::ForegroundColor
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "SSRAM"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    Get-WmiObject Win32_PhysicalMemory | Select-Object @{
        Name = "Fabricante"
        Expression = {if ($_.Manufacturer -and $_.Manufacturer.Trim() -ne "") { $_.Manufacturer } else { "Indefinido" }}
    }, @{
        Name = "Nome da Parte"
        Expression = {if ($_.PartNumber -and $_.PartNumber.Trim() -ne "") { $_.PartNumber } else { "Indefinido" }}
    }, @{
        Name = "Serial"
        Expression = {$_.SerialNumber}
    }, @{
        Name = "Capacidade (GB)"
        Expression = {if ($_.Capacity) {[math]::Round($_.Capacity / 1GB, 0)} else { "Indefinido" }}
    }, @{
        Name = "Potencial de Velocidade de Relógio (GHz)"
        Expression = {if ($_.ConfiguredClockSpeed) {[math]::Round($_.ConfiguredClockSpeed / 1000, 2)} else { "Indefinido" }}
    }, @{
        Name = "Velocidade de Relógio em Uso (GHz)"
        Expression = {if ($_.Speed) {[math]::Round($_.Speed / 1000, 2)} else { "Indefinido" }}
    }, @{
        Name = "Versão de DDR"
        Expression = {switch ($_.SMBIOSMemoryType) {
            20 {"DDR"}
            21 {"DDR2"}
            24 {"DDR3"}
            26 {"DDR4"}
            34 {"DDR5"}
            default { "Indefinido" }
        }}
    }, @{
        Name = "Memória"
        Expression = {switch($_.TypeDetail) {
            1 {"Reservado"}
            2 {"Outro"}
            4 {"Desconhecido"}
            8 {"Rapidamente Paginado"}
            16 {"Coluna Estática"}
            32 {"Porção em Pipeline"}
            64 {"Síncrono"}
            128 {"Assíncrono"}
            256 {"Suporta ECC"}
            512 {"Registrado"}
            1024 {"Não Registrado"}
            2048 {"LRDIMM"}
            default {"Indefinido"}
        }}
    }, @{
        Name = "Localização"
        Expression = {if ($_.DeviceLocator -and $_.DeviceLocator.Trim() -ne "") { $_.DeviceLocator } else { "Indefinido" }}
    }, @{
        Name = "Banco"
        Expression = {if ($_.BankLabel -and $_.BankLabel.Trim() -ne "") { $_.BankLabel } else { "Indefinido" }}
    }, @{
        Name = "Largura de Dados em Barramento"
        Expression = {switch ($_.DataWidth) {
            64 {"64 (Padrão)"}
            72 {"72 (ECC)"}
            default {"Indefinido"}
        }}
    }, @{
        Name = "Voltagem Configurada"
        Expression = {if ($_.ConfiguredVoltage) {($_.ConfiguredVoltage/1000).ToString() + "V"} else { "Indefinido" }}
    }, @{
        Name = "Voltagem Mínima"
        Expression = {if ($_.MinVoltage) {($_.MinVoltage/1000).ToString() + "V"} else { "Indefinido" }}
    }, @{
        Name = "Voltagem Máxima"
        Expression = {if ($_.MaxVoltage) {($_.MaxVoltage/1000).ToString() + "V"} else { "Indefinido" }}
    }, @{
        Name = "Removível"
        Expression = {if ($_.Removable -ne $null) { $_.Removable } else { "Indefinido" }}
    }, @{
        Name = "Substituível"
        Expression = {if ($_.Replaceable -ne $null) { $_.Replaceable } else { "Indefinido" }}
    }
    [Console]::ForegroundColor = $originalColor
}
function GetStorageDeviceData {
    $originalColor = [Console]::ForegroundColor
    
    $traducaoUsage = @{
        "Auto-Select" = "Seleção Automática"
        "Manual-Select" = "Seleção Manual"
        "Hot Spare" = "Reserva Quente"
        "Journal" = "Jornal"
        "Retired" = "Retirado"
        "Unassigned" = "Não Atribuído"
    }
    
    $traducaoOperabilidade = @{
        "OK" = "Operacional"
        "Unknown" = "Desconhecido"
        "No Media" = "Sem Mídia"
        "Degraded" = "Degradado"
        "Failed" = "Falhou"
        "Offline" = "Offline"
        "Online" = "Online"
        "Read Only" = "Somente Leitura"
        "Full Repair Needed" = "Danificado"
    }
    
    $traducaoDedupMode = @{
        "Disabled" = "Desativado"
        "Enabled" = "Ativado"
        "Unknown" = "Desconhecido"
        "Savings Temporary" = "Otimização Temporária"
        "Savings Calculation" = "Cálculo de Otimização"
    }
    
    $traducaoFileSystemType = @{
        "NTFS" = "NTFS"
        "FAT32" = "FAT32"
        "ReFS" = "ReFS (Resilient File System)"
        "exFAT" = "exFAT"
        "UDF" = "UDF (Universal Disk Format)"
        "CDFS" = "CDFS (Compact Disc File System)"
        "Unknown" = "Desconhecido"
    }
    
    $traducaoMediaType = @{
        "Fixed hard disk media" = "Disco Rígido Fixo"
        "External hard disk media" = "Disco Rígido Externo"
        "Removable media" = "Mídia Removível"
    }
    
    $traducaoInterfaceType = @{
        "SCSI" = "SCSI"
        "IDE" = "IDE (Drive Eletrônico Integrado)"
        "USB" = "USB"
        "SATA" = "SATA"
        "SAS" = "SAS (Serial Attached SCSI)"
        "NVMe" = "NVMe"
        "Fibre Channel" = "Canal de Fibra"
        "RAID" = "RAID (Matriz Redundante de Discos Independentes)"
        "iSCSI" = "iSCSI (SCSI sobre IP)"
        "ATA" = "ATA (Tecnologia Avançada de Anexo)"
        "1394" = "IEEE 1394 (FireWire)"
        "SD" = "SD"
        "MMC" = "MMC (MultiMediaCard)"
        "Virtual" = "Disco Virtual"
        "SSA" = "SSA"
        "External" = "Disco Rígido Externo"
        "Fixed" = "Disco Rígido Fixo"
    }
    
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "VOLUMES"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    
    $volumes = Get-Volume | Select-Object @{
        Name = "ID do Volume"
        Expression = {$_.ObjectId}
    }, @{
        Name = "Rótulo"
        Expression = {if ($_.FileSystemLabel -and $_.FileSystemLabel.Trim() -ne "") { $_.FileSystemLabel } else { "Nulo" }}
    }, @{
        Name = "Nome"
        Expression = {if ($_.PSObject.Properties['FriendlyName'] -and $_.FriendlyName) { $_.FriendlyName } else { "Nulo" }}
    }, @{
        Name = "Drive"
        Expression = {if ($_.DriveLetter) { $_.DriveLetter } else { "Nulo" }}
    }, @{
        Name = "Tipo de Drive"
        Expression = {if ($_.DriveType) { $_.DriveType } else { "Nulo" }}
    }, @{
        Name = "Sistema de Arquivos"
        Expression = {$fs = $_.FileSystemType; if ($fs -and $traducaoFileSystemType.ContainsKey($fs)) { $traducaoFileSystemType[$fs] } else { "Nulo" }}
    }, @{
        Name = "Armazenamento Total (GB)"
        Expression = {if ($_.Size) {[math]::Round($_.Size/1GB,0)} else { "Nulo" }}
    }, @{
        Name = "Armazenamento Restante (GB)"
        Expression = {if ($_.SizeRemaining) {[math]::Round($_.SizeRemaining/1GB,2)} else { "Nulo" }}
    }, @{
        Name = "Operabilidade"
        Expression = {$opStatus = $_.OperationalStatus; if($opStatus -and $traducaoOperabilidade.ContainsKey($opStatus)) { $traducaoOperabilidade[$opStatus] } else { "Nulo" }}
    }, @{
        Name = "Deduplicação"
        Expression = {$dedup = $_.DedupMode; if($dedup -and $traducaoDedupMode.ContainsKey($dedup)) { $traducaoDedupMode[$dedup] } else { "Nulo" }}
    }
    
    $volumes | sort Rótulo | foreach { 
        $_.PSObject.Properties | foreach { 
            if (-not $_.Value -or $_.Value -eq "") { $_.Value = "Nulo" } 
        }
        $_
    }
    
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "PHYSICAL DISKS"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    
    $physicalDisks = Get-PhysicalDisk | Select-Object @{
        Name = "ID"
        Expression = {$_.DeviceID}
    }, @{
        Name = "Nome"
        Expression = {if ($_.FriendlyName) { $_.FriendlyName -replace "\s", "" } else { "Nulo" }}
    }, @{
        Name = "Serial"
        Expression = {if ($_.SerialNumber) { $_.SerialNumber } else { "Nulo" }}
    }, @{
        Name = "Media"
        Expression = {if ($_.MediaType) { $_.MediaType } else { "Nulo" }}
    }, @{
        Name = "Barramento"
        Expression = {if ($_.BusType) { $_.BusType } else { "Nulo" }}
    }, @{
        Name = "Adicionável em Pool"
        Expression = {if ($null -ne $_.CanPool) { $_.CanPool } else { "Nulo" }}
    }
    
    $physicalDisks | sort ID
    
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "DISK DRIVES"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    
    $diskDrives = Get-WmiObject Win32_DiskDrive | Select-Object @{
        Name = "ID"
        Expression = {$_.DeviceID -replace "^\\\\\.\\", ""}
    }, @{
        Name = "Modelo"
        Expression = {$_.Model}
    }, @{
        Name = "Partições"
        Expression = {$_.Partitions}
    }, @{
        Name = "Tamanho (GB)"
        Expression = {[math]::Round($_.Size / 1GB, 0)}
    }, @{
        Name = "Interface"
        Expression = { 
            $interface = $_.InterfaceType
            if($interface -and $traducaoInterfaceType.ContainsKey($interface)) { 
                $traducaoInterfaceType[$interface] 
            } else { 
                if($interface) { $interface } else { "Indefinido" }
            }
        }
    }, @{
        Name = "Media"
        Expression = { 
            $m = $_.MediaType
            if($m -and $traducaoMediaType.ContainsKey($m)) { 
                $traducaoMediaType[$m] 
            } else { 
                if($m) { $m } else { "Indefinido" } 
            }
        }
    }
    
    $diskDrives | sort ID
    
    [Console]::ForegroundColor = $originalColor
}
function GetUSBPortData {
    $originalColor = [Console]::ForegroundColor
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "USBs"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    
    Get-WmiObject Win32_USBController | Select-Object @{
        Name = "ID"
        Expression = {$_.DeviceID}
    }, @{
        Name = "Nome"
        Expression = {$_.Caption}
    }, @{
        Name = "Fabricante"
        Expression = {$_.Manufacturer}
    }, @{
        Name = "Descrição do Tipo"
        Expression = {$_.Description}
    }, @{
        Name = "Protocolo (USB Version)"
        Expression = {switch ($_.ProtocolSupported) {
            1 {"Outro"}
            2 {"Desconhecido"}
            3 {"EISA"}
            4 {"ISA"}
            5 {"PCI"}
            6 {"ATA/ATAPI"}
            7 {"Disquete Flexível"}
            8 {"1496"}
            9 {"SCSI Paralelo"}
            10 {"SCSI Fibre Channel"}
            11 {"SCSI Serial Bus"}
            12 {"SCSI Serial Bus-2 (1394)"}
            13 {"SCSI Serial Storage Architecture"}
            14 {"VESA"}
            15 {"PCMCIA"}
            16 {"USB (Universal Serial Bus)"}
            17 {"Protocolo Paralelo"}
            18 {"ESCON"}
            19 {"Diagnóstico"}
            20 {"I2C"}
            21 {"Energia"}
            22 {"HIPPI"}
            23 {"MultiBus"}
            24 {"VME"}
            25 {"IPI"}
            26 {"IEEE-488"}
            27 {"RS232"}
            28 {"IEEE 802.3 10BASE5"}
            29 {"IEEE 802.3 10BASE2"}
            30 {"IEEE 802.3 1BASE5"}
            31 {"IEEE 802.3 10BROAD36"}
            32 {"IEEE 802.3 100BASEVG"}
            33 {"IEEE 802.5 Token-Ring"}
            34 {"ANSI X3T9.5 FDDI"}
            35 {"MCA"}
            36 {"ESDI"}
            37 {"IDE"}
            38 {"CMD"}
            39 {"ST506"}
            40 {"DSSI"}
            41 {"QIC2"}
            42 {"Enhanced ATA/IDE"}
            43 {"AGP"}
            44 {"TWIRP (Two-Way Infrared)"}
            45 {"FIR (Fast Infrared)"}
            46 {"SIR (Serial Infrared)"}
            47 {"IrBus"}
            default {"Indefinido"}
        }}
    }, @{
        Name = "PNP ID"
        Expression = {$_.PNPDeviceID}
    }, @{
        Name = "Status"
        Expression = {switch ($_.Status) {
            "OK" {"Operacional"}
            "Error" {"Erro"}
            "Degraded" {"Degradado"}
            "Unknown" {"Desconhecido"}
            "Pred Fail" {"Falha Iminente"}
            "Starting" {"Iniciando"}
            "Stopping" {"Parando"}
            "Service" {"Em Serviço"}
            "Stressed" {"Sob Stress"}
            "NonRecover" {"Não Recuperável"}
            "No Contact" {"Sem Contato"}
            "Lost Comm" {"Comunicação Perdida"}
            default {"Indefinido"}
        }}
    }
    
    [Console]::ForegroundColor = $originalColor
}
function GetVideoControllerData {
    $originalColor = [Console]::ForegroundColor
    [Console]::ForegroundColor = "Cyan"
    write "------------------------"
    write "VIDEO CONTROLLERS"
    write "------------------------"
    [Console]::ForegroundColor = "Yellow"
    
    $videoControllers = Get-WmiObject Win32_VideoController | Select-Object @{
        Name = "ID"
        Expression = {$_.DeviceID}
    }, @{
        Name = "Nome"
        Expression = {$_.Name}
    }, @{
        Name = "Memória Dedicada (GB)"
        Expression = {if ($_.AdapterRAM) { [math]::Round($_.AdapterRAM / 1GB, 2) } else { "Indefinido" }}
    }, @{
        Name = "DAC do Adaptador"
        Expression = {$_.AdapterDACType}
    }, @{
        Name = "Disponibilidade"
        Expression = { 
            switch ($_.Availability) { 
                1 { "Outro" } 
                2 { "Desconhecido" } 
                3 { "Em Execução (Potência Total)" } 
                4 { "Aviso" } 
                5 { "Em Teste" } 
                6 { "Não Aplicável" } 
                7 { "Desligado" } 
                8 { "Offline" } 
                9 { "Fora de Serviço" } 
                10 { "Degradado" } 
                11 { "Não Instalado" } 
                12 { "Erro de Instalação" } 
                13 { "Recurso de Energia Desconhecido" } 
                14 { "Baixa Potência" } 
                15 { "Potência em Repouso" } 
                16 { "Requisição de Energia" } 
                17 { "Erro de Baixa Potência" } 
                default { "Indefinido" } 
            }
        }
    }, @{
        Name = "Bits por Pixel"
        Expression = {$_.CurrentBitsPerPixel}
    }, @{
        Name = "Resolução Horizontal"
        Expression = {if ($_.CurrentHorizontalResolution) { "$($_.CurrentHorizontalResolution) px" } else { "Indefinido" }}
    }, @{
        Name = "Resolução Vertical"
        Expression = {if ($_.CurrentVerticalResolution) { "$($_.CurrentVerticalResolution) px" } else { "Indefinido" }}
    }, @{
        Name = "Número total de Cores"
        Expression = {if ($_.CurrentNumberOfColors) { $_.CurrentNumberOfColors } else { "Indefinido" }}
    }, @{
        Name = "Taxa de Atualização Mínima (Hz)"
        Expression = {if ($_.MinRefreshRate) { $_.MinRefreshRate } else { "Indefinido" }}
    }, @{
        Name = "Taxa de Atualização Máxima (Hz)"
        Expression = {if ($_.MaxRefreshRate) { $_.MaxRefreshRate } else { "Indefinido" }}
    }, @{
        Name = "Modo de Scan"
        Expression = { 
            switch ($_.CurrentScanMode) { 
                3 { "Interlaced" } 
                4 { "Non-Interlaced" } 
                default { "Indefinido" } 
            }
        }
    }, @{
        Name = "Tipo de Dither"
        Expression = { 
            switch ($_.DitherType) { 
                0 { "Nenhum" } 
                1 { "Padrão" } 
                2 { "Erro de Difusão" } 
                3 { "Grade de Dither" } 
                4 { "Grade Dinâmica" } 
                5 { "Matriz de Cores" } 
                6 { "Paleta de Cores" } 
                7 { "Difusão de Cores" } 
                default { "Indefinido" } 
            }
        }
    }, @{
        Name = "Versão do Driver"
        Expression = {$_.DriverVersion}
    }, @{
        Name = "Data do Driver"
        Expression = {if ($_.DriverDate) { [Management.ManagementDateTimeConverter]::ToDateTime($_.DriverDate).ToString("dd/MM/yyyy") } else { "Indefinido" }}
    }, @{
        Name = "Seção de Informação"
        Expression = {$_.InfSection}
    }, @{
        Name = "Arquivo de Informação"
        Expression = {$_.InfFileName}
    }, @{
        Name = "Caminho para os Drivers"
        Expression = {if ($_.InstalledDisplayDrivers) { $_.InstalledDisplayDrivers -join ", " } else { "Indefinido" }}
    }, @{
        Name = "Identificador PNP"
        Expression = {$_.PNPDeviceID}
    }, @{
        Name = "Arquitetura de Vídeo"
        Expression = { 
            switch ($_.VideoArchitecture) { 
                1 { "Outro" } 
                2 { "Desconhecido" } 
                3 { "CGA" } 
                4 { "EGA" } 
                5 { "VGA" } 
                6 { "SVGA" } 
                7 { "MDA" } 
                8 { "HGC" } 
                9 { "MCGA" } 
                10 { "8514A" } 
                11 { "XGA" } 
                12 { "Linear Frame Buffer" } 
                160 { "PC-98" } 
                default { "Indefinido" } 
            }
        }
    }, @{
        Name = "Tipo de Memória"
        Expression = { 
            switch ($_.VideoMemoryType) { 
                1 { "Outro" } 
                2 { "Desconhecido" } 
                3 { "VRAM" } 
                4 { "DRAM" } 
                5 { "SRAM" } 
                6 { "WRAM" } 
                7 { "EDO RAM" } 
                8 { "Burst Synchronous DRAM" } 
                9 { "Pipelined Burst SRAM" } 
                10 { "CDRAM" } 
                11 { "3DRAM" } 
                12 { "SDRAM" } 
                13 { "SGRAM" } 
                default { "Indefinido" } 
            }
        }
    }, @{
        Name = "Status"
        Expression = {$_.Status}
    }
    
    $videoControllers | sort ID
    
    [Console]::ForegroundColor = $originalColor
}
function GetGroupedHardware {
    write "------------------------"; write "CPUs"; write "------------------------"; Get-WmiObject Win32_Processor | Select-Object @{Name="ID"; Expression={$_.DeviceID}}, @{Name="ID do Processador"; Expression={$_.ProcessorID}}, @{Name="Número de Série"; Expression={if ($_.SerialNumber) {$_.SerialNumber} else {"Indefinido"}}}, @{Name="Nome"; Expression={$_.Name}}, @{Name="Legenda"; Expression={$_.Caption}}, @{Name="Fabricante"; Expression={$_.Manufacturer}}, @{Name="Tipo"; Expression={switch ($_.ProcessorType) {1 {"Outro";} 2 {"Desconhecido";} 3 {"Central";} 4 {"Math";} 5 {"DSP";} 6 {"GPU";} default {"Indefinido"}}}}, @{Name="Núcleos Físicos"; Expression={$_.NumberOfCores}}, @{Name="Núcleos Ativos"; Expression={$_.NumberOfEnabledCores}}, @{Name="Processos Lógicos"; Expression={$_.NumberOfLogicalProcessors}}, @{Name="Soquete"; Expression={$_.SocketDesignation}}, @{Name="Função"; Expression={switch ($_.Role) {"CPU" {"Unidade Central";} "FPU" {"Unidade de Ponto Flutuante";} "CP+FPU" {"Combinado";} default {"Indefinido"}}}}, @{Name="Família"; Expression={switch ($_.Family) {1 {"Outro";} 2 {"Desconhecido";} 3 {"8086";} 4 {"80286";} 5 {"80386";} 6 {"80486";} 7 {"8087";} 8 {"80287";} 9 {"80387";} 10 {"80487";} 11 {"Pentium";} 12 {"Pentium Pro";} 13 {"Pentium II";} 14 {"Pentium MMX";} 15 {"Celeron";} 16 {"Pentium Xeon";} 17 {"Pentium III";} 18 {"M1";} 19 {"M2";} default {"Indefinido"}}}}, @{Name="Arquitetura"; Expression={switch ($_.Architecture) {0 {"x86";} 1 {"MIPS";} 2 {"Alpha";} 3 {"PowerPC";} 5 {"ARM";} 6 {"IA-64";} 9 {"x64";} 10 {"ARM64";} 12 {"RISC-V";} default {"Indefinido"}}}}, @{Name="Nível"; Expression={$_.Level}}, @{Name="PartNumber"; Expression={$_.PartNumber}}, @{Name="Características"; Expression={$features=@(); if ($_.Characteristics -band 1) {$features+="FPU Presente"}; if ($_.Characteristics -band 2) {$features+="Virtualização"}; if ($_.Characteristics -band 4) {$features+="Dep. Exec. Desativável"}; if ($_.Characteristics -band 8) {$features+="Monitor Térmico"}; $features -join ", "}}, @{Name="Descrição"; Expression={$_.Description}}, @{Name="Clock Atual (GHz)"; Expression={[math]::Round($_.CurrentClockSpeed/1000, 2)}}, @{Name="Clock Máximo (GHz)"; Expression={[math]::Round($_.MaxClockSpeed/1000, 2)}}, @{Name="Clock Externo (MHz)"; Expression={$_.ExtClock}}, @{Name="Cache L2 (MB)"; Expression={if ($_.L2CacheSize) {[math]::Round($_.L2CacheSize/1024, 1)} else {"Indefinido"}}}, @{Name="Vel. Cache L2 (GHz)"; Expression={if ($_.L2CacheSpeed) {[math]::Round($_.L2CacheSpeed/1000, 2)} else {"Indefinido"}}}, @{Name="Cache L3 (MB)"; Expression={if ($_.L3CacheSize) {[math]::Round($_.L3CacheSize/1024, 1)} else {"Indefinido"}}}, @{Name="Vel. Cache L3 (GHz)"; Expression={if ($_.L3CacheSpeed) {[math]::Round($_.L3CacheSpeed/1000, 2)} else {"Indefinido"}}}, @{Name="Threads"; Expression={$_.ThreadCount}}, @{Name="Voltagem Atual"; Expression={if ($_.CurrentVoltage) {"$($_.CurrentVoltage/10)V"} else {"Indefinido"}}}, @{Name="Voltagens Suportadas"; Expression={if ($_.VoltageCaps) {($_.VoltageCaps -split "," | foreach {"$($_/10)V"}) -join ", "} else {"Indefinido"}}}, @{Name="Virtualização Ativa"; Expression={if ($_.VirtualizationFirmwareEnabled) {"Sim"} else {"Não"}}}, @{Name="ID PNP"; Expression={$_.PNPDeviceID}}, @{Name="Largura Endereço"; Expression={"$($_.AddressWidth)-bit"}}, @{Name="Largura Dados"; Expression={"$($_.DataWidth)-bit"}}, @{Name="Estado"; Expression={switch ($_.CpuStatus) {0 {"Desconhecido";} 1 {"CPU Habilitada";} 2 {"CPU Desabilitada";} 3 {"CPU Parcial";} 4 {"CPU Ociosa";} 5 {"CPU Reservada";} 6 {"Offline";} 7 {"Falha";} default {"Indefinido"}}}}, @{Name="Disponibilidade"; Expression={switch ($_.Availability) {1 {"Outro";} 2 {"Desconhecido";} 3 {"Em Execução";} 4 {"Aviso";} 5 {"Em Teste";} 6 {"Não Aplicável";} 7 {"Desligado";} 8 {"Offline";} 9 {"Fora de Serviço";} 10 {"Degradado";} 11 {"Não Instalado";} 12 {"Erro de Instalação";} default {"Indefinido"}}}}, @{Name="Status"; Expression={$_.Status}}, @{Name="Info Status"; Expression={switch ($_.StatusInfo) {1 {"Outro";} 2 {"Desconhecido";} 3 {"Habilitado";} 4 {"Desabilitado";} 5 {"Não Aplicável";} default {"Indefinido"}}}}; write "------------------------"; write "SSRAM"; write "------------------------"; Get-WmiObject Win32_PhysicalMemory | Select-Object @{Name="Fabricante"; Expression={if ($_.Manufacturer -and $_.Manufacturer.Trim() -ne "") { $_.Manufacturer } else { "Indefinido" }}}, @{Name="Nome da Parte"; Expression={if ($_.PartNumber -and $_.PartNumber.Trim() -ne "") { $_.PartNumber } else { "Indefinido" }}}, @{Name="Serial"; Expression={$_.SerialNumber}}, @{Name="Capacidade (GB)"; Expression={if ($_.Capacity) {[math]::Round($_.Capacity / 1GB, 0)} else { "Indefinido" }}}, @{Name="Potencial de Velocidade de Relógio (GHz)"; Expression={if ($_.ConfiguredClockSpeed) {[math]::Round($_.ConfiguredClockSpeed / 1000, 2)} else { "Indefinido" }}}, @{Name="Velocidade de Relógio em Uso (GHz)"; Expression={if ($_.Speed) {[math]::Round($_.Speed / 1000, 2)} else { "Indefinido" }}}, @{Name="Versão de DDR"; Expression={switch ($_.SMBIOSMemoryType) {20 {"DDR"} 21 {"DDR2"} 24 {"DDR3"} 26 {"DDR4"} 34 {"DDR5"} default { "Indefinido" }}}}, @{Name="Memória"; Expression={switch($_.TypeDetail) {1 {"Reservado"} 2 {"Outro"} 4 {"Desconhecido"} 8 {"Rapidamente Paginado"} 16 {"Coluna Estática"} 32 {"Porção em Pipeline"} 64 {"Síncrono"} 128 {"Assíncrono"} 256 {"Suporta ECC"} 512 {"Registrado"} 1024 {"Não Registrado"} 2048 {"LRDIMM"} default {"Indefinido"}}}}, @{Name="Localização"; Expression={if ($_.DeviceLocator -and $_.DeviceLocator.Trim() -ne "") { $_.DeviceLocator } else { "Indefinido" }}}, @{Name="Banco"; Expression={if ($_.BankLabel -and $_.BankLabel.Trim() -ne "") { $_.BankLabel } else { "Indefinido" }}}, @{Name="Largura de Dados em Barramento"; Expression={switch ($_.DataWidth) {64 {"64 (Padrão)"} 72 {"72 (ECC)"} default {"Indefinido"}}}}, @{Name="Voltagem Configurada"; Expression={if ($_.ConfiguredVoltage) {($_.ConfiguredVoltage/1000).ToString() + "V"} else { "Indefinido" }}}, @{Name="Voltagem Mínima"; Expression={if ($_.MinVoltage) {($_.MinVoltage/1000).ToString() + "V"} else { "Indefinido" }}}, @{Name="Voltagem Máxima"; Expression={if ($_.MaxVoltage) {($_.MaxVoltage/1000).ToString() + "V"} else { "Indefinido" }}}, @{Name="Removível"; Expression={if ($_.Removable -ne $null) { $_.Removable } else { "Indefinido" }}}, @{Name="Substituível"; Expression={if ($_.Replaceable -ne $null) { $_.Replaceable } else { "Indefinido" }}}; $traducaoUsage=@{"Auto-Select"="Seleção Automática";"Manual-Select"="Seleção Manual";"Hot Spare"="Reserva Quente";"Journal"="Jornal";"Retired"="Retirado";"Unassigned"="Não Atribuído"}; $traducaoOperabilidade=@{"OK"="Operacional";"Unknown"="Desconhecido";"No Media"="Sem Mídia";"Degraded"="Degradado";"Failed"="Falhou";"Offline"="Offline";"Online"="Online";"Read Only"="Somente Leitura";"Full Repair Needed"="Danificado"}; $traducaoDedupMode=@{"Disabled"="Desativado";"Enabled"="Ativado";"Unknown"="Desconhecido";"Savings Temporary"="Otimização Temporária";"Savings Calculation"="Cálculo de Otimização"}; $traducaoFileSystemType=@{"NTFS"="NTFS";"FAT32"="FAT32";"ReFS"="ReFS (Resilient File System)";"exFAT"="exFAT";"UDF"="UDF (Universal Disk Format)";"CDFS"="CDFS (Compact Disc File System)";"Unknown"="Desconhecido"}; write "------------------------"; write "VOLUMES"; write "------------------------"; $volumes=Get-Volume | Select-Object @{Name="ID do Volume"; Expression={$_.ObjectId}}, @{Name="Rótulo"; Expression={if ($_.FileSystemLabel -and $_.FileSystemLabel.Trim() -ne "") { $_.FileSystemLabel } else { "Nulo" }}}, @{Name="Nome"; Expression={if ($_.PSObject.Properties['FriendlyName'] -and $_.FriendlyName) { $_.FriendlyName } else { "Nulo" }}}, @{Name="Drive"; Expression={if ($_.DriveLetter) { $_.DriveLetter } else { "Nulo" }}}, @{Name="Tipo de Drive"; Expression={if ($_.DriveType) { $_.DriveType } else { "Nulo" }}}, @{Name="Sistema de Arquivos"; Expression={$fs=$_.FileSystemType; if ($fs -and $traducaoFileSystemType.ContainsKey($fs)) { $traducaoFileSystemType[$fs] } else { "Nulo" }}}, @{Name="Armazenamento Total (GB)"; Expression={if ($_.Size) {[math]::Round($_.Size/1GB,0)} else { "Nulo" }}}, @{Name="Armazenamento Restante (GB)"; Expression={if ($_.SizeRemaining) {[math]::Round($_.SizeRemaining/1GB,2)} else { "Nulo" }}}, @{Name="Operabilidade"; Expression={$opStatus=$_.OperationalStatus; if($opStatus -and $traducaoOperabilidade.ContainsKey($opStatus)) { $traducaoOperabilidade[$opStatus] } else { "Nulo" }}}, @{Name="Deduplicação"; Expression={$dedup=$_.DedupMode; if($dedup -and $traducaoDedupMode.ContainsKey($dedup)) { $traducaoDedupMode[$dedup] } else { "Nulo" }}}; $volumes | sort Rótulo | foreach { $_.PSObject.Properties | foreach { if (-not $_.Value -or $_.Value -eq "") { $_.Value = "Nulo" } }; $_ }; write "------------------------`n"; write "------------------------"; write "PHYSICAL DISKS"; write "------------------------"; $physicalDisks = Get-PhysicalDisk | Select-Object @{Name="ID"; Expression={$_.DeviceID}}, @{Name="Nome"; Expression={if ($_.FriendlyName) { $_.FriendlyName -replace "\s", "" } else { "Nulo" }}}, @{Name="Serial"; Expression={if ($_.SerialNumber) { $_.SerialNumber } else { "Nulo" }}}, @{Name="Media"; Expression={if ($_.MediaType) { $_.MediaType } else { "Nulo" }}}, @{Name="Barramento"; Expression={if ($_.BusType) { $_.BusType } else { "Nulo" }}}, @{Name="Adicionável em Pool"; Expression={if ($null -ne $_.CanPool) { $_.CanPool } else { "Nulo" }}}; $physicalDisks | sort ID; $physicalDisks = Get-PhysicalDisk | Select-Object @{Name="ID"; Expression={$_.DeviceID}}, @{Name="Nome"; Expression={if ($_.FriendlyName) { $_.FriendlyName -replace "\s", "" } else { "Nulo" }}}, @{Name="Serial"; Expression={if ($_.SerialNumber) { $_.SerialNumber } else { "Nulo" }}}, @{Name="Media"; Expression={if ($_.MediaType) { $_.MediaType } else { "Nulo" }}}, @{Name="Barramento"; Expression={if ($_.BusType) { $_.BusType } else { "Nulo" }}}, @{Name="Adicionável em Pool"; Expression={if ($null -ne $_.CanPool) { $_.CanPool } else { "Nulo" }}}; $physicalDisks | sort ID; write "------------------------`n"; write "------------------------"; write "DISK DRIVES"; write "------------------------"; $traducaoMediaType=@{"Fixed hard disk media"="Disco Rígido Fixo";"External hard disk media"="Disco Rígido Externo";"Removable media"="Mídia Removível"};$traducaoInterfaceType=@{"SCSI"="SCSI";"IDE"="IDE (Drive Eletrônico Integrado)";"USB"="USB";"SATA"="SATA";"SAS"="SAS (Serial Attached SCSI)";"NVMe"="NVMe";"Fibre Channel"="Canal de Fibra";"RAID"="RAID (Matriz Redundante de Discos Independentes)";"iSCSI"="iSCSI (SCSI sobre IP)";"ATA"="ATA (Tecnologia Avançada de Anexo)";"1394"="IEEE 1394 (FireWire)";"SD"="SD";"MMC"="MMC (MultiMediaCard)";"Virtual"="Disco Virtual";"SSA"="SSA";"External"="Disco Rígido Externo";"Fixed"="Disco Rígido Fixo"}; $traducaoMediaType=@{"Fixed hard disk media"="Disco Rígido Fixo";"External hard disk media"="Disco Rígido Externo";"Removable media"="Mídia Removível"};$traducaoInterfaceType=@{"SCSI"="SCSI";"IDE"="IDE (Drive Eletrônico Integrado)";"USB"="USB";"SATA"="SATA";"SAS"="SAS (Serial Attached SCSI)";"NVMe"="NVMe";"Fibre Channel"="Canal de Fibra";"RAID"="RAID (Matriz Redundante de Discos Independentes)";"iSCSI"="iSCSI (SCSI sobre IP)";"ATA"="ATA (Tecnologia Avançada de Anexo)";"1394"="IEEE 1394 (FireWire)";"SD"="SD";"MMC"="MMC (MultiMediaCard)";"Virtual"="Disco Virtual";"SSA"="SSA";"External"="Disco Rígido Externo";"Fixed"="Disco Rígido Fixo"}; $diskDrives = Get-WmiObject Win32_DiskDrive | Select-Object @{Name="ID"; Expression={$_.DeviceID -replace "^\\\\\.\\", ""}}, @{Name="Modelo"; Expression={$_.Model}}, @{Name="Partições"; Expression={$_.Partitions}}, @{Name="Tamanho (GB)"; Expression={[math]::Round($_.Size / 1GB, 0)}}, @{Name="Interface"; Expression={ $interface=$_.InterfaceType; if($interface -and $traducaoInterfaceType.ContainsKey($interface)) { $traducaoInterfaceType[$interface] } else { if($interface) { $interface } else { "Indefinido" }}}}, @{Name="Media"; Expression={ $m=$_.MediaType; if($m -and $traducaoMediaType.ContainsKey($m)) { $traducaoMediaType[$m] } else { if($m) { $m } else { "Indefinido" } }}}; $diskDrives | sort ID; write "------------------------"; write "USBs"; write "------------------------"; Get-WmiObject Win32_USBController | Select-Object @{Name="ID"; Expression={$_.DeviceID}}, @{Name="Nome"; Expression={$_.Caption}}, @{Name="Fabricante"; Expression={$_.Manufacturer}}, @{Name="Descrição do Tipo"; Expression={$_.Description}}, @{Name="Protocolo (USB Version)"; Expression={switch ($_.ProtocolSupported) {1 {"Outro"} 2 {"Desconhecido"} 3 {"EISA"} 4 {"ISA"} 5 {"PCI"} 6 {"ATA/ATAPI"} 7 {"Disquete Flexível"} 8 {"1496"} 9 {"SCSI Paralelo"} 10 {"SCSI Fibre Channel"} 11 {"SCSI Serial Bus"} 12 {"SCSI Serial Bus-2 (1394)"} 13 {"SCSI Serial Storage Architecture"} 14 {"VESA"} 15 {"PCMCIA"} 16 {"USB (Universal Serial Bus)"} 17 {"Protocolo Paralelo"} 18 {"ESCON"} 19 {"Diagnóstico"} 20 {"I2C"} 21 {"Energia"} 22 {"HIPPI"} 23 {"MultiBus"} 24 {"VME"} 25 {"IPI"} 26 {"IEEE-488"} 27 {"RS232"} 28 {"IEEE 802.3 10BASE5"} 29 {"IEEE 802.3 10BASE2"} 30 {"IEEE 802.3 1BASE5"} 31 {"IEEE 802.3 10BROAD36"} 32 {"IEEE 802.3 100BASEVG"} 33 {"IEEE 802.5 Token-Ring"} 34 {"ANSI X3T9.5 FDDI"} 35 {"MCA"} 36 {"ESDI"} 37 {"IDE"} 38 {"CMD"} 39 {"ST506"} 40 {"DSSI"} 41 {"QIC2"} 42 {"Enhanced ATA/IDE"} 43 {"AGP"} 44 {"TWIRP (Two-Way Infrared)"} 45 {"FIR (Fast Infrared)"} 46 {"SIR (Serial Infrared)"} 47 {"IrBus"} default {"Indefinido"} }}}, @{Name="PNP ID"; Expression={$_.PNPDeviceID}}, @{Name="Status"; Expression={switch ($_.Status) {"OK" {"Operacional"} "Error" {"Erro"} "Degraded" {"Degradado"} "Unknown" {"Desconhecido"} "Pred Fail" {"Falha Iminente"} "Starting" {"Iniciando"} "Stopping" {"Parando"} "Service" {"Em Serviço"} "Stressed" {"Sob Stress"} "NonRecover" {"Não Recuperável"} "No Contact" {"Sem Contato"} "Lost Comm" {"Comunicação Perdida"} default {"Indefinido"}}}}
}
function GetHeaviestFiles {
    $logFile = "$env:TEMP\FileScanLog.txt"
    [Console]::ForegroundColor = "Cyan"
    write "Starting scan at $(Get-Date)"
    [Console]::ResetColor()
    "Starting scan at $(Get-Date)" | Out-File $logFile
    
    $counter = 0
    $heaviestFiles = gci -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | foreach {
        $counter++
        if ($counter % 1000 -eq 0) {
            [Console]::ForegroundColor = "Gray"
            $msg = "Scanned $counter files. Current: $($_.Directory)"
            write $msg
            [Console]::ResetColor()
            $msg | Out-File $logFile -Append
        }
        $_
    } | sort Length -Descending | select -First 200 FullName, @{N="SizeGB";E={[math]::Round($_.Length/1GB,2)}}
    
    foreach ($file in $heaviestFiles) {
        [Console]::ForegroundColor = "Yellow"
        $msg = "Top file: $($file.FullName) ($($file.SizeGB)GB)"
        write $msg
        [Console]::ResetColor()
        $msg | Out-File $logFile -Append
    }
    
    [Console]::ForegroundColor = "Cyan"
    $endMsg = "Scan completed at $(Get-Date). Total: $counter files"
    write $endMsg
    [Console]::ResetColor()
    $endMsg | Out-File $logFile -Append
    
    [Console]::ForegroundColor = "Green"
    write "Log saved to: $logFile"
    [Console]::ResetColor()
    
    return $heaviestFiles
}
function GetHeaviestFolders {
    $folderSizes = @{}
    $counter = 0
    
    gci -Path C:\ -Recurse -File -ErrorAction SilentlyContinue | foreach {
        $currentFolder = $_.Directory
        while ($currentFolder) {
            if ($folderSizes[$currentFolder.FullName]) {
                $folderSizes[$currentFolder.FullName] += $_.Length
            } else {
                $folderSizes[$currentFolder.FullName] = $_.Length
            }
            $currentFolder = $currentFolder.Parent
        }
        
        $counter++
        if ($counter % 1000 -eq 0) {
            [Console]::ForegroundColor = "Cyan"
            write "Scanned $counter files... Current location: $($_.Directory)"
            [Console]::ResetColor()
        }
    }
    
    [Console]::ForegroundColor = "Green"
    write "`nCOMPLETE: Processed $counter files total.`n"
    [Console]::ResetColor()
    
    $results = $folderSizes.GetEnumerator() | sort Value -Descending | select -First 200 | foreach {
        New-Object PSCustomObject -Property @{
            FolderPath = $_.Key
            TotalSizeGB = [math]::Round($_.Value/1GB, 2)
            TotalSizeMB = [math]::Round($_.Value/1MB, 2)
            FileCount = (gci $_.Key -File -Recurse -ErrorAction SilentlyContinue).Count
        }
    } | ft -AutoSize
    
    return $results
}
function SearchInteractively {
    $targetFile = Read-Host "Enter the filename or pattern to search"
    $foundFiles = @()
    $oc = [Console]::ForegroundColor
    gci -Recurse | foreach {
        [Console]::ForegroundColor = "Cyan"
        write "Looking at: $($_.FullName)"
        if ($_.Name -like $targetFile) {
            $foundFiles += $_.FullName
        }
        [Console]::ForegroundColor = $oc
    }
    if ($foundFiles.Count -gt 0) {
        [Console]::ForegroundColor = "Green"
        write "`nMatches found for '$targetFile':"
        $foundFiles | foreach { write $_ }
        [Console]::ForegroundColor = $oc
    } else {
        [Console]::ForegroundColor = "Yellow"
        write "`nNo files found matching '$targetFile'."
        [Console]::ForegroundColor = $oc
    }
}
function GetConcatenatedGPTTokens {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Path')]
        [string]$JsonPath
    )

    process {
        try {
            $jsonContent = cat -Path $JsonPath -Raw -ErrorAction Stop | ConvertFrom-Json
            -join ($jsonContent | foreach {
                $_.data.v -replace '\\u201c', '"' -replace '\\u201d', '"' -replace '\\"', '"'
            } | foreach { "$_`n`n" }).TrimEnd()
        }
        catch {
            Write-Error "Failed to process JSON file: $_"
        }
    }
}
function GetJavaFilesData {
    write "Searching for Java files... 🌋"
    $result = (gci . -Recurse -File -Filter "*.java" | % { 
        try { 
            $oc = [Console]::ForegroundColor
            [Console]::ForegroundColor = 'Gray'
            [Console]::WriteLine("Found $($_.FullName)...")
            [Console]::ForegroundColor = $oc
            (cat $_.FullName -EA Stop).Count
         } catch { Write-Warning "Could not read file $($_.FullName)"; 0 }
    }) | measure -Sum
    [PSCustomObject]@{
        'Total of Java Files' = $result.Count
        'Total of Java Lines' = $result.Sum
    }
}
function GetJavaScriptFilesData {
    write "Searching for JavaScript-like files... 🌐"
    $result = (gci . -Recurse -File -Include *.js,*.cjs,*.mjs,*.jsx,*.ts,*.cts,*.mts,*.tsx,*.vue | % { 
        try { 
            $oc = [Console]::ForegroundColor
            [Console]::ForegroundColor = 'Gray'
            [Console]::WriteLine("Found $($_.FullName)...")
            [Console]::ForegroundColor = $oc
            (cat $_.FullName -EA Stop).Count
         } catch { Write-Warning "Could not read file $($_.FullName)"; 0 }
    }) | measure -Sum
    [PSCustomObject]@{
        'Total of JavaScript (or derivate) Files' = $result.Count
        'Total of JavaScript (or derivate) Lines' = $result.Sum
    }
}
function GetPhpFilesData {
    write "Searching for PHP... 🐘"
    $result = (gci . -Recurse -File -Filter "*.php" | % { 
        try { 
            $oc = [Console]::ForegroundColor
            [Console]::ForegroundColor = 'Gray'
            [Console]::WriteLine("Found $($_.FullName)...")
            [Console]::ForegroundColor = $oc
            (cat $_.FullName -EA Stop).Count
         } catch { Write-Warning "Could not read file $($_.FullName)"; 0 }
    }) | measure -Sum
    [PSCustomObject]@{
        'Total of PHP Files' = $result.Count
        'Total of PHP Lines' = $result.Sum
    }
}
function GetPythonFilesData {
    write "Searching for Python... 🐍"
    $result = (gci . -Recurse -File -Filter "*.py" | % { 
        try { 
            $oc = [Console]::ForegroundColor
            [Console]::ForegroundColor = 'Gray'
            [Console]::WriteLine("Found $($_.FullName)...")
            [Console]::ForegroundColor = $oc
            (cat $_.FullName -EA Stop).Count
        } catch { Write-Warning "Could not read file $($_.FullName)"; 0 }
    }) | measure -Sum
    [PSCustomObject]@{
        'Total of Python Files' = $result.Count
        'Total of Python Lines' = $result.Sum
    }
}
function GetProgramLanguageFilesData {
    write "Searching for included programming languages... 👨‍💻"
    $result = (gci . -Recurse -File -Include $args | % { 
        try {
            $oc = [Console]::ForegroundColor
            [Console]::ForegroundColor = 'Gray'
            [Console]::WriteLine("Found $($_.FullName)...")
            [Console]::ForegroundColor = $oc
            (cat $_.FullName -EA Stop).Count
        } catch { Write-Warning "Could not read file $($_.FullName)"; 0 }
    }) | measure -Sum
    [PSCustomObject]@{
        'Total Files' = $result.Count
        'Total Lines' = $result.Sum
    }
}
# Complex Functions
Set-Alias -Name sann -Value SanitizeNames
Set-Alias -Name compweb -Value CompressCurrentDirectory
Set-Alias -Name unzipall -Value UnzipAll
Set-Alias -Name deletezip -Value DeleteAllCompressed
Set-Alias -Name getprocfull -Value GetProcessorData
Set-Alias -Name getssramfull -Value GetSSRAMData
Set-Alias -Name getstoragefull -Value GetStorageDeviceData
Set-Alias -Name getusbportfull -Value GetUSBPortData
Set-Alias -Name getvcfull -Value GetVideoControllerData
Set-Alias -Name gethwfull -Value GetGroupedHardware
Set-Alias -Name getheavfiles -Value GetHeaviestFiles
Set-Alias -Name getheavdirs -Value GetHeaviestFolders
Set-Alias -Name isearch -Value SearchInteractively
Set-Alias -Name getgpttokens -Value GetConcatenatedGPTTokens
Set-Alias getjavadata GetJavaFilesData
Set-Alias getjsdata GetJavaScriptFilesData
Set-Alias getphpdata GetPhpFilesData
Set-Alias getpydata GetPythonFilesData
Set-Alias getplngdata GetProgramLanguageFilesData
# File managament
Set-Alias -Name np -Value notepad
Set-Alias -Name touch -Value NewFile
Set-Alias -Name comp -Value Compress-Archive
Set-Alias -Name exp -Value Expand-Archive
Set-Alias -Name outf -Value OutFile
Set-Alias -Name no -Value New-Object
Set-Alias -Name spt -Value Split-Path
Set-Alias -Name tpt -Value Test-Path
# Processes
Set-Alias -Name spp -Value Start-Process
Set-Alias -Name sep -Value Set-ExecutionPolicy
Set-Alias -Name gep -Value Get-ExecutionPolicy
# Storage
Set-Alias -Name getv -Value Get-Volume
Set-Alias -Name getpt -Value Get-Partition
Set-Alias -Name getpd -Value Get-PhysicalDisk
Set-Alias -Name getds -Value Get-Disk
Set-Alias -Name cbin -Value Clear-RecycleBin
# USB
Set-Alias -Name getusbcd -Value Get-USBControllerDevice
Set-Alias -Name getusbc -Value Get-USBController
# Proc and Mem
Set-Alias -Name getproc -Value Get-Processor
Set-Alias -Name getpmem -Value Get-PhysicalMemory
Set-Alias -Name getdd -Value Get-DiskDrive
Set-Alias -Name getld -Value Get-LogicalDisk
Set-Alias -Name getvc -Value Get-VideoController
# Core parts
Set-Alias -Name getbt -Value Get-Battery
Set-Alias -Name getpws -Value Get-PowerSetting
Set-Alias -Name getprn -Value Get-PrinterWMI
Set-Alias -Name getbios -Value Get-BIOS
Set-Alias -Name getcs -Value Get-ComputerSystem
Set-Alias -Name getos -Value Get-OperatingSystem
Set-Alias -Name getprod -Value Get-Product
Set-Alias -Name getsvc -Value Get-ServiceWMI
# Administration
Set-Alias -Name getua -Value Get-UserAccount
Set-Alias -Name getgu -Value Get-GroupUser
Set-Alias -Name getusr -Value Get-LocalUser
Set-Alias -Name getntlog -Value Get-NTLogEvent
# Network
Set-Alias -Name getnac -Value Get-NetworkAdapterConfiguration
Set-Alias -Name getna -Value Get-NetAdapter
Set-Alias -Name getnpc -Value Get-NetTCPConnection
Set-Alias -Name netshv -Value NetshWinsockVersionShowCatalog
Set-Alias -Name netsha -Value NetshWlan
Set-Alias -Name getndv -Value GetNetDrivers
Set-Alias -Name im -Value Install-Module
# Writting
Set-Alias -Name sttr -Value Start-Transcript
Set-Alias -Name sptr -Value Stop-Transcript
# Encoded
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