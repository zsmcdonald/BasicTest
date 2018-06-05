#!/bin/bash

read -p "Check over X number of days for files that have been modified in that time period. Enter a value in days: " days
USER=`whoami`
echo $USER
read -p "Insert name of given backup file you wish to save it as, without .tar.gz: " name
if [ -f $name.tar.gz ];then
	echo "File name already in use, script will exit now"
	exit 1
else
	echo "File name not in use, backup will be saved as $name.tar.gz"
fi
find /home/$USER -type f -mtime -$days | xargs -r tar -cvzf "$name".tar.gz 

