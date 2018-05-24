#!/bin/bash

Input() {
while true; do
  read -p "What word would you like displayed in some fancy ascii style? " word
  word=${word:-"Hello World!"}
  if [[ $word =~ ^[A-Za-z_]+$ ]];then
    break
  else
    echo "Only letters and underscores accepted"
  fi
 done
echo "The input has been set as: $word"
 }


Email() {
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
  }


Send() {
arr[0]="Email on the way"
arr[1]="Another one sending..."
arr[2]="Almost sent them all...hopefully"
arr[3]="Is this email going to Séan?"
arr[4]="To be honest, this was more of a test than anything else"
  for ((n=1;n<=10;n++));do
    printf "The current data and time is `date`.\nThe input word is displayed below.\n\n`figlet -f big $word`\n\n" | mail -s "Magic ascii art challenge" $email
    if [[ $n -ne 10 ]];then
      rand=$[ $RANDOM % 5 ]
      echo ${arr[$rand]}
    else
      echo "Mischief managed"
    fi
  done
 }
 
Input
mail
Send
