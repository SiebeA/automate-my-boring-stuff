# this script is used to sync my phone with my computer

"""
Note that
'sdcard' is the internal storage
'/storage/C1B2-0FF3/' is the external storage

and adb uses backward slashes for paths
"""

# Determine the path for the PC folder and the Obsidian path
$obsidianPath = "/sdcard/Documents/Obsidian/"
adb shell ls $obsidianPath
$pc_folder = "C:/Users/Siebe/Desktop/Obsidian/"
# $pc_folder = Read-Host "Input the folder on the Pc where the files that you want to push are located"


# Connect to the phone if not already connected
$lsResult = adb shell ls "/storage" 2>&1
Write-Host "$lsResult"
if ($lsResult -like "*no*devices*" -or $lsResult -like "*offline*") {
    adb disconnect
    Write-Host "The phone is not connected."
    $connect_ID = Read-Host "Enter the last 5 digits of the IP address in your 'wireless debugging' on your phone"
    adb connect "192.168.2.8:$connect_ID"
    $devices = adb devices
    Write-Host "$devices"
} else {
    Write-Host "The phone is connected."
}

# Prompt the user to choose between push or pull
Write-Host "Do you want to sync files?"
Write-Host "1. Push files from PC to phone"
Write-Host "2. Pull files from phone to PC"
$syncOption = Read-Host "Enter the option number (1/2)"

# adb connect 192.168.2.30
# if this fails try this: adb connect 192.168.2.30:37943 # Look for "wireless debugging" on phone setting



adb start-server
Write-Host "The phone is now connected to the computer."

if ($syncOption -eq "1") {
    Write-Host "you've chosen to push files to your phone"
    # Push files from PC to phone
    # ==================================

    # List the .md files in the PC folder
    $mdFiles = Get-ChildItem -Path $pc_folder -Filter "*.md"
    # ask whether the user wants to push all files to the phone
    # print the files in the folder
    Write-Host "The following .md files are in the folder:`n`n $pc_folder"
    foreach ($file in $mdFiles) {
        Write-Host $file.Name
    }
    $continue = Read-Host "\n Pull those files? (y/n)"
    if ($continue -eq "y"){
    }

    Write-Host "`n`n`nPushing all .md files from the folder: $pc_folder  to the phone."
    
    # Loop through each .md file and push it to the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb push --sync "$pc_folder\$fileName" "$obsidianPath$fileName"
    }

    Write-Host "All .md files have been pushed to the obsidian vault."

    # ask the user to remove the files on the pc
    $remove = Read-Host "Do you want to remove the files from the PC? (y/n)"
    if ($remove -eq "y") {
        foreach ($file in $mdFiles) {
            $fileName = $file.Name
            Remove-Item "$pc_folder\$fileName"
        }
    }

} elseif ($syncOption -eq "2") {
    # Pull files from phone to PC
    # ==================================

    # get the path to the obsidian vault on the phone
    # $pc_folder = "C:\Users\Siebe\Documents\obsidian\Siebe"
    # $obsidianPath = "/sdcard/documents/Siebe/"

    #  check if the folder already exists
    if (Test-Path $pc_folder) {
        Write-Host "The folder already exists."
    } else {
        Write-Host "The folder does not exist. Creating it now."
        New-Item -Path $pc_folder -ItemType Directory
    }

    $mdFiles = adb shell ls "$obsidianPath*.md"
    Write-Host "The following .md files are in the folder:`n`n $obsidianPath"
    foreach ($file in $mdFiles) {
        Write-Host $file
    }

    # ask whether the user wants to continue
    $continue = Read-Host "\n Pull those files? (y/n)"
    if ($continue -eq "y"){

    }

    Write-Host "`n`n`nPulling all .md files from the phone to the folder: $pc_folder."
    
    # Loop through each .md file and pull it from the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb pull "$obsidianPath$fileName" "$pc_folder\$fileName"
    }

    Write-Host "All .md files have been pulled from the obsidian vault."

    # since I cannot seem not have a nested Obsidean folder:
    # Move files from nested "Obsidian" folder to parent folder
    $obsidianNestedFolder = Join-Path -Path $pc_folder -ChildPath "Obsidian"
    if (Test-Path -Path $obsidianNestedFolder) {
        Get-ChildItem -Path $obsidianNestedFolder | Move-Item -Destination $pc_folder -Force
    }

    # Remove the now-obsolete "Obsidian" folder
    Remove-Item -Path $obsidianNestedFolder -Force

    Write-Host "Files have been moved from nested 'Obsidian' folder to the parent folder and the 'Obsidian' folder has been removed."


} else {
    Write-Host "Invalid option selected. Exiting."
    exit
}