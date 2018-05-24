#!/bin/bash
while true;do
read -p "Enter the numbers to translate them to letters using mobile numpad decoding: " numbers
numbers=${numbers:-4433555555666}
if [[ $numbers =~ ^[0-9]+$ ]];then
break
fi
done
echo "Input string is $numbers"
num=0
count=${#numbers}
value=`echo ${numbers:$num:1}`
words=""
while [[ $count > $num ]];do
case $value in
"1") if [[ $value -eq 0 ]];then
	(( ++num ))
     fi ;;
"2") while [[ $value -eq 2 ]];do
     (( ++num ))
     if [[ $value -ne 2 ]];then 
	words+="a"
	break
     fi     
     (( ++num ))
     if [[ $value -ne 2 ]];then
	words+="b"
	break
     fi 
     (( ++num ))     
     if [[ $value -eq 2 || $value -ne 2 ]];then
	words+="c"
	break
     fi
     done ;;
"3") while [[ $value -eq 3 ]];do
     (( ++num ))
     if [[ $value -ne 3 ]];then
        words+="d"
        break
     fi
     (( ++num ))
     if [[ $value -ne 3 ]];then
        words+="e"
        break
     fi
     (( ++num ))
     if [[ $value -eq 3 || $value -ne 3 ]];then
        words+="f"
        break
     fi
     done ;;
"4") while [[ $value -eq 4 ]];do
     (( ++num ))
     if [[ $value -ne 4 ]];then
        words+="g"
        break
     fi
     (( ++num ))
     if [[ $value -ne 4 ]];then
        words+="h"
        break
     fi
     (( ++num ))
     if [[ $value -eq 4 || $value -ne 4 ]];then
        words+="i"
        break
     fi
     done ;;
"5") while [[ $value -eq 5 ]];do
     (( ++num ))
     if [[ $value -ne 5 ]];then
        words+="j"
        break
     fi
     (( ++num ))
     if [[ $value -ne 5 ]];then
        words+="k"
        break
     fi
     (( ++num ))
     if [[ $value -eq 5 || $value -ne 5 ]];then
        words+="l"
        break
     fi
     done ;;
"6") while [[ $value -eq 6 ]];do
     (( ++num ))
     if [[ $value -ne 6 ]];then
        words+="m"
        break
     fi
     (( ++num ))
     if [[ $value -ne 6 ]];then
        words+="n"
        break
     fi
     (( ++num ))
     if [[ $value -eq 6 || $value -ne 6 ]];then
        words+="o"
        break
     fi
     done ;;
"7") while [[ $value -eq 7 ]];do
     (( ++num ))
     if [[ $value -ne 7 ]];then
        words+="p"
        break
     fi
     (( ++num ))
     if [[ $value -ne 7 ]];then
        words+="q"
        break
     fi
     (( ++num ))
     if [[ $value -ne 7 ]];then
        words+="r"
        break
     fi
     (( ++num))
     if [[ $value -eq 7 || $value -ne 7 ]];then
        words+="s"
        break
     fi
     done ;;
"8") while [[ $value -eq 8 ]];do
     (( ++num ))
     if [[ $value -ne 8 ]];then
        words+="t"
        break
     fi
     (( ++num ))
     if [[ $value -ne 8 ]];then
        words+="u"
        break
     fi
     (( ++num ))
     if [[ $value -eq 8 || $value -ne 8 ]];then
        words+="v"
        break
     fi
     done ;;
"9") while [[ $value -eq 9 ]];do
     (( ++num ))
     if [[ $value -ne 9 ]];then
        words+="w"
        break
     fi
     (( ++num ))
     if [[ $value -ne 9 ]];then
        words+="x"
        break
     fi
     (( ++num ))
     if [[ $value -ne 9 ]];then
        words+="y"
        break
     fi
     (( ++num))
     if [[ $value -eq 9 || $value -ne 9 ]];then
        words+="z"
        break
     fi
     done ;;

"0") words+=" "
     (( ++num )) ;;
*) echo "Invalid input, only numeric integers are accepted"
   exit 0 ;;

esac
done
echo $words
