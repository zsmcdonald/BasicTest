#!/bin/bash


####Format should appear as below####
#check process $procname
#    matching \"$KDBSTACKID -proctype $proctype -procname $procname\"
#    start program = \"/bin/bash $startscript $procname\"
#        with timeout 10 seconds
#    stop program = \"/bin/bash $stopscript $procname\"
#    every \"* * * * *\"
#    mode active
####-----------------------------####

torqscript=torq.sh

tail -n +2 process.csv | awk -v awktorq=$torqscript -F "\"*,\"*" '{print  "check process "$4"\n    matching \"$KDBSTACKID -proctype "$3 " -procname " $4"\"" "\n    start program = \\\"/bin/bash " awktorq " start " $4 "\n        with timeout 10 seconds\n    stop program = \\\"/bin/bash " awktorq " stop " $4 "\n        with timeout 10 seconds\n    every  \\\"* * * * *\\\"\n    mode active\n"}'


#tail -n +2 process.csv | awk -F "\"*,\"*" '{print  "check process "$4"\n    matching \"$KDBSTACKID -proctype "$3 " -procname " $4"\"""\n        with timeout 10 seconds\n    stop program = \\\"/bin/bash" $stopscript}'

