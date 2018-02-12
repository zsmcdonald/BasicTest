#!/bin/bash

datef=`date +%D | tr "/" "-"`
if [ ! -d *v1.0* ];then
  mkdir v1.0.$datef 
  echo "v1.0 directory created as it does not exist"
  else
  prevnum=`find -type d | sort | sed '$!d' | cut -c 4- | head -c-10`;
  newnum=`echo "$prevnum + 0.1" | bc`
  mkdir v$newnum.$datef 
  echo "New directory created with incremented version number"
fi

