#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

find /home -type f -mtime -60 -exec ls -l {} \; | grep -Ev "\.dmrc|\.ICEauthority|\.mozilla|cheetah|\.cache|\.config|\.local|\.dbus|\.gconf|\.xsession-errors|\.Xauthority|\.compiz|examples.desktop"
