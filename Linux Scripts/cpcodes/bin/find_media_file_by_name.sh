#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

find / -type f -regextype posix-extended -iregex '.*\.(zip|iff|aup|m3u|m4a|mid|mp3|mpa|ra|wav|wma|3g2|3gp|asf|asx|avi|flv|m4v|mov|mp4|mpg|rm|srt|swf|vob|wmv|aif|webm|mkv|flv|vob|ogv|ogg|drc|gif|gifv|mng|avi|mov|qt|wmv|yuv|rm|rmvb|asf|amv|mp4|m4p|m4v|mpg|mp2|mpeg|mpe|mpv|svi|3gp|3g2|mxf|roq|nsf|flv|f4v|f4p|f4a|f4b|aa|aac|aax|act|aiff|amr|ape|au|awb|dct|dss|dvf|flac|gsm|iklax,|ivs|m4a|m4b|mmf|mpc|msv|oga|opus|ra|raw|sln|tta|vox|wav|wma|wv|jpeg|jpg|tif|tiff|gif|bmp|png|pbm|pgm|ppm|pnm|webp|hdr|bpg|ico|img|mpi)' -exec ls -l {} \; | grep -Ev "/boot/grub/i386-pc|\.cache|\.config/libreoffice|firefox/browser|/lib/firmware|/lib/plymouth|ScoreEngine|/usr/lib/firefox|/usr/lib/grub|/usr/lib/jvm|/usr/lib/libreoffice|/usr/lib/python|/usr/lib/ruby|/usr/lib/shotwell|/usr/lib/thunderbird|/usr/lib/x86_64-linux-gnu|/usr/lib/i386-linux-gnu|/usr/share|\.mozilla/firefox"

find / -type f -iname '*.txt' -exec ls -l {} \; | grep -Ev "/usr/lib/x86_64-linux-gnu|/usr/lib/i386-linux-gnu|/usr/lib/python|/usr/share|/usr/src|/lib/firmware|/etc/brltty|/boot/grub|/var/lib/nssdb|/var/cache/dictionaries-common|/usr/lib/libreoffice/share|/usr/lib/xorg|/etc/X11/rgb.txt|ScoreEngine|\.mozilla/firefox"
