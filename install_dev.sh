#!/bin/bash
SYSTEM_INSTALL_DIR=$(pwd)
set -e
usage() {
	echo "install [BACKEND_BRANCH] [FRONTEND_RELEASE]"
	echo "install all CoderBot software dependancies and components"
	exit 2
}

[[ $1 == "-h" || $1 == "--help" ]] && usage

BACKEND_BRANCH=${1:-'develop'}
FRONTEND_RELEASE=${2:-'v0.6'}
INSTALL_MODEL_PRETRAINED=${3:-'yes'}
INSTALL_MODEL_4TRAINING=${4:-'no'}

apt-get update -y
apt-get upgrade -y
apt-get install -y pigpio espeak ffmpeg nginx \
                   portaudio19-dev git python3-pip python3 python3-venv \
                   libopenjp2-7-dev libtiff5 libatlas-base-dev libhdf5-dev \
                   libharfbuzz-bin libwebp6 libjasper1 libilmbase25 \
                   libgstreamer1.0-0 libavcodec-extra58 libavformat58 \
                   libopencv-dev zbar-tools libzbar0 sox libsox-fmt-all \
                   avrdude tesseract-ocr
                   
apt-get clean

mkdir -p /etc/coderbot

cp etc/boot/config.txt /boot/config.txt
cp etc/hostname /etc/.
cp etc/hosts /etc/.
cp etc/init.d/* /etc/init.d/.
cp etc/avrdude.conf /usr/local/etc/.
cp etc/modprobe.d/alsa-base.conf /etc/modprobe.d/.
cp etc/alsa.conf /usr/share/alsa/alsa.conf
cp etc/modules /etc/modules 
cp etc/nginx/nginx.conf /etc/nginx/nginx.conf
cp etc/nginx/default.conf /etc/nginx/conf.d/default.conf

# reset service module
cp etc/scripts/* /usr/local/bin/.         #copying user-oriented scripts
cp etc/services/* /etc/systemd/system/.   #copying services
cp etc/rsyslog.d/* /etc/rsyslog.d/.       #copying log directive


sudo -u pi bash << EOF
cd /home/pi
git clone https://github.com/CoderBotOrg/backend coderbot -b $BACKEND_BRANCH
git clone https://github.com/CoderBotOrg/python-wifi-connect-stub.git wifi
EOF

sudo -u pi bash << EOF
[[ "$INSTALL_MODEL_PRETRAINED" = "yes" ]] && ./install_generic_cnn_models.sh
[[ "$INSTALL_MODEL_4TRAINING" = "yes" ]] && ./download_mobilenet_models.sh
echo done
EOF

cd /home/pi/coderbot
pip install --no-cache-dir -r requirements.txt
cd /home/pi

wget https://github.com/CoderBotOrg/frontend/releases/download/$FRONTEND_RELEASE/frontend.tar.gz
tar xzf frontend.tar.gz -C /usr/share/nginx/html --strip-components=1
rm frontend.tar.gz
wget https://github.com/CoderBotOrg/docs/releases/download/v0.2/docs.tgz
mkdir -p /usr/share/nginx/html/docs
tar xzf docs.tgz -C /usr/share/nginx/html/docs
rm docs.tgz

sudo -u pi bash << EOF
$SYSTEM_INSTALL_DIR/install_firmware.sh
EOF

# amixer sset Headphone,0 100%

systemctl disable dphys-swapfile
systemctl enable coderbot
systemctl start wifi
systemctl enable pigpiod
systemctl start pigpiod
systemctl start coderbot
systemctl restart rsyslog                 #restarting syslog to update syslog output directives

rm -rvf $SYSTEM_INSTALL_DIR

# music extension
# amixer -c1 cset 'numid=1' 400

# replace avrdude with custom build - linuxspi support
wget https://github.com/CoderBotOrg/avrdude/releases/download/v7.0/avrdude-v7.tar.gz
tar xf avrdude-v7.tar.gz
mv v7.0/avrdude /usr/local/bin/avrdude
mv v7.0/avrdude.conf /usr/local/etc/avrdude.conf
rm -rf v7.0
rm avrdude-v7.tar.gz

echo "coderbot install complete!"
