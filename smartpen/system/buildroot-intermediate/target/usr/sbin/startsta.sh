#!/bin/sh

DHCP=yes

if [ $# -eq 2 -a "$2" == "--without-dhcp" ]; then
    DHCP=no
    INTERFACE=$1
elif [ $# -eq 1 ]; then
    INTERFACE=$1
else
    echo "Usage: startap.sh <ifname> [--without-dhcp]"
    exit
fi

# stop already exist process
kiiall udhcpd > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep udhcpc | grep -i$INTERFACE | awk '{print $1}') > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep wpa_supplicant | grep -i$INTERFACE | awk '{print $1}') > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep hostapd | grep -i$INTERFACE | awk '{print $1}') > /dev/null 2>&1

# wpa_supplicant config file
WPA_CONF=/tmp/wpa_supplicant_inuse.conf

# guess what wifi model we are using(light detect, may not match!!!)
DRIVER=nl80211

if [ -d /proc/net/rtl* ]; then
    rfkill unblock wifi
fi

# delete default Gateway
route del default gw 0.0.0.0 dev $INTERFACE
# release ip address and turn up wifi interface
ifconfig $INTERFACE 0.0.0.0 up

# start service
wpa_supplicant -D$DRIVER -i$INTERFACE -c$WPA_CONF -B

if [ "$DHCP" == "yes" ]; then
    udhcpc -i$INTERFACE -q
fi

# Add Multicast Router for Apple Airplay
# DHCP will reset Router, This can not work with udhcpc
route add -net 224.0.0.0 netmask 224.0.0.0 $INTERFACE

exit 0
