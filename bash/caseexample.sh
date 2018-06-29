#!/bin/bash

Colours() {
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
 }

Example() {
read -p "Longest or highest CPU usage? (t/c): " mode
case $mode in
  t|T) echo -e  'USER\t TIME\t PCPUo'
       echo -e  ${GREEN}`ps -eo user,time,pcpu --sort time | tail -1`${NC};;
  c|C) echo -e  'USER\t TIME\t PCPU'
       echo -e ${GREEN}`ps -eo user,time,pcpu --sort pcpu | tail -1`${NC};;
  *) echo -e ${RED}"Seriously, can't you pick between two options?"${NC};;
esac 
 }

Colours
Example
