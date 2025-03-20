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