#!/bin/sh
#
# Script to change brightness in Bodhi 12.04 for laptops which don't respond
# to hardware keys
# Needs to have write permissions chmod a+w /sys/class/backlight/intel_backlight/brightness
# 16.03.2017

BRIGHT_INCREMENT=200

MAX_BRIGHT=2927
read CURRENT_BRIGHT < /sys/class/backlight/intel_backlight/brightness

CURRENT_BRIGHT=`expr $CURRENT_BRIGHT + $BRIGHT_INCREMENT`

if [ $CURRENT_BRIGHT -le $MAX_BRIGHT ]
then
    echo $CURRENT_BRIGHT > /sys/class/backlight/intel_backlight/brightness
fi
