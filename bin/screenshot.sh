#!/bin/bash

TO_FILE=${1:-n}

if [ "$TO_FILE" == "y" ]; then
    maim -s ~/screenshot-$(date +%s).png
else
    maim -s | xclip -selection clipboard -t image/png
fi
