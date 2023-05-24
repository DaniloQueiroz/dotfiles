#!/bin/bash

# pw-cli ls | grep "node.name"
AUDIO_DEVICE=alsa_output.usb-VIA_Technologies_Inc._USB_Audio_Device-00.analog-stereo
NOTIFICATION_SOUND=~/.local/share/toggl/notification.wav

RESULT=$($HOME/bin/toggl get --short)
if [ $? -eq 0 ]; then
    echo $RESULT
    echo $RESULT | grep -e ":00" -e ":30"
    if [ $? -eq 0 ]; then
        notify-send -u critical -a toggl "Task in progress" "$RESULT"
        pw-play --target="$AUDIO_DEVICE" $NOTIFICATION_SOUND
    fi
else
    echo "Error getting current task"
    exit 1
fi
