#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
path=`pwd`
grep -q "startupinfo" ~/.profile && echo -e "${BLUE}startupinfo script already present in .profile${NC}"  || (echo "bash $path/startupinfo.sh" >> ~/.profile && echo -e "${BLUE}.profile has been updated, the session will display startup information${NC}")

IPInfo()
{
  location=`curl -s ipinfo.io | awk '{print $2 " " $3}' | sed -n '5p' | tr -d '[:punct:]'`
  IP=`curl -s ipinfo.io | awk '{print $2 " " $3}' | sed -n "2p" | tr -d '[",]'`
  echo -e "You are currently logged in from:
${RED}$location${NC}"
  echo -e "Your external IP address is:
${RED}$IP${NC}"
}

TotalUser()
{
  numuser=`grep home/ /etc/passwd | wc -l` #This assumes every directory in /home is a user
  echo -e "The number of possible users that can log on is:
${RED}$numuser${NC}"
}

LastDate()
{
  ldate=`last $name | sed -n '2p' | awk  '{print $4 " " $5 " " $6 " " $7 }'` > /dev/null
  echo -e "The last time you were logged on was: 
${RED}$ldate${NC}"
} 


ActiveSessions()
{
  name=`whoami`
  count=`who | cut -d ' ' -f 1 | sort | uniq | wc -l`
  sessions=`who | grep $name | wc -l`
  echo -e "Active sessions for ${BLUE}$name
${RED}$sessions${NC}"
}

MemoryStat()
{
  usedmem=`df -h --total | tail -1 | awk '{print $3}'`
  freemem=`df -h --total | tail -1 | awk '{print $4}'`
  echo -e "The amount of free memory and used memory is:
${RED}$freemem				$usedmem${NC}"
}

UserBox()
{
  echo -e "The number of users currently logged in is:
  ${GREEN}
           +--------------+
          /|             /|
         / |            / |
        *--+-----------*  |
        |  |           |  |
        |  |    ${RED}$count${NC}${GREEN}     |  |
        |  |           |  |
        |  +-----------+--+
        | /            | /
        |/             |/
        *--------------*
  ${NC}"
}

Christmas()
{
  echo -e "${RED}$(expr $(date -d "DEC 25" +%j) - $(date +%j))${NC} "days until Christmas""
}

EURData()
{
  eurprice=`curl -s https://www.poundsterlinglive.com/data/currencies/eur-pairs/EURGBP-exchange-rate | sed -n "201p" | head -c-6`
  echo -e "The EUR/GBP exchange rate is currently ${RED}$eurprice${NC}"
  eurperc=`curl -s https://www.poundsterlinglive.com/data/currencies/eur-pairs/EURGBP-exchange-rate | sed -n "215p"`
 	if [[ $eurperc = *"green"* ]];then
	eurperc1=`echo $eurperc | cut -c27- | head -c -14`
	echo -e "The percentage change from yesterday is ${GREEN}$eurperc1${NC}"
	else
	eurperc1=`echo $eurperc | cut -c25- | head -c -14`
	echo -e "The percentage change from yesterday is ${RED}$eurperc1${NC}"	
	fi 
}

IPInfo
TotalUser
LastDate
ActiveSessions
MemoryStat
UserBox
Christmas
#EURData
