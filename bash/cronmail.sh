#!/bin/bash

echo "0 */4 * * * sh home/smacdonald/unixQ/cronmail.sh" > /home/smacdonald/crontxt
printf "This email is sent every 4 hours using crontab, hopefully not every four minutes.\nThe current date is `date`.\nFrom Stephen\n" | mail -s "Minute Linux Question" "ryan.mcpherson@aquaq.co.uk"
crontab /home/smacdonald/crontxt
rm /home/smacdonald/crontxt
