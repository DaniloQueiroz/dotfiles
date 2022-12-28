#!/usr/bin/env bash

POLYBAR_DIR=$(dirname "$0")

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
coproc polybar -c ${POLYBAR_DIR}/config.ini main
coproc polybar -c ${POLYBAR_DIR}/config.ini secondary
