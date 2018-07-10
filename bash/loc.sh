#!/bin/bash

ErrTrap(){
  if [[ $? -ne 0 ]];then
    echo "$func has failed"
  fi
 }

#TR(){
#  echo -e "${FUNCNAME[*]}" | cut -c 4- | head -c-5
#  echo "" 
# }

Exa(){
  curl -s htihio 2>/dev/null
  ErrTrap
 # TR
}

Cat(){
  date
  #TR
 }

Exa
Cat
