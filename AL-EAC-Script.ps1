#connect to Exchange Online, should prompt a sign-in on the browser
Connect-ExchangeOnline -UserPrincipalName alavanh_chanthasaly@anfcorp.com
#will pull a list of 100 mobile devices | I only want the correctly enrolled devices | puts the devices in a formatted table based on the properties below
Get-MobileDevice -ResultSize 100 | where DeviceModel -eq "Outlook for iOS and Android" | Format-Table -auto DeviceAccessState, Identity

#TODO, only pull a list of devices that are QUARENTINED
# I think I found the solution? Change the ResultSize for different results. Also need to find a way to Group them by name.
#TODO - seems to pull a list of all devices that had attempted registration. So even ones that don't appear on EAC. See if there is a way I can get the pulled list to reflect EAC
Get-MobileDevice -ResultSize 100 | where DeviceAccessState -eq "Quarantined" | where DeviceModel -eq "Outlook for iOS and Android" | where UserDisplayName -CNotMatch "NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organizat"| Format-Table -auto DeviceAccessState, UserDisplayName
Get-MobileDevice -ResultSize 100 | where DeviceAccessState -eq "Quarantined" | where DeviceModel -eq "Outlook for iOS and Android" | 
Get-MobileDevice -ResultSize 100 -Filter "UserDisplayName -eq 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization'"

#This one seems to work!!
Get-MobileDevice -ResultSize 100 -SortBy UserDisplayName -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))" | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime

#WARNING MESSAGE
#==== DEV CODE ===
Connect-ExchangeOnline -UserPrincipalName alavanh_chanthasaly@anfcorp.com

$UserIdentity = Read-host -Prompt "Input name of user"

Get-MobileDevice -Mailbox $UserIdentity -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))" | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime, DeviceId
$QuarantinedDevices = Get-MobileDevice -Mailbox $UserIdentity -Filter "((UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization') -and (DeviceAccessState -eq 'Quarantined'))"
$TargetDeviceIDs = $QuarantinedDevices.DeviceID
#Write-Warning "Confirm information: `n User: $UserIdentity `n DeviceID: $TargetDeviceIDs" -WarningAction Inquire
#Set-CASMailbox -Identity $UserIdentity -ActiveSyncAllowedDeviceIDs @{add=$TargetDeviceIDs}
Write-Host "Unblock sent"
Get-MobileDevice -Mailbox $UserIdentity -Filter "UserDisplayName -ne 'NAMPR19A001.PROD.OUTLOOK.COM/Microsoft Exchange Hosted Organization'" -SortBy DeviceAccessState | Format-Table -Auto UserDisplayName, DeviceAccessState, FirstSyncTime, DeviceId

Read-host -Prompt "Press Enter to Continue"