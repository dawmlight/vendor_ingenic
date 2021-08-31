#!/bin/sh
#
# Start init
#
wpaFile=/etc/wpa_supplicant.conf
btfileok=/var/run/bt-daemon-socket
case "$1" in
  start)
	echo "Starting bt init...."
	servicemanager &
	sleep 1
	mediaserver&
	sleep 1
	bsa_server_mips -all=0 -r 14 -d /dev/ttyS0 -u /var/run/ -p /firmware/BCM43438A1.hcd&
	sleep 1

	wpa_supplicant -Dnl80211 -iwlan0 -c$wpaFile &
	udhcpc -i wlan0 -x hostname:mypian-X2000 &


	#while true
	#do
		if [ -f $btfileok ]
		then
			echo "bt has been started!"
			Wireless &
			break
		else
			echo "bt has not been started"
		fi
	#	sleep 5
	#done

	#sleep 10

	echo "Starting init: done"
	;;
  stop)
	echo -n "Stopping init....."
	killall WireLess
	;;
  restart|reload)
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
