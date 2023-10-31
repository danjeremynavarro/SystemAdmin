Function remind-usersOfExpirationDate { 
    <# 
        DESCRIPTION
        Script to email users every day for 13 days before their password expires
         
        MANUAL USUAGE EXAMPLE (FROM A POWERSHELL SHELL)
        remind-Users 
    #>
    
# DEFINITIONS
$userOU = #DN Here
$sendFrom = #Email Here
$smtpServer = "smtp-relay.gmail.com"
$msgSubject = "Your MRO Electronics Password is Expiring Soon"

   
# ATTEMPT TO LOAD THE ACTIVE DIRECTORY MODULE
Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Host "ERROR. Failed to load Active Directory module. Is it installed?"; Exit }

# PULL INFORMATION FROM ACTIVE DIRECTORY
Try { $ADResults = Get-ADUser -SearchBase $userOU -Filter {(Enabled -eq $True) -and (EmailAddress -like "*")} -Properties EmailAddress, PasswordExpired, PasswordNeverExpires, PasswordLastSet }
Catch { Write-Host "ERROR. Failed to query Active Directory users. Invalid userOU?"; Exit }

# LOOP THROUGH USERS 
foreach ($user in $ADresults)
    {    
        #  CALCULATE TIME UNTIL PASSWD EXPIRES
        if (($user.PasswordExpired -ne $true) -and ($user.PasswordNeverExpires -ne $true) -and ($user.PasswordLastSet -ne $null))
        {
            $userPasswdExpiresDate = $user.PasswordLastSet +((get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.TotalDays)
            $daysRemaining = (New-TimeSpan -start (get-date) -end $userPasswdExpiresDate).Days            
        }
		else
        {
            $daysRemaining = 55
        }
        $msgBody = ("Your MRO Electronics password will expire in " + $daysRemaining + " days. If you do not change it before it expires you may be unable to access your email and/or your computer.</br></br>To change your password on your computer please press Ctrl+Alt+Del & select Change a Password.</br></br>Note that changing your password on your computer will change your email password to the same as well. After changing your password you will have to log back in to your Google Chrome and Google Drive File Stream on your computer.</br></br>As always if you need assistance please send an email to dan.navarro@mroelectronics.com.")
        
		# NOTIFY USER IF PASSWD EXPIRING WITHIN 13 DAYS
        if (($daysRemaining -le "13") -and ($daysRemaining -ne $null))
        {
            # DEFINE EMAIL TO BE SENT
            Function sendMsg
            {
                send-mailMessage -to $user.EmailAddress -subject $msgSubject -bodyAsHTML $msgBody -smtpServer $smtpServer -from $sendFrom -priority high
            }
            #sendMsg
        }
    }
}

remind-usersOfExpirationDate 