#!/bin/bash
# script to make a hardlink from a file to my dotfiles repo
case "$1" in
    "")
        echo "please call this script with the file to hardlink"
        exit 1;;
    *)
	if [ -f "$1" ]; then
 	 	echo "$1 exists. hardlinking..."
		ln $1 $HOME/dotfiles/
		stat $1 | grep -i inode
		exit 0
	else 
 		 echo "$1 does not exist. Aborting..."
		exit 1
	fi
esac

