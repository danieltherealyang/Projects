#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

#faillog -m 3

if (! dpkg --get-selections | grep install | grep ufw > /dev/null 2>&1); then
     apt-get install ufw -y --force-yes
fi

ufw enable
ufw app list
ufw allow ssh
ufw allow http
ufw allow https
#ufw allow ftp-data
#ufw allow ftp
service ufw restart

if (! dpkg --get-selections | grep install | grep ntp > /dev/null 2>&1); then
     apt-get install ntp -y --force-yes
fi
service ntp start
