#!/bin/bash
Colour() {
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
 }

Input() {
  while true;do
  read -p "Enter the numbers to translate them to letters using mobile numpad decoding: " numbers
  numbers=${numbers:-94499903444300444088777733044433307777828336336687777}
  if [[ $numbers =~ ^[0-9]+$ ]];then
    break
  fi
  done
  echo "Input string is $numbers"
 }

ComplicatedIfStatements() {
  count=${#numbers}
  words=""
  forcount=`echo $numbers | fold -w1 | uniq -ic | wc -l`
  for (( num=1; num<=forcount; num++ ));do
    value=`echo $numbers | fold -w1 | uniq -ic | sed -n ""$num"p" | awk '{print $1}'`
    numpad=`echo $numbers | fold -w1 | uniq -ic | sed -n ""$num"p" | awk '{print $2}'`
    case $numpad in
    "1") ;;
    "2") if [[ $value -eq 1 ]];then
          words+="a"
          elif [[ $value -eq 2 ]];then
          words+="b"
          elif [[ $value -eq 3 ]];then
          words+="c"
          elif [[ $value -eq 4 ]];then
          words+="ca"
          elif [[ $value -eq 5 ]];then
          words+="cb"
          elif [[ $value -eq 6 ]];then
          words+="cc"
          fi
          ;;
     "3") if [[ $value -eq 1 ]];then
          words+="d"
          elif [[ $value -eq 2 ]];then
          words+="e"
          elif [[ $value -eq 3 ]];then
          words+="f"
          elif [[ $value -eq 4 ]];then
          words+="fd"
          elif [[ $value -eq 5 ]];then
          words+="fe"
          elif [[ $value -eq 6 ]];then
          words+="ff"
          fi
          ;;
     "4") if [[ $value -eq 1 ]];then
          words+="g"
          elif [[ $value -eq 2 ]];then
          words+="h"
          elif [[ $value -eq 3 ]];then
          words+="i"
          elif [[ $value -eq 4 ]];then
          words+="ig"
          elif [[ $value -eq 5 ]];then
          words+="ih"
          elif [[ $value -eq 6 ]];then
          words+="ii"
          fi
          ;;
     "5") if [[ $value -eq 1 ]];then
          words+="j"
          elif [[ $value -eq 2 ]];then
          words+="k"
          elif [[ $value -eq 3 ]];then
          words+="l"
          elif [[ $value -eq 4 ]];then
          words+="lj"
          elif [[ $value -eq 5 ]];then
          words+="lk"
          elif [[ $value -eq 6 ]];then
          words+="ll"
          fi
          ;;
     "6") if [[ $value -eq 1 ]];then
          words+="m"
          elif [[ $value -eq 2 ]];then
          words+="n"
          elif [[ $value -eq 3 ]];then
          words+="o"
          elif [[ $value -eq 4 ]];then
          words+="om"
          elif [[ $value -eq 5 ]];then
          words+="on"
          elif [[ $value -eq 6 ]];then
          words+="oo"
          fi
          ;;
     "7")if [[ $value -eq 1 ]];then
          words+="p"
          elif [[ $value -eq 2 ]];then
          words+="q"
          elif [[ $value -eq 3 ]];then
          words+="r"
          elif [[ $value -eq 4 ]];then
          words+="s"
          elif [[ $value -eq 5 ]];then
          words+="sp"
          elif [[ $value -eq 6 ]];then
          words+="sq"
          elif [[ $value -eq 7 ]];then
          words+="sr"
          elif [[ $value -eq 8 ]];then
          words+="ss"
          fi
          ;;
     "8") if [[ $value -eq 1 ]];then
          words+="t"
          elif [[ $value -eq 2 ]];then
          words+="u"
          elif [[ $value -eq 3 ]];then
          words+="v"
          elif [[ $value -eq 4 ]];then
          words+="vt"
          elif [[ $value -eq 5 ]];then
          words+="vu"
          elif [[ $value -eq 6 ]];then
          words+="vv"
          fi
          ;;
     "9") if [[ $value -eq 1 ]];then
          words+="w"
          elif [[ $value -eq 2 ]];then
          words+="x"
          elif [[ $value -eq 3 ]];then
          words+="y"
          elif [[ $value -eq 4 ]];then
          words+="z"
          elif [[ $value -eq 5 ]];then
          words+="zw"
          elif [[ $value -eq 6 ]];then
          words+="zx"
          elif [[ $value -eq 6 ]];then
          words+="zy"
          elif [[ $value -eq 6 ]];then
          words+="zz"
          fi
          ;;
     "0") words+=" "
          ;;
     *) echo "This error should never appear....."; exit 0 ;;
     esac 
  done 
  echo -e "${GREEN}$words${NC}"
 }

Colour
Input
ComplicatedIfStatements


