
# this script outputs the size of all folders in the AppData folder

$sourcePath = "C:\Users\Siebe\AppData\Roaming"
# $sourcePath = "C:\Users\Siebe\AppData\Roaming\Adobe"
# $sourcePath = "C:\Users\Siebe\AppData\Roaming\Adobe\Common"

$folders = Get-ChildItem -Path $sourcePath -Directory

foreach ($folder in $folders) {
    $folderName = $folder.Name
    $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse | Measure-Object -Property Length -Sum).Sum

    $formattedSize = "{0:N2} GB" -f ($folderSize / 1GB)

    Write-Host "Folder Name: $folderName"
    Write-Host "Folder Size: $formattedSize"
    Write-Host
}
