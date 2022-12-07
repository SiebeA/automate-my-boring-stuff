#!/bin/bash

# this script is in production here:
# /bin/leftoff

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


#===============================================================
# colouring                 #
#%===============================================================

    # capture the first line of the text file
    firstline=$(echo "$text" | head -n 1)
    # echo the first line of the text file in red
    echo -e "\e[31m$firstline\e[0m"

    # capture text that is in "**"
    bold=$(echo "$text" | grep -o "\*\*.*\*\*")
    # echo the bold text in bold
    echo -e "\e[1m$bold\e[0m"



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