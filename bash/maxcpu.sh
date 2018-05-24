#!/bin/bash
names=`who | cut -d ' ' -f 1 | sort | uniq | paste -s -d,`
count=`who | cut -d ' ' -f 1 | sort | uniq | wc -l`
RED='\033[0;31m'
NC='\033[0m'

read -p "	Option 1 will display the user with the longest running process. 
	Option 2 will display all processes for all logged in users.
	Option 3 will display the user with the highest pcpu. Enter 1/2/3: " key 

case $key in
"1") max=`ps -u $names -o time,user,pid,pcpu,cmd | sort -k 1 -r | sed -n 2p | awk '{print $2}'`
     echo -e "The user with the highest cpu time usage is: ${RED}$max${NC} ";;
"2") ps -u $names -o time,user,pid,pcpu,cmd | sort -k 1 -r;;
"3") max=`ps -u $names -o pcpu,user,pid,time,cmd | sort -k 1 -r | sed -n 2p | awk '{print $2}'`
     echo -e "The user with the highest pcpu is: ${RED}$max${NC}";;
*)   echo -e "${RED}Pick 1 or 2 or 3, any other options will not run with this script!${NC}";;
esac
#Unsure whether or not to use etime (elapsed time) or time when using ps for this project
