#!/bin/bash
UserOptions() {
  while true; do
  read -p "Enter 1 to search all processes by keyword and sent results via email, enter 2 to only display results on screen: " key
	if [[ $key -eq 1 || $key -eq 2 ]] 2>/dev/null;then
		break
	fi
  done
 }

Email() {
  if [[ $key -eq 1 ]];then
	while true; do
		read -p "Enter the email address (leave blank to use default address) you would like to send process details to: " email
		email=${email:-sean.murphy@aquaq.co.uk}
		if [[ $email != *@*.* ]];then
			echo "Email address must contain @ symbol and be in email format to be accepted!"
		else
			break
		fi
	done
  echo "The email address is set as: $email"
  fi
 }

ProcDetails() {
  case $key in
  "1") read -p "Enter the keyword you would like to search q processes by: " word
	ps -aux | awk '{print $2 " " $11$12}' | grep "q.*$word" | awk '{print $1}' | xargs ps -o user,pid,ppid,c,stime,tty,stat,time,cmd > procdetails.txt
	linenumber=`cat procdetails.txt | wc -l`
	if [[ $linenumber -gt 2 ]];then 
		mail -s "Process details with keyword $word" "$email" < procdetails.txt
	else
		echo "No processes running with $word currently"
	fi
	rm procdetails.txt ;;
  "2") read -p "Enter the keyword you would like to search q processes by: " word
	ps -aux | awk '{print $2 " " $11$12}' | grep "q.*$word" | awk '{print $1}' | xargs ps -o user,pid,ppid,c,stime,tty,stat,time,cmd ;;
  *) echo "You should never receieve this error but if you have then you did not enter 1 or 2 when prompted to, do better next time" ;;
  esac
 }

UserOptions
Email
ProcDetails
