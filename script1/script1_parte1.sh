#!/bin/bash

./script1_parte2.sh "$@" > /tmp/script1_output.txt

if [[ "$(wc -l < "/tmp/script1_output.txt")" -gt "$(tput lines)" ]]; then
        less /tmp/script1_output.txt
else
        cat /tmp/script1_output.txt
fi

rm -f /tmp/script1_output.txt

