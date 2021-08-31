#!/bin/sh
#echo $1x$2 > /sys/devices/platform/ahb0/13050000.dpu/layer$3/src_size
#echo $1x$2 > /sys/devices/platform/ahb0/13050000.dpu/layer$3/target_size
#if [ $# -gt 5 ] ; then
#    pos_x=$5
#    pos_y=$6
#    echo px=${pos_x},py=${pos_y}
#    echo ${pos_x}x${pos_y} > /sys/devices/platform/ahb0/13050000.dpu/layer$3/target_pos
#elif  [ $# -eq 5 ] ; then
#    pos_y=$5
#    echo px=106,py=${pos_y}
#    echo 106x${pos_y} > /sys/devices/platform/ahb0/13050000.dpu/layer$3/target_pos
#else
#    echo 106x0 > /sys/devices/platform/ahb0/13050000.dpu/layer$3/target_pos
#fi
#echo 0 > /sys/devices/platform/ahb0/13050000.dpu/layer$3/src_fmt
echo $4 > /sys/devices/platform/ahb0/13050000.dpu/layer$3/enable
echo 1 > /sys/devices/platform/ahb0/13050000.dpu/comp_update
