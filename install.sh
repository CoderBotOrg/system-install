#!/bin/bash

apt-get install -y hostapd dnsmasq pigpio espeak gpac portaudio19-dev \
	           git python3-pip python3 python3-venv libopenjp2-7-dev \
		   libtiff5 libatlas-base-dev libhdf5-dev \
		   libhdf5-serial-dev python-gobject libharfbuzz-bin \
		   libwebp6 libjasper1 libilmbase12 libgstreamer1.0-0 \
		   libavcodec-extra57 libavformat57 libopencv-dev \
		   libqtgui4 libqt4-test omxplayer libhdf5-dev

mkdir /etc/coderbot

cp etc/hostname /etc/.
cp etc/hosts /etc/.
cp etc/init.d/* /etc/init.d/.
cp etc/hostapd/* /etc/hostapd/.
cp etc/dnsmasq.conf /etc/.
cp etc/coderbot/* /etc/coderbot/.
cp etc/modprobe.d/alsa-base.conf /etc/modprobe.d/.

su pi
./download_mobilenet_v1_models.sh
cd /home/pi
wget https://github.com/CoderBotOrg/backend/archive/develop.zip
unzip backend-develop.zip
mv backend-develop coderbot
cd coderbot

exit
pip3 install -r requirements_stub.txt
pip3 install -r requirements.txt

cd ..

systemctl disable hostapd
systemctl enable coderbot
systemctl enable pigpio
systemctl enable wifi
systemctl start pigpio
systemctl start wifi
systemctl start coderbot

