# this script is used to sync my phone with my computer

# """
# Note that
# 'sdcard' is the internal storage
# '/storage/C1B2-0FF3/' is the external storage

# and adb uses backward slashes for paths
# """

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
    return $true
}

