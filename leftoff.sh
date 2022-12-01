#!/bin/bash

# This script let the user show where he left off with his last projects;
#    it colours the filepath and filerooth
#    it opens the root folder of the project in the filemanager IF the user wants to
#    it opens the leftoff in the texteditor IF the user wants to

# if $1 = "-e" or "--edit" then open the text file in the editor
if [ "$1" = "--e" ] || [ "$1" = "--edit" ]; then # $1 is the first argument
    # open the text file in the editor
    subl ~/leftoff.txt
    exit

else
    echo
    echo '(you can edit the text file with the argument "-e" or "--edit")'
    # read the content of the text file: ~/leftoff.txt and store it in $text
    text=$(cat ~/leftoff.txt)
    # use a regex to extract the text after the last r'/'
    filename=${text##*/} # extract the text after the last r'/'
    file_root=${text%/*} # extract the text before the last r'/'
    # remove the newline character from the end of the string
    file_root=${file_root%$'\n'}


    # append the filename to the file_root
    absolute_path=$file_root/$filename

    # append and  colour the file_root in green and the filename in red and echo it
    echo -e "\e[32m$file_root\e[0m/\e[31m$filename\e[0m"
    echo
    echo "Here is a list of the files in the folder; with the lower files being the most recently updated:"
    echo
    ls -la --sort=time --reverse /home/Insync/Convexcreate@gmail.com/GD/Engineering/Development # list the files in the folder
    echo

    # ask user input whether to open the dir
    read -p "Do you want to open the directory? [y/n] " -n 1 -r # -n 1 means read only one character and -r means do not interpret backslash escapes
    # if the user input is y or Y then open the dir
    if [[ $REPLY =~ ^[Yy]$ ]]; then # =~ means match
        xdg-open "/home/Insync/Convexcreate@gmail.com/GD/Engineering/Development/"
        echo
    else
        echo
    fi


fi