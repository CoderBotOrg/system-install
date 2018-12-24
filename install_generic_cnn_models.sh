#!/bin/bash
CUR_DIR=$(pwd)
cd /home/pi/coderbot/cnn_models
mkdir tmp
tar xf cache/mobilenet_v2_0.35_128.tgz -C ./tmp
mv tmp/mobilenet_v2_0.35_128_frozen.pb generic_fast_low.pb
tar xf cache/mobilenet_v2_1.0_224.tgz -C ./tmp
mv tmp/mobilenet_v2_1.0_224_frozen.pb generic_slow_high.pb
tar xf cache/mobilenet_v1_0.25_128_frozen.tgz -C ./tmp
mv tmp/mobilenet_v1_0.25_128/labels.txt generic_fast_low.txt
cp generic_fast_low.txt generic_slow_high.txt
rm -rf tmp
echo '{"generic_fast_low":{"status":1.0, "image_height": "128", "image_width":"128", "output_layer": "MobilenetV2/Predictions/Reshape_1"}, "generic_slow_high":{"status":1.0, "image_height":"224", "image_width": "224", "output_layer": "MobilenetV2/Predictions/Reshape_1"}}' > models.json
cd $CUR_DIR
