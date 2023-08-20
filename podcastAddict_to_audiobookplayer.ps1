
# audiobook folder: "storage/C1B2-0FF3/Audiobooks"

"""
Note that
'sdcard' is the internal storage
'/storage/C1B2-0FF3/' is the external storage
"""

# ==================================
#   Connecting      
# ==================================


# Write adb shell ls "/storage/C1B2-0FF3" to check if the phone is connected
$lsResult = adb shell ls "/storage/C1B2-0FF3" 2>&1 # By adding 2>&1 after the adb shell command, you're redirecting both standard output and standard error to the same variable $lsResult
Write-Host "$lsResult"
if ($lsResult -like "*no*devices*" -or $lsResult -like "*offline*") {
    adb disconnect
    Write-Host "The phone is not connected."
    $connect_ID = Read-Host "Enter the last 5 digits of the IP address in your 'wireless debugging' on your phone"
    adb connect "192.168.2.30:$connect_ID"
    $devices = adb devices
    Write-Host "$devices"

} else {
    Write-Host "The phone is connected."
}
# # list all the files in the podcastAddict folder
# adb shell ls "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/"
# # list all the mp3 files recursively:
# adb shell find "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" -name "*.mp3"
# # pull all the mp3 files:
# adb pull "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" "C:\Users\Siebe\Phone_sync"

#push/move the files:
$pc_folder = "C:\Users\Siebe\Desktop\Audiobooks\.Audiobook"
# list all the mp3 files recursively:
Get-ChildItem $pc_folder    -Recurse -File
Get-ChildItem $pc_folder
# ask the user to continue
$continue = Read-Host "Do you want to continue? (y/n)"
if ($continue -eq "y") {
    Write-Host "Continuing"
} else {
    Write-Host "Stopping"
    exit
}

$phone_destination = "/sdcard/A_Siebe/Audiobooks/"
# the following step is NECESSARY as otherwise there will be a permission error (ie existing folder does not work)
# if a the folder already exists delete it:
# adb shell rm -r $phone_destination
# adb shell su -c "mkdir -p $phone_destination"
adb shell ls $phone_destination

# Push all the files to the phone and show progress per file, skipping files that already exist
Get-ChildItem -Path $pc_folder -Recurse -File | ForEach-Object {
    $destination_file = $phone_destination + $_.FullName.Substring($pc_folder.Length).Replace("\", "/")
    Write-Host "Pushing file: $($_.FullName) to $destination_file"
    adb push $_.FullName $destination_file
}




# TODO 
# 1. change all the mp3 file name to their title, if title exist
# - move the folders with the mp3 files to the smart audio book player folder: 
    # This PC\Redmi Note 10 Pro\SD card\Audiobooks\1. Podcast-episodes

# - read the chapter bookmarks and convert them to audiobookplayer format
# - after the process is completed; delete the original podcasts in the podcastaddict folder