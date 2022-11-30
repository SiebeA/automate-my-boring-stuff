#!/bin/bash

# This script let the user show where he left off with his last projects;
#    it colours the filepath and filerooth
#    it opens the root folder of the project in the filemanager

echo
# read the content of the text file: ~/leftoff.txt and store it in $text
text=$(cat ~/leftoff.txt)
# use a regex to extract the text after the last r'/'
filename=${text##*/} # extract the text after the last r'/'
file_root=${text%/*} # extract the text before the last r'/'
# remove the newline character from the end of the string
file_root=${file_root%$'\n'}

# cd to the root folder of the project
cd $file_root


# append the filename to the file_root
absolute_path=$file_root/$filename

# append the file_root to 'xdg-open' and open the file
xdg-open $file_root



# append and  colour the file_root in green and the filename in red and echo it
echo -e "\e[32m$file_root\e[0m/\e[31m$filename\e[0m"
