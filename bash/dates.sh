#!/bin/bash
Firstdate() {
  while true;do
	read -p "Enter the first date in the format MM/DD/YYYY: " fdate
	date "+%m/%d/%Y" -d "$fdate" > /dev/null  2>&1
	if [[ $? -eq 0 ]];then 
		break
	fi
  done
  date -d $fdate | grep Sun && checksunf=1 > /dev/null 2>&1 
  fdate=$(date -d $fdate +"%Y%m%d")
 }

Lastdate() {	
  while true;do
	read -p "Enter the second date in the format MM/DD/YYYY: " ldate
	date "+%m/%d/%Y" -d "$ldate" > /dev/null  2>&1
        if [[ $? -eq 0 ]];then
        	break
        fi
  done
  date -d $ldate | grep Sun && checksunl=1 > /dev/null 2>&1
  ldate=$(date -d $ldate +"%Y%m%d")
 }

Idiotcheck() {
  if [[ $fdate -ge $ldate ]];then
	echo "The first date must come before the second date! Script will now exit."
	exit 1
  fi
 }

Daycount() {
  while [[ "$fdate" -le "$ldate" ]]; do 
	date -d "$fdate" >> datecount.txt; 
	let fdate=$(date -d "$fdate + 1 day" +"%Y%m%d"); 
  done
	cat datecount.txt
  var=`cat datecount.txt | grep Sun | wc -l`
  if [[ $checksunf -eq 1 ]] && [[ $checksunl -eq 1 ]] && [[ $var -eq 2 ]];then
	echo "There are no Sundays between the two dates"
  elif [[ $checksunf -eq 1 ]] && [[ $checksunl -eq 1 ]];then
	var=$((var - 2))
	echo "There are $var Sunday(s) between the two dates"
  elif [[ $checksunf -eq 1 ]] || [[ $checksunl -eq 1 ]];then
	var=$((var - 1))
	echo "There are $var Sunday(s) between the two dates"
  else
	echo "There are $var Sunday(s) between the two dates"
  fi
  rm datecount.txt
 }


Firstdate
Lastdate
Idiotcheck
Daycount

