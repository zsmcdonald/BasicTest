#!/bin/bash

#Go to user home directory, save current path to navigate to it afterwards
#Find can be fed the home user directory which would save using cd to navigate, however ls doesn't work like that hence cd is used this way
path=`pwd`
cd /home/`whoami`

#Remove whitespace, replace with underscore
Remove(){
	find -name "* *" -type d | rename 's/ /_/g' 
	find -name "* *" -type f | rename 's/ /_/g'
}

Convert all uppercase letters to lowercase, the -n flag means the changes that would be made are listed without performing those ations
Conversion(){
	find . -depth -type f -exec rename -n 's!/([^/]*/?)$!\L/$1!' {} +
}

#Optional command to perform above actions without saving them
#Originally misread the question and had already done this bit so left it in anyway
read -p "Enter 1 to perform the script without making the changes in place for all files, enter 2 to exit without doing so: " key
if [ $key -eq 1 ];then
	ls -Rl | awk '{print $9}' | sed '/^$/d' | tr '\n' ' ' | tr '[:upper:]' '[:lower:]'
	echo ""
else
	exit 0
fi

Remove
Conversion

cd $path

