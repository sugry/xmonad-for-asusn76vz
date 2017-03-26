#!/usr/bin/bash

if [[ -f /home/s-adm/.scripts/weatmp ]]
then cat /home/s-adm/.scripts/weatmp | sed 's/ясно//g' | sed 's/солнечно//g' | sed 's/слабый туман//g' | sed 's/слабый снег и туман/ /g' | sed 's/слабый снегопад//g' | sed 's/небольшой снег//g' | sed 's/снегопад//g' | sed 's/снег//g' | sed 's/значительная облачность//g' | sed 's/облачно с прояснениями//g' | sed 's/малооблачно//g' | sed 's/облачно//g' | sed 's/метель//g' >> /tmp/.weather-pipe > /tmp/.weather-pipe
fi
exit 0

