# Runs daily at 5:00am in Task Scheduler

$mdb_files = @(#File paths here)
$mdb_backup_directory = 'E:\MDB Backups\'
$local_log_file = "E:\mdblog.txt"

ForEach($i in $mdb_files){

    $filename = $i.split('\')[-1]
    $filepath = $mdb_backup_directory + $filename

    Copy-Item $i -Destination $filepath

    Write-Host $filepath

    $filename_as_str = $filename -as [string]
    $file, $extension = $filename_as_str.Split(".")
    $datestamp = "{0:MM_dd_yyyy}" -f (get-date).AddDays(-1)
    $newfilename = $datestamp + "_" + $file + "." + $extension
    Rename-Item -Path $filepath -NewName $newfilename
    $logoutput = $timestamp + " " + $newfilename + " " + "copied succesfully"
    Out-File -filepath $local_log_file -Encoding utf8 -NoClobber -Append -InputObject $logoutput

}

$toEmail = #Email here
$fromEmail = #Email here
$subject = "MDB Backup Task @ CG-App01"
$body = "Make sure to check the log files attached"
$smtpServer = "smtp-relay.gmail.com"
$logFile = "E:\mdblog.txt"
$SMTPMessage = New-Object System.Net.Mail.MailMessage($fromEmail,$toEmail,$subject,$body)
$attachment1 = New-Object System.Net.Mail.Attachment($logfile)
$SMTPMessage.Attachments.Add($attachment1)
$SMTPClient = New-Object Net.Mail.SmtpClient ($smtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Send($SMTPMessage)
$SMTPMessage.Dispose()
