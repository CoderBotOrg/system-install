#!/bin/bash

apt-get install -y hostapd dnsmasq

mkdir /etc/coderbot

cp etc/init.d/* /etc/init.d/.
cp etc/hostapd/* /etc/hostapd/.
cp etc/coderbot/* /etc/coderbot/.

systemctl enable coderbot
systemctl enable wifi

