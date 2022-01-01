#!/bin/bash
mkdir -p /home/pi/coderbot/firmware
wget -nc https://raw.githubusercontent.com/CoderBotOrg/firmware/master/bin/upload.sh -O /home/pi/coderbot/firmware/upload.sh
wget -nc https://raw.githubusercontent.com/CoderBotOrg/firmware/master/dist/atmega.hex -O /home/pi/coderbot/firmware/atmega.hex
