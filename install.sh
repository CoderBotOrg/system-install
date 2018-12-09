#!/bin/bash

apt-get install -y hostapd dnsmasq pigpio espeak gpac iptables-persistent \
                   portaudio19-dev git python3-pip python3 python3-venv \
                   libopenjp2-7-dev libtiff5 libatlas-base-dev libhdf5-dev \
                   libhdf5-serial-dev python-gobject libharfbuzz-bin \
                   libwebp6 libjasper1 libilmbase12 libgstreamer1.0-0 \
                   libavcodec-extra57 libavformat57 libopencv-dev \
                   libqtgui4 libqt4-test omxplayer libhdf5-dev

mkdir -p /etc/coderbot

cp etc/hostname /etc/.
cp etc/hosts /etc/.
cp etc/init.d/* /etc/init.d/.
cp etc/hostapd/* /etc/hostapd/.
cp etc/dnsmasq.conf /etc/.
cp etc/coderbot/* /etc/coderbot/.
cp etc/modprobe.d/alsa-base.conf /etc/modprobe.d/.
cp etc/iptables/rules.v4 /etc/iptables/.
cp etc/network/interfaces.d/client /etc/network/interfaces.d/. 

sudo -u pi bash << EOF
./download_mobilenet_v1_models.sh
cd /home/pi
wget https://github.com/CoderBotOrg/backend/archive/develop.zip
unzip develop.zip
rm develop.zip
mv backend-develop coderbot
EOF

cd ../coderbot
pip3 install -r requirements_stub.txt
pip3 install -r requirements.txt

cd ..

systemctl disable hostapd
systemctl enable coderbot
systemctl enable pigpiod
systemctl enable wifi
systemctl start pigpiod
systemctl start wifi
systemctl start coderbot
