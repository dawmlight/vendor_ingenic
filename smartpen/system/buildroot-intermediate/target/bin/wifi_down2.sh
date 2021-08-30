#!/bin/sh
#killall -9 udhcpc
#killall -9 wpa_supplicant
#ifconfig wlan0 0.0.0.0
#ifconfig wlan0 down
setprop ctl.stop udhcpc
#killall -9 udhcpc
#setprop ctl.stop wpa
ifconfig wlan0 0.0.0.0
ifconfig wlan0 down
rfkill block wifi
