#!/bin/bash

usage() {
	echo "install [BACKEND_BRANCH] [FRONTEND_RELEASE]"
	echo "install all CoderBot software dependancies and components"
	exit 2
}

[[ $1 == "-h" || $1 == "--help" ]] && usage

BACKEND_BRANCH=${1:-'master'}
FRONTEND_RELEASE=${2:-'v0.1'}

apt-get update -y
apt-get upgrade -y
apt-get install -y hostapd dnsmasq pigpio espeak gpac iptables-persistent \
                   portaudio19-dev git python3-pip python3 python3-venv \
                   libopenjp2-7-dev libtiff5 libatlas-base-dev libhdf5-dev \
                   libhdf5-serial-dev python-gobject libharfbuzz-bin \
                   libwebp6 libjasper1 libilmbase23 libgstreamer1.0-0 \
                   libavcodec-extra58 libavformat58 libopencv-dev \
                   libqtgui4 libqt4-test omxplayer libhdf5-dev \
		   zbar-tools python-zbar libzbar0 avrdude tesseract-ocr
apt-get clean

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

# reset service module
cp etc/scripts/* /usr/local/bin/.         #copying user-oriented scripts
cp etc/services/* /etc/systemd/system/.   #copying services
cp etc/rsyslog.d/* /etc/rsyslog.d/.       #copying log directive


sudo -u pi bash << EOF
cd /home/pi
wget https://github.com/CoderBotOrg/backend/archive/$BACKEND_BRANCH.zip
unzip $BACKEND_BRANCH.zip
rm $BACKEND_BRANCH.zip
mv backend-$BACKEND_BRANCH coderbot
wget https://github.com/CoderBotOrg/vue-app/releases/download/$FRONTEND_RELEASE/vue-app-dist.tgz
tar xzf vue-app-dist.tgz -C coderbot
rm vue-app-dist.tgz
wget https://github.com/CoderBotOrg/docs/releases/download/v0.1/docs.tgz
mkdir -p coderbot/cb-docs
tar xzf docs.tgz -C coderbot/cb_docs
rm docs.tgz
EOF

sudo -u pi bash << EOF
./download_mobilenet_models.sh
EOF

cd ../coderbot
wget https://github.com/PINTO0309/Tensorflow-bin/raw/master/tensorflow-2.1.0-cp37-cp37m-linux_armv7l.whl
pip3 install tensorflow-2.1.0-cp37-cp37m-linux_armv7l.whl
rm tensorflow-2.1.0-cp37-cp37m-linux_armv7l.whl
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

amixer sset PCM,0 100%

systemctl disable hostapd
systemctl enable coderbot
systemctl enable pigpiod
systemctl enable wifi
systemctl enable reset_trigger.service    #enables reset_trigger service
systemctl start pigpiod
systemctl start wifi
systemctl start coderbot
systemctl start reset_trigger.service     #starts service immediately avoiding reboot to enable
systemctl restart rsyslog                 #restarting syslog to update syslog output directives

rm -rvf system-install-master
