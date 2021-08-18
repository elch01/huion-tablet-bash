#!/bin/bash

# this is my personal script, modify it to suit your system/needs!

OUTPUT=$(echo "$INITIAL" | grep -Eo "id=.." | tr -d 'id=')

OUTPUT2=$(echo "$INITIAL2" | grep -Eo "id=.." | tr -d 'id=')

xrandr

echo -e '\e[93mLook up the port that your tablet is using and write it down!\e[0m'

read input

xinput map-to-output $OUTPUT $input

xsetwacom --set $OUTPUT2 Button 3 "key +F12"
xsetwacom --set $OUTPUT2 Button 8 "key +F11"
