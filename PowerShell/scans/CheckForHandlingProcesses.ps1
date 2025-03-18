gci -Path $(gl) -Recurse -File | % {
    $file = $_.FullName
    write "Checking $file"
    $found = $false
    $results = @()
    ps | % {
        $process = $_
        $_.Modules | % {
            if ($_.FileName -eq $file) {
                $found = true
                results += [PSCustomObject]@{
                    ProcessName = $process.ProcessName
                    ProcessId   = $process.Id
                    FilePath    = $_.FileName
                }
            }
        }
    }
    if ($found) {
        $results | Format-Table -AutoSize
    } else {
        write "No process found for file"
    }
    write ""
}