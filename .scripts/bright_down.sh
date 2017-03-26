#!/bin/sh
#
# Script to change brightness in Bodhi 12.04 for laptops which don't respond
# to hardware keys
# Needs to have write permissions chmod a+w /sys/class/backlight/intel_backlight/brightness
# 16.03.2017

BRIGHT_INCREMENT=200
MIN_BRIGHT=1

read CURRENT_BRIGHT < /sys/class/backlight/intel_backlight/brightness

CURRENT_BRIGHT=`expr $CURRENT_BRIGHT - $BRIGHT_INCREMENT`

if [ $CURRENT_BRIGHT -ge $MIN_BRIGHT ]
then
    echo $CURRENT_BRIGHT > /sys/class/backlight/intel_backlight/brightness
else
    echo 100 > /sys/class/backlight/intel_backlight/brightness
fi
