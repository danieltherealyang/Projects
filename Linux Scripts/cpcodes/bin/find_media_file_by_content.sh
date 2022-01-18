#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

find /bin /boot /cdrom /etc /home /lib /lib64 /lost+found /media /mnt /opt /root /sbin /srv /tmp /usr /var -type f -exec file -N --mime-type -k -p {} \; 2>/dev/null | grep -Ei " image/| video/| audio/|application/zip" | grep -Ev "usr/share|usr/lib/libreoffice|usr/lib/python|usr/lib/ruby|usr/lib/jvm|cache/mozilla/firefox|cache/thumbnails|/lib/plymouth|/lib/firmware|\.cache|/usr/lib/x86_64-linux-gnu/qt5|/usr/lib/thunderbird|/usr/lib/shotwell/plugins|/usr/lib/firefox|/usr/lib/thunderbird|ScoreEngine|/usr/lib/i386-linux-gnu"
