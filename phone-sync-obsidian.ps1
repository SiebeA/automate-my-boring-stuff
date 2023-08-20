# this script is used to sync my phone with my computer

# Prompt the user to choose between push or pull
Write-Host "Do you want to sync files?"
Write-Host "1. Push files from PC to phone"
Write-Host "2. Pull files from phone to PC"
$syncOption = Read-Host "Enter the option number (1/2)"

adb connect 192.168.2.30
# if this fails try this: adb connect 192.168.2.30:37943 # Look for "wireless debugging" on phone setting



adb start-server
Write-Host "The phone is now connected to the computer."

if ($syncOption -eq "1") {
    # Push files from PC to phone
    # ==================================

    # Determine the path for the PC folder and the Obsidian path
    $pc_folder = "C:\Users\Siebe\Documents\obsidian\Siebe"
    $obsidianPath = "/sdcard/documents/Siebe/"

    # List the .md files in the PC folder
    $mdFiles = Get-ChildItem -Path $pc_folder -Filter "*.md"
    # ask whether the user wants to push all files to the phone
    # print the files in the folder
    Write-Host "The following .md files are in the folder:`n`n $pc_folder"
    foreach ($file in $mdFiles) {
        Write-Host $file.Name
    }
    Write-Host "`n`n`nPushing all .md files from the folder: $pc_folder  to the phone."
    
    # Loop through each .md file and push it to the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb push "$pc_folder\$fileName" "$obsidianPath$fileName"
    }

    Write-Host "All .md files have been pushed to the obsidian vault."

} elseif ($syncOption -eq "2") {
    # Pull files from phone to PC
    # ==================================

    # get the path to the obsidian vault on the phone
    $pc_folder = "C:\Users\Siebe\Documents\obsidian\Siebe"
    $obsidianPath = "/sdcard/documents/Siebe/"
    $mdFiles = adb shell ls "$obsidianPath*.md"
    Write-Host "The following .md files are in the folder:`n`n $obsidianPath"
    foreach ($file in $mdFiles) {
        Write-Host $file
    }

    Write-Host "`n`n`nPulling all .md files from the phone to the folder: $pc_folder."
    
    # Loop through each .md file and pull it from the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb pull "$obsidianPath$fileName" "$pc_folder\$fileName"
    }

    Write-Host "All .md files have been pulled from the obsidian vault."

} else {
    Write-Host "Invalid option selected. Exiting."
    exit
}

TODO after pushing listing files first ask whether to continue