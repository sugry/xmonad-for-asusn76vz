#!/usr/bin/bash

while :
do
if `ping -c 1 -w 5 8.8.8.8 &> /dev/null`
  then SLEEP_INTERVAL=1h
  pac=`checkupdates | wc -l`
  [ $pac != 0 ] && pac="$pac pkg" || pac=
  echo "$pac" > /tmp/.getpkg-pipe
  else SLEEP_INTERVAL=1m
fi
sleep $SLEEP_INTERVAL
done
