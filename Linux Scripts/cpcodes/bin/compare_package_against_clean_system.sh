#!/bin/bash

if [ $UID -ne 0 ] ; then
     echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
     exit 255
fi

Usage() {
     echo "Usage: $0 [-u]"
     echo "   $0    : output the difference to terminal"
     echo "   $0 -u : show the difference using meld diff GUI"
     exit 1
}

useMeld=0
if [ $# -ne 0 ] && [ $# -ne 1 ]; then
     Usage
fi

if [ $# -eq 1 ]; then
     if [ "X$1" = "X-u" ]; then
         useMeld=1
     elif [ "X$1" = "X-h" ]; then
         Usage
     else
         Usage
     fi
fi

if [ ! -d /tmp ]; then
     mkdir -p /tmp
     chmod 1777 /tmp
fi

OS_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//')
OS_MAJOR_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | cut -d "." -f 1)
OS_TYPE=$(lsb_release -i | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | tr "[:upper:]" "[:lower:]" )
INSTALL_PACKAGE_CLEAN_FILE=.${OS_TYPE}_${OS_MAJOR_VERSION}_clean_packages
WORKING_INSTALL_PACKAGE_CLEAN_FILE=/tmp/${INSTALL_PACKAGE_CLEAN_FILE}.$$
CURRENT_INSTALL_PACKAGE_FILE=/tmp/${OS_TYPE}_${OS_VERSION}_packages.$$

if [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_14" ] ||
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_16" ] ||
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xdebian_7" ] || 
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xdebian_8" ]; then
     #echo "The system is ${OS_TYPE}_${OS_VERSION}"
     echo "--------------------------------------------------"
     
     dpkg --get-selections | grep -v deinstall > $CURRENT_INSTALL_PACKAGE_FILE
     cp $INSTALL_PACKAGE_CLEAN_FILE $WORKING_INSTALL_PACKAGE_CLEAN_FILE

     if [ $useMeld -eq 1 ]; then
          if (! dpkg --get-selections | grep install | grep meld >/dev/null 2>&1); then
               apt-get install meld -y --force-yes
          fi
          meld $CURRENT_INSTALL_PACKAGE_FILE $WORKING_INSTALL_PACKAGE_CLEAN_FILE
     else
          diff $CURRENT_INSTALL_PACKAGE_FILE $WORKING_INSTALL_PACKAGE_CLEAN_FILE | grep -E "^< " | grep -Ev "xserver-xorg|texlive-|tex-|linux-headers-|linux-image|shc|^< lib|^< fonts|^< python|^< meld|m4|dos2unix|qtdeclarative5-|speech-dispatcher-audio-plugins|overlay-scrollbar-|procmail|samba-libs|ibus-gtk|linux-libc-dev|sensible-mda|ubuntu-minimal|sni-qt|gtk2-engines|gtk3-engines|zlib1g|sox|gcc-4|gstreamer|qt-at-spi|unity-gtk|unity-voice-service|gvfs|bluez-alsa|dconf-gsettings-backend|e2fslibs|espeak-data|gir1.2-unity-5.0|glib-networking|linux-generic|p11-kit-modules|aptitude|aptitude-common|oxideqt-codecs" | sed -e 's/^< //g;s/[ \t]*install$//;'
#          diff $CURRENT_INSTALL_PACKAGE_FILE $WORKING_INSTALL_PACKAGE_CLEAN_FILE 
     echo "--------------------------------------------------"
     echo "   $0 -u : show the difference using meld diff GUI"
     echo "--------------------------------------------------"
     fi
     echo "to remove: apt-get --purge autoremove package_name"
     echo "to find a package: dpkg --get-selections | grep -i package_name"
     if [ -f $WORKING_INSTALL_PACKAGE_CLEAN_FILE ]; then
         rm -f $WORKING_INSTALL_PACKAGE_CLEAN_FILE
     fi
     if [ -f $CURRENT_INSTALL_PACKAGE_FILE ]; then
          rm -f $CURRENT_INSTALL_PACKAGE_FILE
     fi
fi
