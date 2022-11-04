#!/bin/bash
#
# Make any app a scratchpad app
# use `xprop` to find out the class of a given app
#

if [ $# -lt 2 ]; then
    echo "Usage: $0 <application> <application class>"
    exit 1
fi

app=$1
app_class=$2

echo app=$app
echo class=$app_class


function window_props() {
    w_pid=$1
    current_desktop=$(bspc query -D -d focused)
    bspc node $w_pid --to-desktop $current_desktop
    bspc node $w_pid -t floating
    bspc node $w_pid --focus
}


pids=$(xdotool search --class "$app_class")
if [ -z "$pids" ]; then
    $app &
    sleep 10s
    pids=$(xdotool search --class $tracker_class)
    for pid in $pids; do
        window_props $pid
    done
else
    for pid in $pids; do
        window_props $pid
        bspc node $pid --flag hidden -f
    done
fi

