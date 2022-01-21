#!/bin/bash

usage() {
	echo "install [BACKEND_BRANCH] [FRONTEND_RELEASE]"
	echo "install all CoderBot software dependancies and components"
	exit 2
}

[[ $1 == "-h" || $1 == "--help" ]] && usage

BACKEND_BRANCH=${1:-'5.0.0-rc0'}
FRONTEND_RELEASE=${2:-'v4.0-rc0'}

apt-get update -y
apt-get upgrade -y
apt-get install -y hostapd dnsmasq pigpio espeak gpac iptables-persistent \
                   portaudio19-dev git python3-pip python3 python3-venv \
                   libopenjp2-7-dev libtiff5 libatlas-base-dev libhdf5-dev \
                   libharfbuzz-bin libwebp6 libjasper1 libilmbase25 \
                   libgstreamer1.0-0 libavcodec-extra58 libavformat58 \ 
                   libopencv-dev zbar-tools libzbar0 sox libsox-fmt-all \
                   avrdude tesseract-ocr
                   
apt-get clean

mkdir -p /etc/coderbot

cp etc/hostname /etc/.
cp etc/hosts /etc/.
cp etc/init.d/* /etc/init.d/.
cp etc/hostapd/* /etc/hostapd/.
cp etc/dnsmasq.conf /etc/.
cp etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/.
cp etc/avrdude.conf /etc/.
cp etc/coderbot/* /etc/coderbot/.
cp etc/modprobe.d/alsa-base.conf /etc/modprobe.d/.
cp etc/alsa.conf /usr/share/alsa/alsa.conf
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
wget https://github.com/CoderBotOrg/frontend/releases/download/$FRONTEND_RELEASE/frontend.tar.gz
tar xzf frontend.tar.gz -C coderbot
rm frontend.tar.gz
wget https://github.com/CoderBotOrg/docs/releases/download/v0.1/docs.tgz
mkdir -p coderbot/cb_docs
tar xzf docs.tgz -C coderbot/cb_docs
rm docs.tgz
EOF

sudo -u pi bash << EOF
./download_mobilenet_models.sh
EOF

cd ../coderbot
wget https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/main/tensorflow-2.7.0-cp39-none-linux_aarch64_numpy1214_download.sh 
./tensorflow-2.7.0-cp39-none-linux_aarch64_numpy1214_download.sh
pip3 install tensorflow-2.7.0-cp39-none-linux_aarch64.whl
rm tensorflow-2.7.0-cp39-none-linux_aarch64.whl 
pip3 install -r requirements_stub.txt
pip3 install -r requirements.txt

cd ..

sudo -u pi bash << EOF
./install_firmware.sh
EOF

wget https://github.com/CoderBotOrg/update-reset/archive/master.zip
unzip master.zip
rm master.zip
cd update-reset-master
make install DESTDIR=/
enable_overlay enable
cd ..
rm -rvf update-reset-master

amixer sset PCM,0 100%

systemctl disable dphys-swapfile
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

# music extension
amixer -c1 cset 'numid=1' 400

echo "coderbot install complete!"
