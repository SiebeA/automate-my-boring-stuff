
"""
Note that
'sdcard' is the internal storage
'/storage/C1B2-0FF3/' is the external storage
"""


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

$audiobookplayer = '/sdcard/android/media/com.bambuna.podcastaddict/podcast'

adb shell ls $audiobookplayer
#The Age of Napoleon Podcast
adb shell ls $audiobookplayer/The\ Age\ of\ Napoleon\ Podcast
$napoleon = "The\ Age\ of\ Napoleon\ Podcast"
$consolidation = $audiobookplayer + "/" + $napoleon
Write-Host $consolidation


if (Test-Path "C:\Users\Siebe\Desktop\Audiobooks\.Audiobook") {
    Write-Host "The folder exists"
} else {
    Write-Host "The folder does not exist: creating folder:"
    New-Item -Path "C:\Users\Siebe\Desktop\Audiobooks\.Audiobook" -ItemType Directory
}

$destination_pc = "C:\Users\Siebe\Desktop\Audiobooks\.Audiobook"

# adb pull "/sdcard/android/media/com.bambuna.podcastaddict/podcast" $destination_pc
# show progress
adb pull "/sdcard/android/media/com.bambuna.podcastaddict/podcast" $destination_pc

# This PC\Redmi Note 10 Pro\Internal shared storage\Android\media\com.bambuna.podcastaddict\podcast\The Age of Napoleon Podcast

# X:\My Drive\Engineering\Development\SP_automate-my-boring-stuff\rename_mediaFile_from_metaData.py

# ask whether to call the script
$rename = Read-Host "Do you want to rename the files?"
# if yes or y
if ($rename -eq "yes" -or $rename -eq "y") {
    Write-Host "Renaming files"
    python "X:\My Drive\Engineering\Development\SP_automate-my-boring-stuff\rename_mediaFile_from_metaData.py"
} else {
    Write-Host "Not renaming files"
}

# ==================================
#         Pushing to the phone
# ==================================
# Specify the source directory on your PC
$source_pc = "C:\Users\Siebe\Desktop\Audiobooks\.Audiobook\podcast\The Age of Napoleon Podcast"
$destination_phone = "/sdcard/A_siebe/Audio-listening/Podcasts/Napoleon"

# Prompt the user for confirmation
$push = Read-Host "Do you want to push the files to the phone?"

if ($push -eq "yes" -or $push -eq "y") {
    Write-Host "Pushing files"

    # Create the destination directory on the Android device if it doesn't exist
    adb shell mkdir -p $destination_phone

    # create a loop to push all the files IF .mp3 files
    foreach ($file in Get-ChildItem $source_pc) {
        if ($file -like "*.mp3") {
            adb push $file $destination_phone
        }
    }

    Write-Host "Files pushed successfully"
} else {
    Write-Host "Not pushing files"
}





adb shell ls "/sdcard/A_siebe/Audio-listening/Podcasts/Napoleon"
Write-Host "`n those are the files on the phone after the operations"

# ask to delete the folder on the desktop
$delete = Read-Host "Do you want to delete the folder on the desktop?"
if ($delete -eq "yes") {
    Write-Host "Deleting folder"
    Remove-Item -Path "C:\Users\Siebe\Desktop\Audiobooks" -Recurse
} else {
    Write-Host "Not deleting folder"
}