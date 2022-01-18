#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

# Search for the existence of '.netrc' files for FTP 
find /root /home -xdev -name .netrc -delete

find /lib /usr/lib -perm /022 -type f -exec ls -l {} \; | grep -E -v "python|*pyc$|*chk$"
find /etc /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin -perm /022 -type f -exec ls -l {} \;
find /etc /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin -not -user root -not -user libuuid -type f -exec ls -l {} \;
find /etc /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin -not -group root -not -group shadow -not -group lp -not -group dip -not -group ssl-cert -not -group fuse -not -group lightdm -not -group lpadmin -not -group mlocate -not -group ssh -not -group tty -not -group mail -not -group crontab -not -group libuuid -type f -exec ls -l {} \;
find / -xdev -type f -perm -002 -exec ls -l {} \; 
find / -xdev -type d -perm -0002 -uid +499 -exec ls -l {} \;
find / -name  "*~" 2>/dev/null
