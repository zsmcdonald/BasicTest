#!/bin/bashi
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

Func() {
list=`cat process.txt | cut -f 4 -d ','`
echo $list
while true;do
  read -p "Enter procname here: " procname
  if [[ $list =~ (^|[[:space:]])"$procname"($|[[:space:]]) ]];then
    echo -e ${GREEN}"Procname in list, taking you to $procname now!"${NC}
    break
  else
  echo -e ${RED}"Procname not accepted! Are you just stupid or did you make a typo?"${NC}
  fi
done
 }

Func
