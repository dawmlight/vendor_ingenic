#!/bin/sh
case "$1" in
	start)
		echo "/storage/program install..."
		if [ -d "/storage/program" ]; then
			for file in /storage/program/*;do
				if [ -d "$file" ]; then
					if [ -f "$file/updatepackage/install.sh" ]; then
						cd $file/updatepackage;./install.sh;cd -
					fi
				fi
			done
		fi
		;;
	stop)
		if [ -d "/storage/program" ]; then
			for file in /storage/program/*;do
				if [ -d "$file" ]; then
					if [ -f "$file/updatepackage/uninstall.sh" ]; then
						cd $file/updatepackage;./uninstall.sh;cd -
					fi
				fi
			done
		fi
		;;
	restart|reload)
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		;;
esac

exit $?
