#!/bin/bash

apt-get install -y hostapd dnsmasq

mkdir /etc/coderbot


cp etc/hostname /etc/.
cp etc/hosts /etc/.
cp etc/init.d/* /etc/init.d/.
cp etc/hostapd/* /etc/hostapd/.
cp etc/dnsmasq.conf /etc/.
cp etc/coderbot/* /etc/coderbot/.

systemctl enable coderbot
systemctl disable hostapd
systemctl enable wifi

