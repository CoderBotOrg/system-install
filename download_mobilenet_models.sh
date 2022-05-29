#!/bin/bash
CURDIR = $(pwd)
mkdir -p /home/pi/coderbot/cnn_models/cache
cd /home/pi/coderbot/cnn_models/cache
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.25_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_128_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.25_128_frozen.tgz
wget -nc https://storage.googleapis.com/mobilenet_v2/checkpoints/mobilenet_v2_1.0_224.tgz
wget -nc https://storage.googleapis.com/mobilenet_v2/checkpoints/mobilenet_v2_1.0_128.tgz
wget -nc https://storage.googleapis.com/mobilenet_v2/checkpoints/mobilenet_v2_0.35_224.tgz
wget -nc https://storage.googleapis.com/mobilenet_v2/checkpoints/mobilenet_v2_0.35_128.tgz
cd $CURDIR
