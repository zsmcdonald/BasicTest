#!/bin/bash

Colour() { 
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
 }

Usage() {
  case $1 in 
  "-u") printf "\n${RED}This script will download the TorQ basepack and TorQ Finance Starter Pack at specific version releases.\nTo leave variables as defaults, leave entries blank.${NC}\nDefaults in this script that can be changed are as follows:\nTorQ repository from: ${GREEN}https://github.com/AquaQAnalytics/TorQ.git${NC}\nTorQ FSP repository from: ${GREEN}https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git${NC}\nDefault release version for TorQ FSP: ${GREEN}1.5.0${NC}\nDefault directory both repositories they will be cloned from: ${GREEN}deploy${NC}\n\n";exit 0;;
  *);;
  esac
 }

Variables() {
  curdirec=`pwd`
  while true;do
    read -p "Enter a git link for the TorQ repository you wish to clone or leave blank for default: " torq
    torq=${torq:-https://github.com/AquaQAnalytics/TorQ.git}
    if [[ $torq == *.git ]];then
      break
    fi
  done
  echo -e "The TorQ respository will come from ${GREEN}$torq${NC}"
  while true;do
    read -p "Enter a git link for the TorQ FSP repository you wish to clone or leave blank for default: " torqfsp
    torqfsp=${torqfsp:-https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git}
    if [[ $torqfsp == *.git ]];then
      break
    fi
  done
  echo -e "The TorQ FSP respository will come from ${GREEN}$torqfsp${NC}"
  top=`pwd`/release
 }

VersionCheck() {
  while true;do
    read -p "Enter the version number you would like to pull for TorQ FSP, default is 1.5.0: " versionfsp
    versionfsp=${versionfsp:-1.5.0}
    if [[ $versionfsp == *.*.* ]] && [[ $versionfsp =~ ^[0-9]+(\.[0-9]+)+(\.[0-9]+)?$ ]];then
      break
    fi
  done
 }

Directory() {
  if [ ! -d release ];then
  mkdir release
  echo "Directory created: release"
  fi
  cd release
  while true;do
    read -p "Enter a name for the directory that TorQ packages will be stored in: " newdir
    if [ -z "$newdir" ];then
      echo "You must enter a valid string that is a directory name that does not already exist!"
    else
      break
    fi
  done
  if [ ! -d $newdir ];then
    mkdir "$newdir"
    else echo -e "${RED}Directory $newdir already exists${NC}"
    exit 1
  fi
  if [ ! -d logs ];then
    mkdir logs
  fi
  cd $newdir
 }

Navcheck() {
  navcheck=0
  echo "Starting TorQ repository clone"
  git clone $torq 
  if [[ $? -ne 0 ]];then
    echo "Clone failed"
  else echo "Clone successful"
  fi
  let "navcheck+=$?"
  echo "Starting TorQ FSP repository clone"
  git clone $torqfsp
  if [[ $? -ne 0 ]];then
    echo "Clone failed"
  else echo "Clone successful"
  fi
  let "navcheck+=$?"
  cd `pwd`/TorQ-Finance-Starter-Pack
  git checkout v$versionfsp
  let "navcheck+=$?"
  if [[ ! $navcheck -eq 0 ]];then
    echo "Failure to clone repositories, script will now exit."
    rm -rf $newdir
    exit 0
  fi
 }

Navigate() {
  base=$top/$newdir
  cd $base
  Navcheck
  cd $top
  if [ ! -d hdb ];then
    mv $newdir/TorQ-Finance-Starter-Pack/hdb $top
  fi
  while true;do
    read -p "Enter the name of directory you want to run the combined TorQ packages in, default is deploy: " direc
    direc=${direc:-deploy}
    if [[ ! -d $direc ]];then
      break
    else
	echo "Directory exists, enter a different name"
    fi
  done
  cd $base
  mkdir $direc
  cp -R $base/TorQ/* $direc/
  cp -R $base/TorQ-Finance-Starter-Pack/* $direc/
 }

StartScript() {
  cd $top
  while true;do
    read -p "Would you like to copy the most recent startup scripts to $base directory? y/n : " copyscript
    if [[ $copyscript == y || $copyscript == n ]];then
      break
    fi
  done
  if [[ $copyscript == y ]];then
    cp $curdirec/.startupscripts/* $base/
  fi
 }

Softlink() {
  cd $top
  while true; do
    read -p "Would you like to update the softlink (current) to the version downloaded? y/n : " choice 
    if [[ $choice == y || $choice == n ]];then
      break
    fi
  done  
  case $choice in 
  "y") rm -f current
       ln -s $base current
       echo "Softlink updated" ;;
  "n") echo "Softlink has not been updated" ;;
  *) echo "This option should not appear" ;;
  esac 
 }

err_report() {
  echo -e "${RED}Error on line $1${NC}"
  exit 0
 }

trap 'err_report $LINENO' ERR

