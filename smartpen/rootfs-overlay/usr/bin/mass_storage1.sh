#!/bin/sh

mount_dev()
{
	buf=`mount|grep "$dev_file on $obj_dir"`
	if [ -z "$buf" ]
	then
		mkdir -p $obj_dir
		count=5
		while [ $count -gt 0 ]
		do
			mount $dev_file $obj_dir
			if [ $? -eq 0 ]; then
				break
			fi
			count=$((count - 1))
		done
		if [ $count -eq 0 ]
		then
			echo "notice : mount $dev_file failed!!!"
			exit 1
		fi
	fi
}

init_func()
{
	if [ ! -e $dev_file ]
	then
		echo "notice : $dev_file don't exit, please config kernel !!!"
		exit 1
	fi

	if [ ! -d $obj_dir ]
	then
		echo "notice : $obj_dir don't exit, please create it!!!"
		exit 1
	fi

	buf=`mount|grep "$dev_file"`
	# echo "1-------->$buf"
	[ ! -z "$buf" ] && {
	echo "notice : $dev_file have been mounted!!!"
	exit 1
}
}

dev_file=/dev/mmcblk0p4
obj_dir=/tmp/mass_storage
main()
{
    echo "start mass_storage"
    mkdir /tmp/mass_storage

    while [ 1 ]
    do
	umount $dev_file
	if [ $? -eq 0 ]; then
	    break
	fi
	echo "umount $dev_file failed"
	sleep 1
    done

    init_func
    mount_dev
    echo $dev_file > /sys/class/android_usb/f_mass_storage/lun0/file
}

main
