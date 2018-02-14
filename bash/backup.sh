#!/bin/bash

if [ $# -eq 1 ]; then
	name=$1
elif [ $# -eq 0 ]; then
	read -p "Enter the file name you want to make a clone of this to, remember to add .sh:" name
	name=${name:-backup.sh}
fi


if [[ -f $name ]]; then
	echo "A file named $name already exists in this directory!"
	exit 1
fi

me=`basename "$0"`

cp $me $name

