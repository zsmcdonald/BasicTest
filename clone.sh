#!/bin/bash

if [ $# -eq 1 ]; then
	name=$1
elif [ $# -eq 0 ]; then
	read -p "Enter the file name you want to make a clone of this to, remember to add .sh:" name
fi


if [[ "$name" != "*.sh" ]]; then
	echo "You must add .sh to the end of your filename if you want to continue!"
	exit 1
fi

me=`basename "$0"`

cp $me $name

