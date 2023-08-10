
# this script is used to sync my phone with my computer

# ==================================
#  Initial connecting of the phone       
# ==================================

# Check whether the phone is connected to the computer
$adbDevicesOutput = adb devices -l

if ($adbDevicesOutput | Select-String "device") {
    Write-Host "The phone is connected to the computer."
    # Action to perform if the condition is true
} else {
    # Action when the phone is not connected to the computer
    Write-Host "The phone is not YET connected to the computer."
    # (enable wireless debugging on your phone)
    
    # adb tcpip 5555 # connect your phone to your computer via USB FIRST to grant permission

    adb shell ip -f inet addr show wlan0 # get your phone's IP address

    # connect to your phone via wireless debugging
    adb connect 192.168.2.30
    adb start-server
    Write-Host "The phone is now connected to the computer."
}

# ==================================
#         pushing
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
Write-Host "`n`n`nDo you want to push all .md files from the folder: $pc_folder  to the phone? (y/n)"
$answer = Read-Host
if ($answer -eq "y") {
    Write-Host "Pushing all .md files to the phone."
    
    # Loop through each .md file and push it to the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb push "$pc_folder\$fileName" "$obsidianPath$fileName"
    }

    Write-Host "All .md files have been pushed to the obsidian vault."

} else {
    Write-Host "Not pushing all .md files to the phone."
    exit
}

# ==================================
#           pulling 
# ==================================

Write-Host "Listing the files on the phone"
# get the path to the obsidian vault on the phone
$pc_folder = "C:\Users\Siebe\Documents\obsidian\Siebe"
$obsidianPath = "/sdcard/documents/Siebe/"
$mdFiles = adb shell ls "$obsidianPath*.md"
Write-Host "The following .md files are in the folder:`n`n $obsidianPath"
foreach ($file in $mdFiles) {
    Write-Host $file
}

# ask whether the user wants to pull all files from the phone
Write-Host "`n`n`nDo you want to PULL all .md files from the phone? (y/n) to the folder: $pc_folder"
$answer = Read-Host
if ($answer -eq "y") {
    Write-Host "Pulling all .md files from the phone."
    
    # Loop through each .md file and pull it from the phone
    foreach ($file in $mdFiles) {
        $fileName = $file.Name
        adb pull "$obsidianPath$fileName" "$pc_folder\$fileName"
    }

    Write-Host "All .md files have been pulled from the obsidian vault."

} else {
    Write-Host "Not pulling all .md files from the phone."
    exit
}
