#!/bin/sh
if (pidof orage >/dev/null); then kill $(pidof orage)
else orage --toggle
fi
exit 0
