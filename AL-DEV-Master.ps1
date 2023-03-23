# This is the Master script that will connect all the others.

#TODO - Making a prompt that lets us choose a script to run.
$UserSelection = Read-host -Prompt "Please choose an option below"
$ObjectList = @(1, 2, 3, 4, 5)

#TODO - Plug the userinput into array, so it can run the script.
#TODO - IF the userinput does not exist in the array, then prompt the user to try again.

# Run the script ($ObjectList[$UserSelection])

#Psuedocode below, thanks chatGPT ;)
$selectedItems = $items | Out-GridView -Title "Select items" -OutputMode Multiple
Write-Host "You selected:"
$selectedItems