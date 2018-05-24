#!/bin/bash
#Set each colour that will be used
RED='\033[0;31m'
NC='\033[0m'
BROWN='\033[0;100m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
MAG='\033[0;35m'
LY='\033[1;93m'


#Set coloured pattern of symbols for the tree
declare -a a=(${RED}'.'${NC} ${GREEN}'~' "'"${NC} ${LY}'◦'${NC} ${GREEN}"'" '~'${NC} ${MAG}'☆'${NC} ${YELLOW}'★'${NC})
#Read the first argument as the number of lines for the tree or asks for an input
if [ $# -eq 1 ];then
	s=$1
elif [ $# -eq 0 ];then
	read -p "Enter the number of lines you want the christmas tree to be (length), minimum of 6: " s
	s=${s:-6}
fi
#Set number of lines and spaces used for the tree
for (( w=1, r=7, n=1; n<=$s; n++ )) ; do
  for (( i=$s-n; i>0; i-- )) ;  do
    echo -n " "
  done
  for (( i=1; i<=w; i++ )) ; do
    echo -n -e "${a[r]}"
if [[ $r -gt 5 ]]; then
	r=0
else
	r=$r+1
fi
  done
  w=$w+2
  echo " "
done;
num=$(((((2*$s)-1)/2)-2))
#Use a larger base if the tree is over 25 lines long
if [[ $s -gt 25 ]];then
	num=$(($num-2))
	printf '%*s' $num 
	echo -e "${BROWN}|      |${NC}"
	printf '%*s' $num
	echo -e "${BROWN}|      |${NC}"
	printf '%*s' $num
	echo -e "${BROWN}|      |${NC}"
	printf '%*s' $num
	echo -e "${BROWN}| ____ |${NC}"
else    printf '%*s' $num
        echo -e "${BROWN}|   |${NC}"
        printf '%*s' $num
        echo -e "${BROWN}|   |${NC}"
        printf '%*s' $num
        echo -e "${BROWN}| _ |${NC}"
fi



