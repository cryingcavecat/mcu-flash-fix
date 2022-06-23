#!/bin/bash
FileName="noa-eden-station2_1_1_1_9_20220623173733.bin"
Port=$1
echo "Using Port $1"
python3 -m esptool --chip esp32 --port "$1" --baud 460800 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x10000 "$FileName"
