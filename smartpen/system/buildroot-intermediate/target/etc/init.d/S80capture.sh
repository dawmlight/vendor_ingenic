#!/bin/sh
#
# Start capture ....
#

exit
case "$1" in
  start)
	  echo "Starting capture ..."
	  /usr/bin/capture.sh &
	  ;;
  stop)
	;;
  restart|reload)
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
