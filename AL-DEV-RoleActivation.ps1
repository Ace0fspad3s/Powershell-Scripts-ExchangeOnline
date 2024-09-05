#==== DEV CODE ===
# Activate EAC account. This must be done for any of the other cmdlets in other scripts to work. 
# Cmdlet authorization is dependant on the @365 account running them.
# See https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps

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