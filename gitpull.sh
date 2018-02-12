#!/bin/bash

Usage() {
  if [[ $1 -eq "-u" ]];then
	echo "This is the usage script"
  	exit 0
  fi
 }

Colour() { 
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
 }

err_report() {
  echo -e "${RED}Error on line $1${NC}"
  exit 0
 }

trap 'err_report $LINENO' ERR

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
	read -p "Enter the version number you would like to pull, default is 1.5.0: " version
	if [[ $version == *.*.* ]] && [[ $version =~ ^[0-9]+(\.[0-9]+)+(\.[0-9]+)?$ ]];then
	  break
	fi
  done
 }

Directory() {
  if [ ! -d v$version ];then
	newdir="v$version"
	echo "$newdir"
	mkdir "$newdir"
	else echo "Directory v$version already exists"
  	exit 1
  fi
}

Navigate() {
  navcheck=0
  base=`pwd`/$newdir
  cd $base
  git clone $torq
  let "navcheck+=$?"
  git clone $torqfsp
  let "navcheck+=$?"
  cd `pwd`/TorQ-Finance-Starter-Pack 
  git checkout v$version
  let "navcheck+=$?"
  if [[ ! $navcheck -eq 0 ]]
  then
	echo "Failure to clone repositories, script will now exit."
	exit 0
  fi
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
Usage
Colour
Variables
VersionCheck
Directory
Navigate
