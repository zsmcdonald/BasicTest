#!/bin/bash


if [ $# -eq 0 ]; then
printf " This script will create a logfile of summary data for an RTD process. \n You must give command line parameters to this script for it to run effectively. \n Example usage: bash RTD.sh 7654 /home/user/directory jamesbradley21@hotmail.co.uk 1\n First input argument is the port number, second is the directory to save the logfile, third is the email address to send the log file to.\n If the fourth argument is set to 1 then it will  the error file and log file, setting it to 2 sends only the log file. \n\n !!!YOU MUST INPUT ARGUMENTS OR THE SCRIPT WILL NOT RUN!!! \n\n"
    echo "No arguments, you must (at least!) provide a port number to connect to an RTD process. The script will exit now."
    exit 1
fi
DATE=` date +%Y-%m-%d`
#Navigate to user input directory to store files there
cd $2
#Check for RTD error file, if it does not exist then create one named logerror.txt
LERR=logerror.txt
if [[ ! -f $LERR ]];then
touch $LERR
echo "No error log file detected, logfile created - logerror.txt"
fi



#Check if the port is active
if [[ ! $(wget http://homer:$1 -O-) ]] 2>/dev/null
 then printf "Port is not active, please check if the RTD is running and on port:$PORT, the script will now exit and must be restarted.			$DATE \n" >> $2/logerror.txt
	echo "Port is not active, script will now exit."
	exit 1
fi


#Check for RTD log file, if it does not exist then create one named logrtd.txt
LOG=logrtd.txt
if [[ ! -f $LOG ]];then
touch $LOG
echo "No log file detected, logfile created - logrtd.txt"
printf "%-15s %-15s %-15s \n" "Datestamp" "Table" "Count" >> $2/$LOG
fi



#Check if given directory exists, if it does not exist then exit the script
if [[ ! -d $2 ]];then
	printf "The given directory doesn't exist! Try again, maybe try type a little more carefully? The script will now exit and must be restarted."
	echo "Directory does not exist, this script will now exit and must be restarted			$DATE \n" >> $2/logerror.txt
	exit 1
fi

	
#Check if there are any tables to take a count from on the RTD
webtable=`w3m http://homer:$1/?"count tables[]"`
if [ $webtable -eq 0 ];then
	printf "There are no tables in the RTD currently, check the data feed for problems and ensure tickerplant connection is active.			$DATE \n" >> $2/logerror.txt
fi
#List tables and their counts in a text file that was created earlier (logrtd.txt)
web=`w3m http://homer:$1/?"enlist tables[]"`
for i in $web
do
totals=` w3m http://homer:$1/?$i | head -1 | awk '{print $5}' | head -c -4`;
printf "%-15s %-15s %-15s \n" $DATE $i $totals >> $2/$LOG
done


#Email the log and error file if the fourth argument is set to 1, sent only the logrtd.txt if set to 2
if [ $4 -eq 1 ];then
	echo "Log RTD file and error log sent to $3" | mail -s "RTD Log files" $3 -a $LOG -a $LERR
elif [ $4 -eq 2];then
	echo "Log RTD file sent to $3" | mail -s "RTD Log files" $3 -a $LOG
fi
#Set up crontab, run script every day at 12 noon
PATH=${PWD}
echo $PATH
echo "0 12 * * * sh $PATH/RTD.sh $1 $2 $3 $4" > ~/crontxt
crontab ~/crontxt
rm ~/crontxt

