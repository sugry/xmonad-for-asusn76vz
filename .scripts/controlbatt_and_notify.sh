#!/bin/sh

# author http://welinux.ru/post/1294/

# Sleep 1 minute

SLEEP_INTERVAL=60

while :; do
	# процент заряда
	BATT_PERCENT="$(acpi -b | awk "{print $1}" | sed 's/\([^:]*\): \([^,]*\), \([0-9]*\)%.*/\3/')"
	# статус - заряжается/разряжается
	BATT_STATUS="$(acpi -b | awk "{print $1}" | sed 's/\([^:]*\): \([^,]*\), \([0-9]*\)%.*/\2/')"

	S2='Discharging'
    S3='Full'
#	для отладки
#	echo $BATT_STATUS
#	echo $S2

	if [ $BATT_STATUS == $S2 ];
        then
        SLEEP_INTERVAL=60;
        	if [ $BATT_PERCENT -le "10" ];
 				# при 12 - 5% бук выключается, поэтому пора падать в ждущий режим
				then

				notify-send -u critical -i \
				/home/s-adm/.scripts/icon/battery-empty.png \
				"В Н И М А Н И Е !"  "Критический разряд батареи! Осталось всего ${BATT_PERCENT} % \
				Включите зарядное устройство иначе через 30 секунд компьютер перейдет в ждущий режим!";
				# даем 30 секунд времени на подключение зарядки
				sleep 30;
				# еще раз проверяем статус - не включилась ли зарядка
				WHATBATT="$(acpi -b | awk "{print $1}" | sed 's/\([^:]*\): \([^,]*\), \([0-9]*\)%.*/\2/')"
					# если не включилась - уходим в ждущий режим, иначе не уходим
					if [ $WHATBATT == $S2 ];
        				then
							systemctl suspend

					fi
				# собщения о низком заряде
				elif [ $BATT_PERCENT -le "15" ]; then

 				notify-send -u normal -t 10000 -i \
				/home/s-adm/.scripts/icon/battery-caution.png \
				"СОСТОЯНИЕ БАТАРЕИ"  "Низкий заряд батареи! Осталось всего ${BATT_PERCENT} % \
				Включите зарядное устройство!";
				# короткие напоминания заранее (можно и не делать)
				elif [ $BATT_PERCENT -le "30" ]; then

 				notify-send -u normal -t 5000 -i \
				/home/s-adm/.scripts/icon/battery-low.png \
				"СОСТОЯНИЕ БАТАРЕИ"  "Система работает при низком заряде батареи. Осталось ${BATT_PERCENT} % ";
				# будем напоминать не так часто, добавим паузу
				sleep 180;
			fi


	else
		# если заряжается и дошло до 98% (больше обычно не поднимается) сообщим о полном заряде
		#if [ "98" -le $BATT_PERCENT ];
        if [ $BATT_STATUS == $S3 ];
			then

				notify-send -u normal -t 5000 -i \
				/home/s-adm/.scripts/icon/battery-full-charging.png \
				"СОСТОЯНИЕ БАТАРЕИ"  "Батарея полностью заряжена. Для увеличения срока службы батарею рекомендуется отключить от зарядного устройства";
				# будем напоминать каждые 15 минут пока не выключат зарядку
				SLEEP_INTERVAL=450;
				sleep $SLEEP_INTERVAL
		fi
#	для отладки
#	echo "Батарея " $BATT_STATUS $BATT_PERCENT
    fi

 	sleep $SLEEP_INTERVAL

done
