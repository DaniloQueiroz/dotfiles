#!/bin/bash

xrandr --output HDMI-0 --auto --output DP-4 --auto --rotate left --left-of HDMI-0 --output DP-3 --off
#xrandr --output DP-0 --auto --output DP-3 --off --output HDMI-0 --rotate left --left-of DP-0 --auto

#
pgrep -x sxhkd > /dev/null || sxhkd -c $HOME/.config/bspwm/sxhkdrc &
pgrep -x polybar > /dev/null || polybar -c $HOME/.config/bspwm/polybar main &
pgrep -x picom > /dev/null || picom --config $HOME/.config/bspwm/picom.conf &
pgrep --full -x "dude session" > /dev/null || dude session &
