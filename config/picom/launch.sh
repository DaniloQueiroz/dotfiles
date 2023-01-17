#!/usr/bin/env bash

PICOM_DIR=$(dirname "$0")

# Terminate already running instances
killall -q picom
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done

# Launch picom
DISPLAY=":0" picom --config ${PICOM_DIR}/picom.conf --daemon
