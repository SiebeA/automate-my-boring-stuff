<#
.SYNOPSIS
this script will output the size of all folders in the appdata folder with greatest values at first terminal sight
the function does not take any parameters
#>
function Get-CurrentDateTime {
    # Function logic goes here
}


$sourcePath = "C:\Users\Siebe\AppData\Roaming"

$folders = Get-ChildItem -Path $sourcePath -Directory

$folderSizes = foreach ($folder in $folders) {
    $folderName = $folder.Name
    $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse | Measure-Object -Property Length -Sum).Sum

    $formattedSize = "{0:N2} GB" -f ($folderSize / 1GB)

    [PSCustomObject]@{
        FolderName = $folderName
        FolderSize = $folderSize
        FormattedSize = $formattedSize
    }
}

$sortedFolders = $folderSizes | Sort-Object -Property FolderSize

foreach ($folder in $sortedFolders) {
    Write-Host "Folder Name: $($folder.FolderName)"
    Write-Host "Folder Size: $($folder.FormattedSize)"
    Write-Host
}

# echo the source path
Write-Host "Source Path: $sourcePath"