#!/bin/sh

echo "remount /storage"
touch /storage/test_mount
if [ $? -ne 0 ]
then
    echo "mount /dev/mmcblk0p4  /data"
    echo "" > /sys/class/android_usb/f_mass_storage/lun0/file
    umount /dev/mmcblk0p4
    /bin/mount -t vfat /dev/mmcblk0p4 /storage
    # mount /dev/mmcblk0p3 /usr/boa/webapps/GlassData/photos 
    # mount /dev/mmcblk0p3 /usr/boa/webapps/GlassData/videos 
    # mount /dev/mmcblk0p3 /usr/boa/webapps/GlassData/.thumbnails
    # rm -r /tmp/mass_storage
else
    rm  /storage/test_mount
fi
