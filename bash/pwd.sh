#!/bin/bash

pa=${PWD}
echo "0 14 * * * $pa/pwd.sh $1" > ~/crontxt
crontab ~/crontxt
rm ~/crontxt
