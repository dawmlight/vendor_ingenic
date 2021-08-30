#!/bin/sh
usbconfig() {
	if [ x`cat /sys/kernel/config/usb_gadget/demo/UDC` == x ];then
		bluemac=$(cat /sys/class/net/wlan0/baddr | sed 's/[^0-9|a-z]//g')
		serialname="MagicPen-"${bluemac:6}
		#serialname=`/usr/bin/getprop sys.usb.serialnumber`
		mkdir -p /sys/kernel/config/usb_gadget/demo/strings/0x409
		echo 0x18d1 > /sys/kernel/config/usb_gadget/demo/idVendor
		echo 0xd002 > /sys/kernel/config/usb_gadget/demo/idProduct
		echo 0x200  > /sys/kernel/config/usb_gadget/demo/bcdUSB
		echo 0x100  > /sys/kernel/config/usb_gadget/demo/bcdDevice
		echo ingenic > /sys/kernel/config/usb_gadget/demo/strings/0x409/manufacturer
		echo smartpen > /sys/kernel/config/usb_gadget/demo/strings/0x409/product
		echo $serialname > /sys/kernel/config/usb_gadget/demo/strings/0x409/serialnumber
		mkdir -p /sys/kernel/config/usb_gadget/demo/configs/c.1/strings/0x409
		echo 120 > /sys/kernel/config/usb_gadget/demo/configs/c.1/MaxPower
        config=$(getprop user.usb.config)
        if [ $config == "adb" ];then
			echo "adb+mtp" > /sys/kernel/config/usb_gadget/demo/configs/c.1/strings/0x409/configuration
        	mkdir -p /sys/kernel/config/usb_gadget/demo/functions/ffs.adb
        	ln -s /sys/kernel/config/usb_gadget/demo/functions/ffs.adb /sys/kernel/config/usb_gadget/demo/configs/c.1/
        	mkdir -p /sys/kernel/config/usb_gadget/demo/functions/mtp.gs0
        	ln -s /sys/kernel/config/usb_gadget/demo/functions/mtp.gs0 /sys/kernel/config/usb_gadget/demo/configs/c.1/
        	mkdir -p /dev/usb-ffs/adb
        	mount -t functionfs adb /dev/usb-ffs/adb
	        setprop sys.usb.state adb
        elif [ $config == "mtp" ];then
			echo "mtp" > /sys/kernel/config/usb_gadget/demo/configs/c.1/strings/0x409/configuration
        	#clean adb set----
        	setprop ctl.stop adbd
        	rm -rf /sys/kernel/config/usb_gadget/demo/configs/c.1/ffs.adb
        	rm -rf sys/kernel/config/usb_gadget/demo/functions/ffs.adb
        	umount /dev/usb-ffs/adb
        	#clean adb set done----
        	mkdir -p /sys/kernel/config/usb_gadget/demo/functions/mtp.gs0
        	ln -s /sys/kernel/config/usb_gadget/demo/functions/mtp.gs0 /sys/kernel/config/usb_gadget/demo/configs/c.1/
        	setprop sys.usb.state mtp
        fi
	fi

}
udcstart(){
	let overtimer=10
	while [ x`cat /sys/kernel/config/usb_gadget/demo/UDC` == x ]; do
		echo 13500000.otg > /sys/kernel/config/usb_gadget/demo/UDC
		sleep 1
		let overtime=overtime-1
		if [ $overtime -eq 0 ];then
			echo "UDC connnect failed.----------------"
			break
		fi
	done
}
udcstop(){
    setprop sys.usb.state none
    if [ x`cat /sys/kernel/config/usb_gadget/demo/UDC` != x ];then	
    usleep 10000
    echo none > /sys/kernel/config/usb_gadget/demo/UDC
	let overtimer=10
	while [ x`cat /sys/kernel/config/usb_gadget/demo/UDC` != x ]; do
		echo none > /sys/kernel/config/usb_gadget/demo/UDC
		sleep 1
		let overtime=overtime-1
		if [ $overtime -eq 0 ];then
			echo "UDC disconnnect failed.----------------"
			break
		fi
	done
    sleep 1	
    setprop ctl.stop adbd
    #setprop ctl.stop mtp
    rm -rf /sys/kernel/config/usb_gadget/demo/configs/c.1/ffs.adb
    rm -rf sys/kernel/config/usb_gadget/demo/functions/ffs.adb
    sleep 1
    umount /dev/usb-ffs/adb
    #rm -rf /sys/kernel/config/usb_gadget/demo/configs/c.1/mtp.gs0
    #rm -rf /sys/kernel/config/usb_gadget/demo/functions/mtp.gs0
    fi
}

case "$1" in
	restart)
        setprop usb.config.state busy
		udcstop
		usbconfig
		sleep 1
		udcstart
        setprop usb.config.state free
		;;
	start)
        #setprop usb.config.state busy
		usbconfig
		#setprop sys.usb.state adb
		sleep 1
		udcstart
        #setprop usb.config.state free
		;;
	stop)
		udcstart
		;;
	*)
		;;
esac
