gci -Path (Get-Location) -Recurse -File | foreach {
    $file = $_.FullName
    write "Checking $file"
    $found = $false
    $results = @()
    ps | foreach {
        $process = $_
        $_.Modules | foreach {
            if ($_.FileName -eq $file) {
                $found = $true
                $results += [PSCustomObject]@{
                    ProcessName = $process.ProcessName
                    ProcessId   = $process.Id
                    FilePath    = $_.FileName
                }
            }
        }
    }
    if ($found) {
        $results | ft -AutoSize
    } else {
        write "No process found for file"
    }
    write ""
}