#!/bin/bash


function status() {
SCREEN_SAVER=$(xset q | grep -A2 "Screen Saver:" | grep timeout | awk '{ print $2 }')
    if [ ${SCREEN_SAVER} -eq 0 ]; then
        echo "screensaver: off"
     else
        echo "screensaver: on"
    fi
}

OP=${1:-status}

case $OP in
    status)
        status
        ;;
    on)
        xset s on
        xset +dpms
        ;;
    off)
        xset s off
        xset -dpms
        ;;
    *)
        echo "Unknown option. Try $0 [on|off|status]"
        exit 1
        ;;
esac
