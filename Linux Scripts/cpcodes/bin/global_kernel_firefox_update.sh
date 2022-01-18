#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

#----------------------------------
# global update and clean up
#----------------------------------
function global_update_cleanup {
rm -f /var/cache/apt/archives/lock
echo apt-get --yes update
apt-get --yes update

echo apt-get --yes upgrade
apt-get --yes upgrade

echo apt-get --yes autoremove
apt-get --yes autoremove

echo apt-get --yes autoclean
apt-get --yes autoclean

echo aptitude purge ~c
if (! dpkg --get-selections | grep install | grep aptitude >/dev/null 2>&1); then
    apt-get install aptitude -y --force-yes
fi
aptitude purge ~c
}


function update_firefox {
CURRENT_FIREFOX_VER=$(firefox -v | cut -d " " -f 3)
if [ $CURRENT_FIREFOX_VER = "58.0.2" ]; then 
    echo "firefox $CURRENT_FIREFOX_VER is the latest version"
    return 0
fi
#----------------------------------
# update firefox
#----------------------------------
FIREFOX_PID=$(ps -elf | grep firefox | grep -v grep | awk '{print $4}')
if [ ! -z $FIREFOX_PID ]; then
    kill -9 $FIREFOX_PID
fi

dpkg --get-selections flashplugin-installer 2>/dev/null | grep install > /dev/null
if [ $? -eq 0 ]; then
    apt-get --purge autoremove flashplugin-installer -y
fi

dpkg --get-selections firefox 2>/dev/null | grep install > /dev/null
if [ $? -eq 0 ]; then
    apt-get --purge autoremove firefox -y
fi

if [ -d /usr/lib/firefox-addons ]; then
    rm -rf /usr/lib/firefox-addons
fi

if [ -d /usr/lib/firefox-addons ]; then
    rm -rf /usr/lib/firefox-addons
fi

echo apt-get install firefox -y
apt-get install firefox -y --force-yes
firefox -v
#----------------------------------
}

function update_kernel {
OS_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//')
OS_MAJOR_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | cut -d "." -f 1)
OS_TYPE=$(lsb_release -i | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | tr "[:upper:]" "[:lower:]" )
CURRENT_KERNEL_VER=$(uname -r)

if [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_14" ]; then
    if [ $CURRENT_KERNEL_VER = "4.4.0-101-generic" ]; then 
        echo "Kernel $CURRENT_KERNEL_VER is the latest kernel for ${OS_TYPE}_${OS_MAJOR_VERSION}"
        exit 0
    fi
    echo apt-get install --install-recommends linux-generic-lts-xenial
    apt-get install --install-recommends linux-generic-lts-xenial -y --force-yes
    echo "kernel has been upgraded.  The current kernel version is: $CURRENT_KERNEL_VER"
    echo "You need to restart to finish kernel update and gain the points"
fi

if [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_16" ]; then
    if [ $CURRENT_KERNEL_VER = "4.13.0-32-generic" ]; then 
        echo "Kernel $CURRENT_KERNEL_VER is the latest kernel for ${OS_TYPE}_${OS_MAJOR_VERSION}"
        exit 0
    fi
    echo apt-get install --install-recommends linux-generic-hwe-16.04 xserver-xorg-hwe-16.04
    apt-get install --install-recommends linux-generic-hwe-16.04 xserver-xorg-hwe-16.04 -y --force-yes
    echo "kernel has been upgraded.  The current kernel version is: $CURRENT_KERNEL_VER"
    echo "You need to restart to finish kernel update and gain the points"
fi
}

global_update_cleanup
update_firefox
update_kernel
