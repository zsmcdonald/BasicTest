#!/bin/bash

SetVar() {
re='^[0-9]+$'
RED='\033[0;31m'
NC='\033[0m'
 }

Ports() {
while true;do
  read -p "Enter the start and end of range you want to check: " port1 port2
  if [[ $port1 =~ $re ]] && [[ $port2 =~ $re ]] && [[ $port1 < $port2 ]];then
    break
  else
    echo "Enter two integers, separated by a space! The second integer must be greater than the first!"
  fi
done

echo -e "Checking between ${RED}$port1${NC} and ${RED}$port2${NC}"
 }

AltNetstat() {
rng=`seq $port1 $port2 | tr '\n' '|' | head -c-1 | sed 's/.*/"&"/'`
netstat -tulpn | grep -E $rng
 }

SetVar
Ports
AltNetstat
