#!/bin/sh
if (pidof dunst >/dev/null); then kill $(pidof dunst)
else notify-send -t 0 -i /home/s-adm/.scripts/icon/surgut.png "    Погода в Сургуте    " "    $(tail -n 1 /home/s-adm/.scripts/weatmp)"
fi
exit 0




