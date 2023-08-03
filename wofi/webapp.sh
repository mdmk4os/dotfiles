#!/bin/bash

#options to be displayed
option0="Notion"
option1="Instagram"

#passed into variable
options="$option0\n$option1"

#make a menu
chosen="$(echo -e "$options" | wofi --lines 2 --dmenu)"
case $chosen in
    $option0)
        chromium --ozone-platform-hint=wayland --app=https://notion.so/mdmk4os/;;
    $option1)
        chromium --ozone-platform-hint=wayland --app=https://instagram.com/;;
esac