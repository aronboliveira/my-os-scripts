Get-ChildItem -Recurse -Include *.zip, *.7z, *.rar | ForEach-Object { if ($_.Extension -eq ".zip") { Expand-Archive -Path $_.FullName -DestinationPath $_.DirectoryName } elseif ($_.Extension -eq ".7z") { 7z x $_.FullName -o$($_.DirectoryName) } elseif ($_.Extension -eq ".rar") { unrar x $_.FullName $($_.DirectoryName) } }
