$DeviceAmount = Read-host -Prompt "How many devices to search? (Recommended maximum is 10000. High numbers will have a longer load time.)"
Connect-ExchangeOnline -UserPrincipalName alavanh_chanthasaly@anfcorp.com
$ObtainMobileList = Get-MobileDevice -ResultSize $DeviceAmount -SortBy UserDisplayName -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))"
$ObtainMobileList | ForEach-Object -Begin {
    $i = 0
    $output = ""
} -Process {
    if($_.message -like "Quarantined")
    {
        
        # Append the matching message to the out variable.
        $output=$output + $_.Message
    }
    $Completed = ($i/$ObtainMobileList.count) * 100
Write-Progress -Activity "Searching Devices" -Status "Progress:" -PercentComplete $Completed 
} -End {
    $output
}

$ObtainMobileList | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime

Read-host -Prompt "Press Enter to Continue"