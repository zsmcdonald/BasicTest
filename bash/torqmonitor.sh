#!/bin/bash

Colour() {
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
 }

User() {
  read -p "Enter the username(leave blank for current user) to track torq processes by said user: " user
  user=${user:-$USER}
  count=`echo $user | wc -c`
  if [[ $count -gt 7 ]];then
    user=`echo $user | head -c 7`
    user+="+"
  fi
  echo -e "Username that will be search for is: ${GREEN}$user${NC}"
 }

Sleepvar() {
  while true; do
    read -p "Enter the amount of time to sleep for per cycle, default is 10(seconds): " sleepsec
    sleepsec=${sleepsec:-10}
    read -p "Enter the amount of times to loop through the sleep cycle, default is 5 loops: " cycle
    cycle=${cycle:-5}
    if [[ $cycle =~ ^[0-9]+$ && $sleepsec =~ ^[0-9]+$ ]];then
      break
    fi
  done
  echo -e  "Sleep time set as ${GREEN}$sleepsec${NC} seconds, number cycles set as ${GREEN}$cycle${NC}"
  rm -f trqdetail*
 } 

Email() {
  while true; do
    read -p "Enter the email address (leave blank to use default address) you would like to send process details to: " email
    email=${email:-stephen.mcdonald@aquaq.co.uk}
      if [[ $email != *@*.* ]];then
        echo "Email address must contain @ symbol and be in email format to be accepted!"
      else
       break
      fi
   done
  echo -e "The email address is set as: ${GREEN}$email${NC}"
 }

TorQMonitor() {
  ps -aux | grep $user | grep "q.*torq" | awk '{for(i=0;i<NF;i++) if ($i=="-procname") print $(i+1)}' > trqdetails.txt
  time=`ps -aux | grep $user | grep "q.*torq" | sed -n "1p" | awk '{print $9}'`
  countline=`cat trqdetails.txt | wc -l`
  if [[ $countline -eq 0  ]];then
    echo "No TorQ processes running for $user" > trqdetails.txt
    mail -s "TorQ Details" "$email" < trqdetails.txt
    echo -e "${RED}No TorQ processes found, an email alerting the user has been sent. Script will now exit as there is nothing to monitor.${NC}"
    rm -f trqdetail*
    exit 0
  elif [[ $countline -lt 10 ]];then
    echo "A TorQ Process has failed, consult TorQ log files. Script will now exit"
    exit 0
  else
    for((i=0;i<=5;i++));do
    echo $i
    sleep 5 
    ps -aux | grep $user | grep "q.*torq" | awk '{for(i=0;i<NF;i++) if ($i=="-procname") print $(i+1)}' >  trqdetails$i.txt
    change=`grep -n -v -f trqdetails$i.txt trqdetails.txt | cut -d ':' -f 1 | awk '{printf "%sp;", $0}' | head -c-1`
    echo $change
    if  [[ $change != "" ]];then
      printf "The following process(es) have failed.\n" > trqdetails99.txt
      sed -n "$change" trqdetails.txt >> trqdetails99.txt
      printf "The processes listed above were started at $time and failed at `date`" >> trqdetails99.txt
      mail -s "TorQ Process Failure" "$email" < trqdetails99.txt
      echo "TorQ Process Failure(s) detected, exiting script."
      exit 0
   else
     echo "There are no changes, all processes running"
   fi
   done
  fi
  rm trqdetails*
 }

Colour
User
Sleepvar
Email
TorQMonitor




