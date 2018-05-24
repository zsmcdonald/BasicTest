#!/bin/bash
Colour() {
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
}

Inputs() {
while true;do
read -p "Enter 1 to search by keyword, enter 2 to search by PID:  " key
if [[ $key -eq 1 ]] || [[ $key -eq 2 ]];then
  echo -e "Option ${GREEN}$key${NC} accepted"
  break;
  else
  echo -e "${RED}Enter either 1 or 2!${NC}"
fi
done
#if [ -z "$key" ]
#  then
#    echo "You must pick an option! The script will now exit."
#       exit 1
#fi
read -p "Enter a time interval (in seconds) to check processes by that interval: " interval
#Checks for whether the interval is a number and if none is entered then a default value of 60s is applied
range='^[0-9]+$'
if [ -z "$interval" ]
  then
    echo -e "${RED}No interval given, 60 second default used instead.${NC}"
interval=${interval:-60}
fi
echo -e "Time interval of ${GREEN}$interval${NC} seconds chosen."
if ! [[ $interval =~ $range ]];then 
echo -e "You must input an integer value for time interval!${RED}Script will exit now${NC}" >&2; exit 1	
fi
 }

# When doing the search by keyword, the process that greps for the keyword is returned 
# To remove this I originally added "grep $key | grep -v grep" as part of the code; if the user wanted to find 
# any process running "grep" then it would not work. Possible solution would be to only use "grep -v grep" if
# there is only one result returned. Did not include due to time limitations and so many if statements present

#Case used to split search for keyword or PID
KillCases() {
case $key in
"1") read -p "Enter a keyword to search by: " word
echo -e "You have picked wisely, you want to search for all processes by keyword ${GREEN}$word${NC}
"
for ((i=1;i<=5;i++))
do
if [ $? -eq 0 ]; then
 echo "
	Processes with keyword: $word are currently running
        Process data is:
`ps aux | grep $word | grep -v grep`"
        check=2
else
        echo "Process no longer running"
        check=1
fi
sleep $interval
done
if [[ $check -eq 2 ]];then
#       ps -ef | grep $word | grep -v grep | awk '{print $2}' | xargs -r kill -9
        pkill -f $word 2>/dev/null
        echo "Kill command sent to processes with keyword $word."
fi
;;
"2") read -p "Enter a PID number to search by: " no
if [[ $no =~ $range ]] ;then
	echo -e "${GREEN}PID accepted${NC}"
	else	
	echo -e  "${RED}You can only only numbers for a PID!${NC}"
	exit 1
 fi
echo -e "You are searching all processes by PID: ${GREEN}$no${NC}"
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
	check=2
else
	echo "Process no longer running"
	check=1
fi
sleep $interval
done
if [[ $check -eq 2 ]];then
	kill -9 $no
	echo "PID $no has been killed. No survivors."
fi;;
*) echo "Pick 1 or 2, any other options will not run with this script!";;
esac
 }

Colour
Inputs
KillCases




