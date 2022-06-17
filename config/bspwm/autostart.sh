#!/bin/bash

xrandr --output HDMI1 --auto --output HDMI2 --left-of HDMI1 --rotate right --auto

pgrep -x sxhkd > /dev/null || sxhkd -c $HOME/.config/bspwm/sxhkdrc &
pgrep -x polybar > /dev/null || polybar -c $HOME/.config/bspwm/polybar main &
pgrep -x picom > /dev/null || picom --config $HOME/.config/bspwm/picom.conf &
nitrogen --set-scaled --random ~/.config/wallpapers/
pgrep --full -x "dude session" > /dev/null || dude session &
