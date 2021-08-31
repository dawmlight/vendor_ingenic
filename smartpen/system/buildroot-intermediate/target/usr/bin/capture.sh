#!/bin/sh

DATAPATH=/tmp/camera-data-128x96-y
rm -fr $DATAPATH
mkdir -p $DATAPATH

echo "Press capture key to start camera recoreding..."
echo "$DATAPATH"
echo

COUNT=0

echo 75 > /sys/class/gpio/export
echo 76 > /sys/class/gpio/export

### turn off led
echo low > /sys/devices/platform/apb/10010000.pinctrl/gpio/gpio76/direction

button=1
button_old=$button
while true
do
	button=$(cat /sys/devices/platform/apb/10010000.pinctrl/gpio/gpio75/value)
	if [ $button -ne $button_old ] ;then
		button_old=$button	
		if [ $button -eq 0 ] ;then
		    let COUNT++
			printf 0
			echo high > /sys/devices/platform/apb/10010000.pinctrl/gpio/gpio76/direction
			echo
			echo $DATAPATH/$COUNT
			echo
			v4l2-ctl -v width=128,height=96,pixelformat="GREY" --stream-mmap=3 --stream-to=$DATAPATH/$COUNT -d /dev/video3 &
#			v4l2-ctl -v width=320,height=240,pixelformat="NV12" --stream-mmap=3 -d /dev/video3 &
		else
			echo
			printf 1
			killall v4l2-ctl
			echo low > /sys/devices/platform/apb/10010000.pinctrl/gpio/gpio76/direction
			echo ""
			echo "capture DONE!!!"
			echo ""
		fi
	fi

	sleep 0.2
done

