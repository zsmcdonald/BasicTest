#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}This script will add a line to .bashrc that adds a timestamp to commands stored in .bash_history.
Unfortunately this does not work retroactively so it cannot check for commands input before the .bashrc change.${NC}"

grep -q "HISTTIMEFORMAT=\"%d/%m/%y %T	\"" ~/.bashrc && echo "bashrc has already been updated to include datetime format in history"  || (echo "export HISTTIMEFORMAT=\"%d/%m/%y %T	\"" >> ~/.bashrc && echo ".bashrc has been updated, script will now exit." && bash -l)



read -p "	Enter x number of days to find the history for that date, x will be taken away from today
	Enter 0 if you would like to find the history for today: " days



search=`date +%x -d "$days days ago"`

paste -sd '#\n' ~/.bash_history | awk -F"#" '{d=$2 ; $2="";print NR" "strftime("%d/%m/%y %T",d)" "$0}' | grep $search



#If you want to clear the history upon closing a session then add "unset HISTFILE" to .bashrc



