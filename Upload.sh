#!/bin/bash

declare -i count
shopt -s lastpipe # enable lastpipe

paths=$(find /sys/bus/usb/devices/usb*/ -name dev)

for sysdevpath in $paths; do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        #echo $devname
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        device="/dev/$devname - $ID_SERIAL" 

        #Look for serial converter matching stand by manufacturer
        ##Bus 001 Device 009: ID 1a86:55d4 QinHeng Electronics 
        espPort=$(echo "$device" | grep "1a86_USB_Single_Serial" | cut -d " " -f1)
        [[ -z "$espPort" ]] && exit

        echo "ESP found at " "$espPort"
        ((count++))
        echo "$count"
    )
done < < ()
shopt -u lastpipe # disable lastpipe
echo "count is " "$count"