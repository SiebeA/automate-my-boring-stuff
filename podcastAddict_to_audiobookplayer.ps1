
# filepath to the podcastAddict downloaded files:

# list all the files in the podcastAddict folder
adb shell ls "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/"
# list all the mp3 files recursively:
adb shell find "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" -name "*.mp3"
# pull all the mp3 files:
adb pull "/sdcard/Android/media/com.bambuna.podcastaddict/podcast/" "C:\Users\Siebe\Phone_sync"