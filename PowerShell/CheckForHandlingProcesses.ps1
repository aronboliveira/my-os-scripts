gci -Path $(gl) -Recurse -File | % {
    $file = $_.FullName
    write "Checking " + $file
    ps | % {
        $process = $_
        $_.Modules | % {
            if ($_.FileName -eq $file) {
                [PSCustomObject]@{
                    ProcessName = $process.ProcessName
                    ProcessId   = $process.Id
                    FilePath    = $_.FileName
                }
            }
        }
    }
}