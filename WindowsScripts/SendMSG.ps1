# This sends a msg to all computers specified by search base
$computers = (get-adcomputer -SearchBase #DN Here -filter *).Name
echo $computers

ForEach ($computer in $computers) {
    Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * 'This computer is misconfigured. Please email dan navarro This computer will be disabled if not reported immediately'" -ComputerName $computer
}
