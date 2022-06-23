#!/bin/bash

#FileName="noa-eden-station2_1_1_1_9_20220623173733.bin"

FileName="Test"

paths=$(find /sys/bus/usb/devices/usb*/ -name dev)

port_counter=0



find_port(){
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

            echo "$espPort"

        )
    done 
}

port="$(find_port)"
count="$(echo "$port" | wc -w)"


if [[ $count -gt 1 ]]; then
    echo "More than one ESP32 found at ports: "  "$port"
    exit 1
elif [[ $count -eq 0 ]]; then
    echo "No ESP32's found. Try rebooting the system?"
    exit 1
elif [[ $count -eq 1 ]]; then
    echo "One ESP32 found at ports: " "$port"
fi

python3 -m esptool --chip esp32 --port "$port" --baud 460800 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x10000 "$FileName"

