#!/bin/bash

Colour(){
  RED='\033[0;31m'
  NC='\033[0m'
  BROWN='\033[0;100m'
  YELLOW='\033[1;33m'
  GREEN='\033[0;32m'
  BLUE='\033[1;34m'
  MAG='\033[0;35m'
  LY='\033[1;93m'
 }

DiskUsage(){
  a=`df -h | grep -w "/home" | awk '{print $5}' | sed 's/[^0-9]*//g'`
 }

Output(){
  if [[ $a -gt 90 ]];then
    echo -e "${RED}"
    figlet -f big "Disk Usage at $a"
    echo -e "${NC}" 
  else
    echo -e "${RED}"
    figlet -f big  "Disk usage at $a, no need to panic"
    echo -e "${NC}"
  fi
 }

Colour
DiskUsage
Output


