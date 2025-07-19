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