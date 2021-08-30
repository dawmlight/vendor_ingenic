#!/bin/sh
 
PROCESS=`ps -ef|grep alsaloop|grep -v grep|grep -v PPID|awk '{ print $1}'`
for i in $PROCESS
do
  echo "Kill the alsaloop process [ $i ]"
  kill -9 $i
done
