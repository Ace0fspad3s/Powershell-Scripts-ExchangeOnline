#==== DEV CODE ===
Connect-ExchangeOnline -UserPrincipalName YOUR_EMAIL_HERE@DOMAIN

$UserIdentity = Read-host -Prompt "Input name of user"

Get-MobileDevice -Mailbox $UserIdentity -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))" | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime, DeviceId
$QuarantinedDevices = Get-MobileDevice -Mailbox $UserIdentity -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))"
$TargetDeviceIDs = $QuarantinedDevices.DeviceID
Write-Warning "Confirm information: `n User: $UserIdentity `n DeviceID: $TargetDeviceIDs" -WarningAction Inquire
Set-CASMailbox -Identity $UserIdentity -ActiveSyncAllowedDeviceIDs @{add=$TargetDeviceIDs}
Write-Host "Unblock sent"
Get-MobileDevice -Mailbox $UserIdentity -Filter "UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization'" -SortBy DeviceAccessState | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime, DeviceId

Read-host -Prompt "Press Enter to Continue"