#!/bin/bash

usage(){
echo "This script will allow the user to obtain the number of rows of each table for a given RTD."
echo "Sample usage: ./tablecount.sh -h <HOSTNAME> -p <PORTNUM> -l <LOGFILE> -e <EMAILUPDATE>"
echo "If no arguments are supplied then the script will look for the logfile name provided and retrieve the most recent successful connection."
echo "If it cannot find this file it will create it and default to homer 5016 if host and port haven't been provided."
	 }

LOGFILE=logfile
HOSTNM=$(cat $LOGFILE.txt |grep -o -P '(?<=Tables from ).*(?= at port)' | tail -1 | xargs)
if [[ -z "${HOSTNM// }" ]];
 then
  HOSTNM=homer
fi
PORT=$(cat $LOGFILE.txt |grep -o -P '(?<=at port).*(?=contain numbers of)' | tail -1 | xargs)
if [[ -z "${PORT// }" ]];
 then
  PORT=5016
fi
EMAIL=abyss@abyss.com

while getopts ':h:p:l:e:' opt; do
 case ${opt} in
    l)LOGFILE=$OPTARG
    ;;
    h)HOSTNM=$OPTARG
    ;;
    p)PORT=$OPTARG
    ;;
    e)EMAIL=$OPTARG
    ;;
    \?)usage ; exit 0
    ;;
  esac
done
echo "Subject: RTD Update">email.txt
echo "The status of the RTD at $HOSTNM port number $PORT has been updated please see details below.">>email.txt
if  nc -z -w5 $HOSTNM $PORT ;
then
 echo "Connection was established"
 date >> $LOGFILE.txt
 date >>email.txt
 echo "Tables from $HOSTNM at port $PORT contain numbers of entries as follows" | tee -a email.txt $LOGFILE.txt
 LOG="$(curl -gs "http://$HOSTNM:$PORT/?([]%20tablename:tables[];%20records:count%20each%20value%20each%20tables[])" | sed '0,/<pre>/d' | head -n -1 | tail -n +2)"
 if [[ ! -z "${LOG// }" ]];
 then
  echo "$LOG" | tee -a email.txt $LOGFILE.txt
  else
  echo "There are no tables to be found at $HOSTNM port number $PORT." | tee -a email.txt $LOGFILE.txt
 fi
else
  nc -z -v -w5 $HOSTNM $PORT
  echo "Failed attempt to access $HOSTNM $PORT was made at "$(date)" and produced the following error message" | tee -a email.txt $LOGFILE.txt 
  nc -z -v -w5 $HOSTNM $PORT >>$LOGFILE.txt 2>&1
  nc -z -v -w5 $HOSTNM $PORT >>email.txt 2>&1
fi

sendmail $EMAIL < email.txt
