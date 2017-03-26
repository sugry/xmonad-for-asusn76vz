#!/bin/sh
urxvtc -name update -e yaourt -Syua &&
while `pgrep yaourt >/dev/null`
do
    sleep 1
done

pac=`checkupdates | wc -l`
[ $pac != 0 ] && pac="$pac pkg" || pac=
echo "$pac" > /tmp/.getpkg-pipe

exit 0
