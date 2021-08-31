#!/bin/sh
 
PROCESS=`ps -ef|grep alsaloop|grep -v grep|grep -v PPID|awk '{ print $1}'`
for i in $PROCESS
do
  echo "Kill the alsaloop process [ $i ]"
  kill -9 $i
done
alsaloop -C default -P system -f S16_LE -c 2 -r 44100 -t 500000 &
