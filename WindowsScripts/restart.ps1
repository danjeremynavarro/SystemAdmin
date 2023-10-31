#(get-adcomputer -SearchBase "DN Here" -filter *).Name | Out-file C:\Scripts\misc\computers.txt
Restart-Computer -ComputerName (Get-Content C:\Scripts\misc\computers.txt) -Force -ErrorAction SilentlyContinue -ErrorVariable NoRestart
$NoRestart.targetobject | Out-file C:\Scripts\misc\norestart.txt
