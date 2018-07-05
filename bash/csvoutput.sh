#!/bin/bash

tail -n +2 process.csv | awk -F "\"*,\"*" '{print "The baseport is " $2 " which does something amazing.\n"}'
