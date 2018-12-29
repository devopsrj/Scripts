# Define where Application writes the log files
$logFiles = "C:\path\"

# Define the location the log files should be archived to
$logArchive = "C:\path\"

# Define for how many days we should retain logs in the archive location
[int] $KeepRaw = 1
#$logLimitarchive = (Get-Date).day
$logLimitdelete = (Get-Date).AddDays(-7)
$CurrentDate = Get-Date -Hour 0 -Minute 0 -Second 0
$CompressBefore = (Get-Date -Date $CurrentDate).AddDays( - $KeepRaw)

# Datestamp the current log files and move them to the archive location
Get-ChildItem -Path $logFiles -Filter * |Where-Object {$_.LastWriteTime -lt $CompressBefore} |  ForEach-Object {
	$newName = "$($_.DirectoryName)\$(Get-Date -Format dd-MM-yyyy)-$($_.BaseName)$($_.Extension)"
	Rename-Item -Path $_.FullName -NewName $newName
	Move-Item -Path $newName -Destination $logArchive
	}

# Delete log files older than the defined number of days
Get-ChildItem -Path $logArchive | Where-Object {$_.LastWriteTime -lt $logLimitdelete} | Remove-Item -Force
