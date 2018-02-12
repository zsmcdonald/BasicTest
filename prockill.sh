#!/bin/bash


read -p "Enter 1 to search by keyword, enter 2 to search by PID:  " key

if [ -z "$key" ]
  then
    echo "You must pick an option! The script will now exit."
       exit 1
fi
read -p "Enter a time interval (in seconds) to check processes by that interval: " interval
#Checks for whether the interval is a number and if none is entered then a default value of 60s is applied
range='^[0-9]+$'
if [ -z "$interval" ]
  then
    echo "No interval given, 60 second default used instead"
interval=${interval:-60}
fi
if ! [[ $interval =~ $range ]];then 
echo "You must input an integer value for time interval! Script will exit now" >&2; exit 1	
fi

# When doing the search by keyword, the process that greps for the keyword is returned 
# To remove this I originally added "grep $key | grep -v grep" as part of the code; if the user wanted to find 
# any process running "grep" then it would not work. Possible solution would be to only use "grep -v grep" if
# there is only one result returned. Did not include due to time limitations and so many if statements present

#Case used to split search for keyword or PID
case $key in
"1") read -p "Enter a keyword to search by: " word
echo "You have picked wisely, you want to search for all processes by keyword $word"
for ((i=1;i<=5;i++))
do
ps aux | grep $word 2>/dev/null
if [ $? -eq 0 ]; then
 echo "
	Processes with keyword: $word are currently running
        Process data is:
	`ps aux | grep $word`"
        check=1
else
        echo "Process no longer running"
        check=2
fi
sleep $interval
done
if [ $check -eq 2];then
        killall $word
        echo "Processes have been killed."
fi
;;
"2") read -p "Enter a PID number to search by: " no
if [[ $no =~ $range ]] ;then
	echo "PID accepted"
	else	
	echo "You can only only numbers for a PID"
	exit 1
 fi
echo "You are searching all processes by PID: $no"
#Check process ID over time period, kill if it goes over the time period
for ((i=1;i<=5;i++))
do
ps $no 2>/dev/null
if [ $? -eq 0 ]; then
 echo "
	PID $no is still running
	Process data is:
	`ps -p $no`
	Process has been running for:
	`ps -o etime $no`"
	check=1
else
	echo "Process no longer running"
	check=2
fi
sleep $interval
done
if [ $check -eq 2];then
	kill -9 $no
	echo "PID $no has been killed. No survivors"
fi;;
*) echo "Pick 1 or 2, any other options will not run with this script!";;
esac





