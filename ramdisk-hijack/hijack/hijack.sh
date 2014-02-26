#!/tmp/ash

export PATH=/tmp:$PATH

LED_RED="/sys/class/leds/LED1_R/brightness"
LED_RED_CURRENT="/sys/class/leds/LED1_R/led_current"
LED_BLUE="/sys/class/leds/LED1_B/brightness"
LED_BLUE_CURRENT="/sys/class/leds/LED1_B/led_current"
LED_GREEN="/sys/class/leds/LED1_G/brightness"
LED_GREEN_CURRENT="/sys/class/leds/LED1_G/led_current"

clean_root () {
	mount -o remount,rw /
	cd /
# Stop services

	for SVCRUNNING in $(getprop | ${GREP} -E '^\[init\.svc\..*\]: \[running\]')
	do
		SVCNAME=$(${EXPR} ${SVCRUNNING} : '\[init\.svc\.\(.*\)\]:.*')
		stop ${SVCNAME}
	done

	for RUNNINGPRC in $(ps | grep /system/bin | grep -v grep | grep -v chargemon | awk '{print $1}' ) 
	do
		kill -9 $RUNNINGPRC
	done

	for RUNNINGPRC in $(ps | grep /sbin/ | grep -v grep | awk '{print $1}' )
	do
		kill -9 $RUNNINGPRC
	done

# umount
	umount /storage/emulated/legacy/Android/obb
	umount /storage/emulated/legacy
	umount /storage/emulated/0/Android/obb
	umount /storage/emulated/0
	umount /storage/removable/sdcard1
	umount /storage/emulated/legacy
	umount /mnt/shell/emulated
	umount /storage/emulated
	umount /lta-label
	umount /mnt/idd
	umount /cache
	umount /data
	umount /system

	umount /mnt/obb
	umount /mnt/asec
	umount /mnt/secure
	umount /acct

	rm sdcard etc init* uevent* default*
}

# Trigger short vibration
echo '200' > /sys/class/timed_output/vibrator/enable
# Show blue led
echo '255' > $LED_BLUE
echo '255' > $LED_BLUE_CURRENT
echo '0' > $LED_GREEN
echo '0' > $LED_GREEN_CURRENT
echo '0' > $LED_RED
echo '0' > $LED_RED_CURRENT

for EVENTDEV in $(ls /dev/input/event*)
do
	SUFFIX="$(expr ${EVENTDEV} : '/dev/input/event\(.*\)')"
	cat ${EVENTDEV} > /tmp/keyevent${SUFFIX} &
done

sleep 3

for CATPROC in $(ps | grep cat | grep -v grep | awk '{print $1;}')
do
	kill -9 ${CATPROC}
done

# turn off leds
echo '0' > $LED_BLUE
echo '0' > $LED_BLUE_CURRENT
echo '0' > $LED_GREEN
echo '0' > $LED_GREEN_CURRENT
echo '0' > $LED_RED
echo '0' > $LED_RED_CURRENT

sleep 1

hexdump /tmp/keyevent* | grep -e '^.* 0001 0072 .... ....$' > /tmp/keycheck

# vol+/-, boot recovery
if [ -s /tmp/keycheck -o -e /cache/recovery/boot ]
then

	# Show blue led
	echo '0' > $LED_BLUE
	echo '0' > $LED_BLUE_CURRENT
	echo '255' > $LED_GREEN
	echo '255' > $LED_GREEN_CURRENT
	echo '0' > $LED_RED
	echo '0' > $LED_RED_CURRENT

	rm /cache/recovery/boot
	clean_root
	cd /
	tar xf /tmp/recovery.tar
	sleep 1

	# turn off leds
	echo '0' > $LED_BLUE
	echo '0' > $LED_BLUE_CURRENT
	echo '0' > $LED_GREEN
	echo '0' > $LED_GREEN_CURRENT
	echo '0' > $LED_RED
	echo '0' > $LED_RED_CURRENT

	/tmp/2nd-init
	sleep 5
else
	clean_root
	cd /
	tar xf /tmp/jelly.tar
	sleep 1
	/tmp/2nd-init
	sleep 5
fi
	
