#!/bin/bash

usage() {
	echo "install [BACKEND_BRANCH] [FRONTEND_RELEASE]"
	echo "install all CoderBot software dependancies and components"
	exit 2
}

[[ $1 == "-h" || $1 == "--help" ]] && usage

BACKEND_BRANCH=${1:-'develop'}
FRONTEND_RELEASE=${2:-'v0.1-alpha5'}

apt-get update -y
apt-get upgrade -y
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
cd /home/pi
wget https://github.com/CoderBotOrg/backend/archive/$BACKEND_BRANCH.zip
unzip $BACKEND_BRANCH.zip
rm $BACKEND_BRANCH.zip
mv backend-$BACKEND_BRANCH coderbot
wget https://github.com/CoderBotOrg/vue-app/releases/download/$FRONTEND_RELEASE/vue-app-dist.tgz
tar xzf vue-app-dist.tgz -C coderbot
rm vue-app-dist.tgz
EOF

sudo -u pi bash << EOF
./download_mobilenet_models.sh
EOF

cd ../coderbot
pip3 install -r requirements_stub.txt
pip3 install -r requirements.txt

cd ..

wget https://github.com/CoderBotOrg/update-reset/archive/master.zip
unzip master.zip
rm master.zip
cd update-reset-master
make install DESTDIR=/
enable_overlay enable
cd ..
rm -rvf update-reset-master

systemctl disable hostapd
systemctl enable coderbot
systemctl enable pigpiod
systemctl enable wifi
systemctl start pigpiod
systemctl start wifi
systemctl start coderbot

rm -rvf system-install-master
