
# audiobook folder: "storage/C1B2-0FF3/Audiobooks"


adb connect 192.168.2.30
adb start-server
Write-Host "The phone is now connected to the computer."

# # list all the files in the podcastAddict folder
# adb shell ls "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/"
# # list all the mp3 files recursively:
# adb shell find "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" -name "*.mp3"
# # pull all the mp3 files:
# adb pull "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" "C:\Users\Siebe\Phone_sync"

#push/move the files:
$video_folder = "C://Users//Siebe//Phone_sync//podcast//The Age of Napoleon Podcast"
$destination_path = "storage//C1B2-0FF3//Audiobooks/History//Napoleon"
# push all the files to the phone and show progress per file skip the files that already exist
Get-ChildItem -Path $video_folder -Recurse -File | ForEach-Object {
    $destination_file = $destination_path + $_.FullName.Substring($video_folder.Length)
    Write-Host "Pushing file: $_ to $destination_file"
    adb push $_.FullName $destination_file
}

# TODO 
# 1. change all the mp3 file name to their title, if title exist
# - move the folders with the mp3 files to the smart audio book player folder: 
    # This PC\Redmi Note 10 Pro\SD card\Audiobooks\1. Podcast-episodes

# - read the chapter bookmarks and convert them to audiobookplayer format
# - after the process is completed; delete the original podcasts in the podcastaddict folder