#!/bin/bash

echo "Type your password"
a='';
while read -n 1 -s c; do
        [ "$c" = '' ] && break;

        if [ "$c" = $'\x7f' ]; then
                [ "$a" != "" ] && { a=${a:0:-1};
                printf "\b \b"; };

        else
                echo -n '*'; a="$a$c";

        fi;
done;
