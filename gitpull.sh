#!/bin/bash

VersionCheck() {
  while true;do
	read -p "Enter the version number you would like to pull: " version
	if [[ $version == *.* ]] && [[ $version =~ ^[0-9]+(\.[0-9]+)?$ ]];then
		break
	fi
  done
 }


#BP=https://github.com/AquaQAnalytics/TorQ.git
#FSP=https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git

Directory() {
  if [ ! -d v$version ];then
	newdir="v$version"
	mkdir "$newdir"
	else echo "Directory v$version already exists"
  fi
}

Navigate() {
  cd `pwd`/$newdir
 }



VersionCheck
Directory
Navigate
