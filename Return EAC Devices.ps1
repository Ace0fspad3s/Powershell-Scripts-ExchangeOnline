#Objective: Import a CSV of "Identity" names from EAC, and feed them into the "identity" to return a giant list of users and their devices + status'

$CSVFileName = "Users.csv"
$Path = #Insert CSV path here!


#Import a CSV file into a variable.
$CSVFile = Import-Csv -Path #Insert path here!

#Return a specific row, based on an object 
$CSVFile | Where-Object UserIdentity -EQ 'User3'

#$Row1 | Export-Csv -Path "$Path\outfile.csv" -NoTypeInformation