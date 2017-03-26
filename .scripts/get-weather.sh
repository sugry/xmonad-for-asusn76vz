#!/usr/bin/bash

echo >> /tmp/.weather-pipe
SLEEP_INTERVAL=60
# Search for your city at http://www.accuweather.com and replace the URL in the following script with the URL for your city:
URL='http://www.accuweather.com/ru/ru/surgut/288459/current-weather/288459'

while :
do
if `ping -c 1 -w 5 8.8.8.8 &> /dev/null`
then
    SLEEP_INTERVAL=600
                
    CURWEATH="$(wget -q -O- "$URL" | awk -F\' '/acm_RecentLocationsCarousel\.push/{print $10"°", $13}'| head -1 | sed 's/,  text:"//g' | rev | cut -c 5- | rev | sed 's/.*/\L&/')"
        
    echo $CURWEATH  | sed 's/ясно//g' | sed 's/солнечно//g' | sed 's/слабый туман//g' | sed 's/слабый снег и туман/ /g' | sed 's/слабый снегопад//g' | sed 's/небольшой снег//g' | sed 's/снегопад//g' | sed 's/снег//g' | sed 's/значительная облачность//g' | sed 's/облачно с прояснениями//g' | sed 's/малооблачно//g' | sed 's/облачно//g' | sed 's/метель//g' >> /tmp/.weather-pipe
    echo $CURWEATH >> /home/s-adm/.scripts/weatmp 
    else SLEEP_INTERVAL=60
fi
    sleep $SLEEP_INTERVAL
done
