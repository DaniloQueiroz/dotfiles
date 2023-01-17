#!/bin/bash

xrandr --output HDMI1 --mode 3440x1440 --output HDMI2 --left-of HDMI1 --rotate left --auto

pgrep -x sxhkd > /dev/null || sxhkd -c $HOME/.config/bspwm/sxhkdrc &
pgrep -x xss-lock > /dev/null || xss-lock xsecurelock &
nitrogen --set-scaled --random ~/.config/wallpapers/
$HOME/.config/polybar/launch.sh
$HOME/.config/picom/launch.sh