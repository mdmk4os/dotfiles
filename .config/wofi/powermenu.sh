#!/bin/bash

# options to be displayed
option0="lock"
option1="logout"
option2="suspend"
option3="scheduled suspend (10min)"
option4="scheduled suspend (20min)"
option5="scheduled suspend (30min)"
option6="reboot"
option7="shutdown"

# options passed into variable
options="$option0\n$option1\n$option2\n$option3\n$option4\n$option5\n$option6\n$option7"

chosen="$(echo -e "$options" | wofi --lines 8 --dmenuJ)"
case $chosen in
    $option0)
        swaymsg "hi this is a 1 option";;
    $option1)
        swaymsg "hi this is a 2 option";;
    $option2)
        swaymsg "hi this is a 3 option";;
	$option3)
		swaymsg "hi this is a 5 option";;
	$option4)
		swaymsg "hi this is a 6 option";;
	$option5)
		swaymsg "hi this is a 7 option";;
    $option6)
        systemctl reboot;;
	$option7)
        systemctl poweroff;;
esac