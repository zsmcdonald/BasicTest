#!/bin/bash

Colour() { 
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
 }

Usage() {
  case $1 in 
       "-u") printf "\n${RED}This script will download the TorQ basepack and TorQ Finance Starter Pack at specific version releases.\nTo leave variables as defaults, leave entries blank.${NC}\nDefaults in this script that can be changed are as follows:\nTorQ repository from: ${GREEN}https://github.com/AquaQAnalytics/TorQ.git${NC}\nTorQ FSP repository from: ${GREEN}https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git${NC}\nDefault release version for TorQ: ${GREEN}3.1.2${NC}\nDefault release version for TorQ FSP: ${GREEN}1.5.0${NC}\nDefault directory both repositories they will be cloned from: ${GREEN}deploy${NC}\n\n";exit 0;;
       *);;
  esac
 }

Variables() {
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
  if [ ! -d v$versionfsp ];then
	newdir="v$versionfsp"
	echo "$newdir"
	mkdir "$newdir"
	else echo "Directory v$version already exists"
  	exit 1
  fi
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
  if [[ ! $navcheck -eq 0 ]]
  then
        echo "Failure to clone repositories, script will now exit."
        rm -rf $newdir
        exit 0
  fi
 }


Navigate() {
  base=`pwd`/$newdir
  cd $base
  Navcheck
  cd $base
  while true;do
	read -p "Enter the name of directory you want to run the combined TorQ packages in, default is deploy: " direc
  	direc=${direc:-deploy}
	if [[ ! -d $direc ]];then
		break
	else
		echo "Directory exists, enter a different name"
	fi
  done
  mkdir $direc
  cp -R `pwd`/TorQ/* $direc/
  cp -R `pwd`/TorQ-Finance-Starter-Pack/* $direc/
 }

err_report() {
  echo -e "${RED}Error on line $1${NC}"
  exit 0
 }

trap 'err_report $LINENO' ERR

#Colour
#Usage $1
#Variables
#VersionCheck
#Directory
#Navigate
