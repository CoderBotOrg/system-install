#!/bin/bash
CURDIR = $(pwd)
mkdir -p /tmp/imagenet
cd /tmp/imagenet
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.75_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.50_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.25_224_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_128_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.75_128_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.50_128_frozen.tgz
wget -nc https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_0.25_128_frozen.tgz
cd $CURDIR

