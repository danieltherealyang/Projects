#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

echo "-----This script will do nothing-----"
echo "Just provide instructions:"
echo "  We need to manually install and start: ufw and ntp to get points."

echo "Install ufw:"
echo "   apt-get install ufw -y --force-yes"
echo "Start ufw:"
echo "   ufw enable"
echo "   ufw app list"
echo "   service ufw start"
echo "-------------------------------"
echo "Install ntp"
echo "   apt-get install ntp -y --force-yes"
echo "Start ntp:"
echo "   service ntp start" 

exit 0

#faillog -m 3

dpkg --get-selections | grep install | grep ufw
if [ $? -ne 0 ]; then
     apt-get install ufw -y --force-yes
fi

ufw enable
ufw app list
service ufw start

dpkg --get-selections | grep install | grep ntp
if [ $? -ne 0 ]; then
     apt-get install ntp -y --force-yes
fi
service ntp start
