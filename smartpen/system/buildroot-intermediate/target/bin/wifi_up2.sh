#!/bin/sh
rfkill unblock wifi
ifconfig wlan0 up
ifconfig lo up

#wpa_supplicant -B -i wlan0 -c ${env_wifi_wpa_supplicant_conf} &
#wpa_supplicant -i wlan0 -c ${env_wifi_wpa_supplicant_conf} &
#udhcpc -i wlan0 &
setprop ctl.start wpa
setprop ctl.start udhcpc


