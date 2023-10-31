Import-Module ActiveDirectory
$Users = Import-Csv "C:\Scripts\user.csv"
$Path = # DN HERE
foreach ($User in $Users){
    $Username = "$($User.Firstname.Trim()[0]).$($User.Lastname.Trim())"
    $Username = $Username.ToLower()
    $DisplayName = "$($User.Firstname.Trim()) $($User.Lastname.Trim())"

    echo $Username
    echo $DisplayName
    echo $User.Firstname.Trim()
    echo $User.Lastname.Trim()

    if (Get-ADUser -F {DisplayName -eq $DisplayName}){
        $message = "User already exist " + $Username
        Write-Host $message 
    } else {
        $U = @{
        UserPrincipalName = "$($Username)"
        Name = $DisplayName
        GivenName = $User.Firstname.Trim()
        Surname = $User.Lastname.Trim()
        SamAccountName = $Username
        Enabled = $true
        Path = $Path
        Department = "Assembly"
        City = "Calgary"
        AccountPassword = $User.Password.Trim() | ConvertTo-SecureString -AsPlainText -Force 
        ChangePasswordAtLogon = $true
        }
        New-AdUser @U 
    }
}