#!/bin/sh

# networking
ifconfig lo 127.0.0.1 up
rfkill unblock wifi > /dev/null 2>&1
# random: Not enough entropy pool available for secure operation
mv /dev/random /dev/random.orig
ln -s /dev/urandom /dev/random

# start network_manager
# network_manager -B
