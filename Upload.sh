#!/bin/bash

set -e

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
        (( count++ ))
        if [[ $count -gt 1 ]]
        then
            echo "More than one ESP32 found. Is a Stand plugged in?"
            exit 1
        fi
    )
done 
echo "Done"

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

        echo "d found at " "$espPort"
        
    )
done 
echo "Done 2"