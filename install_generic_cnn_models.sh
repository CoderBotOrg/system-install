#!/bin/bash
CUR_DIR=$(pwd)
cd /home/pi/coderbot
wget -nc https://github.com/CoderBotOrg/net-models/raw/master/archive/cnn_models.tar.xz
tar xJf cnn_models.tar.xz
rm cnn_models.tar.xz
cd $CUR_DIR
