#!/bin/bash
# https://xkcd.com/936/
printf "A strong password contains a variety of characters and length makes it stronger\nThis script ensures the password you enter meets the minimum requirements and states your password strength\n"
read -n 1 -s -r -p "PRESS ENTER TO CONTINUE SCRIPT"
echo ""  

if [ $# -eq 1 ]; then
	password=$1
elif [ $# -eq 0 ]; then
	read -p "Enter a password to check password strength:" password
fi

if [[ -f $password ]]; then
	password=`cat $password`
	echo "The password in the given file is: $password"
fi 


#Count each respective character class present in password

lower=`echo -n $password | tr -cd [:lower:] | wc -m`
upper=`echo -n $password | tr -cd [:upper:] | wc -m`
digit=`echo -n $password | tr -cd [:digit:] | wc -m`
punct=`echo -n $password | tr -cd [:punct:] | wc -m`
number=`echo -n $password | wc -c`

#Each character class must be present at least once with total length of 8 or password is not suitable

if [ $lower -lt 1 ]; then
	echo "No lower case letters detected, at least one lower case character required!"
	exit 1
elif [ $upper -lt 1 ]; then
       	echo "No upper case letters detected, one upper case character required!"
	exit 1
elif [ $digit -lt 1 ]; then
        echo "No numeric characters - password must contain at least one!"
	exit 1
elif [ $punct -lt 1 ]; then
	echo "No punctuation - password must contain at least one punctuation character!"
        exit 1
elif [ $number -lt 1 ]; then
	echo "Password length must be at least 8 characters"
	exit 1
fi

if [[ $number -lt 9 ]]; then
	echo "Your password is weak, try add more characters to make it stronger. $number characters is not enough!"
elif [[  $number -lt 13 ]]; then
	echo "Your password strength is medium, some more characters could help. $number characters is almost enough."
elif [[ $number -gt 12 ]]; then
	echo "Your password is strong!"
fi




