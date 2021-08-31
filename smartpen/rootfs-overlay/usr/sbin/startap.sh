#!/bin/sh

# hostapd config file
AP_CONF=/tmp/hostapd.conf

encrypt=no # default value
while getopts ":i:s:p:a:" optname
do
    case "$optname" in
    "i")
        INTERFACE=$OPTARG
        ;;
    "s")
        ssid=$OPTARG
        ;;
    "p")
        passwd=$OPTARG
        encrypt=yes
        ;;
    "a")
        ip=$OPTARG
        ;;
    "?")
        echo "Unknown option $OPTARG"
        ;;
    ":")
        echo "No argument value for option $OPTARG"
        ;;
    *)
        # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
done

if [ x$INTERFACE = x ]; then
    echo "Usage: startap.sh -i <ifname> -s [ssid] -p [psk]"
    exit
fi
if [ x$ssid = x ]; then
    MACID=`ifconfig $INTERFACE | grep HWaddr | tr -s ' ' | cut -d' ' -f5 | \
        tr -d : | cut -c5-12 | tr A-Z a-z`

    ssid=`hostname`-$MACID
fi
if [ x$ip = x ]; then
    ip="192.168.1.1"
fi

(>&2 echo "interface: "$INTERFACE" ,ssid: "$ssid" ,passwd: "$passwd" ,ip: "$ip)

# stop already exist process
kiiall udhcpd > /dev/null 2>&1
ps -o pid,args | grep -v grep | grep udhcpc | grep "\-i$INTERFACE" | awk '{print $1}' > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep udhcpc | grep "\-i$INTERFACE" | awk '{print $1}') > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep wpa_supplicant | grep "\-i$INTERFACE" | awk '{print $1}') > /dev/null 2>&1
kill $(ps -o pid,args | grep -v grep | grep hostapd | grep "\-i$INTERFACE" | awk '{print $1}') > /dev/null 2>&1

# guess what wifi model we are using(light detect, may not match!!!)
DRIVER=nl80211

if [ -d /proc/net/rtl* ]; then
    rfkill unblock wifi
fi

# get a lucky channel, ^_^.
while [ "$CHANNEL" == "0" -o "$CHANNEL" == "" ]; do
    CHANNEL=`expr $RANDOM % 12`
done

# delete default Gateway
route del default gw 0.0.0.0 dev $INTERFACE  > /dev/null 2>&1
# release ip address and turn up wifi interface
ifconfig $INTERFACE 0.0.0.0 up

r_ssid=$ssid

# make a complete hostap config file
cat > $AP_CONF << EOF
# basic setting
ctrl_interface=/var/run/hostapd
interface=$INTERFACE
driver=$DRIVER
channel=$CHANNEL
hw_mode=g
ssid=$r_ssid

EOF

if [ xx$encrypt == xxyes ]; then
cat >> $AP_CONF << EOF
# wpa or wpa2
auth_algs=3
wpa=3
wpa_passphrase=$passwd
wpa_key_mgmt=WPA-PSK

# encrypt method, Required!!!
# refer to:
# http://en.wikipedia.org/wiki/Wi-Fi_Protected_Access#Encryption_protocol
# wpa
rsn_pairwise=CCMP
# wpa encrypt method2
wpa_pairwise=CCMP

EOF
fi

killall dnsmasq > /dev/null 2>&1
ip_start=$(echo $ip | sed "s/.1$/.2/")
ip_end=$(echo $ip | sed "s/.1$/.254/")
echo "dhcp-range=${ip_start},${ip_end},12h" > /tmp/dnsmasq.conf
dnsmasq -C /tmp/dnsmasq.conf
hostapd -i$INTERFACE $AP_CONF -B
ifconfig $INTERFACE $ip
route add default gw $ip
# Add Multicast Router for Apple Airplay
route add -net 224.0.0.0 netmask 224.0.0.0 $INTERFACE

exit 0
