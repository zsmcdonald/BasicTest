#!/bin/bash

VersionCheck() {
  while true;do
	read -p "Enter the version number you would like to pull: " version
	if [[ $version == *.*.* ]] && [[ $version =~ ^[0-9]+(\.[0-9]+)+(\.[0-9]+)?$ ]];then
		break
	fi
  done
 }


#BP=https://github.com/AquaQAnalytics/TorQ.git
#FSP=https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git

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
  BP=https://github.com/AquaQAnalytics/TorQ.git
  FSP=https://github.com/AquaQAnalytics/TorQ-Finance-Starter-Pack.git
  base=`pwd`/$newdir
  cd $base
  git clone $BP
  git clone $FSP
  cd `pwd`/TorQ-Finance-Starter-Pack
  git checkout v$version
  cd $base
  mkdir deploy
  cp -R `pwd`/TorQ/* deploy/
  cp -R `pwd`/TorQ-Finance-Starter-Pack/* deploy/
 }




VersionCheck
Directory
Navigate
