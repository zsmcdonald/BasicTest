#!/bin/bash

datef=`date +%D | tr "/" "-"`
prevnum=`find -type d | sort | sed '$!d' | cut -c 4- | head -c-10` 
newnum=`echo "$prevnum + 0.1" | bc`
mkdir v$newnum.$datef




