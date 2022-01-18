#!/bin/bash

if (! dpkg --get-selections | grep install | grep ufw > /dev/null 2>&1); then
     apt-get install ufw -y --force-yes
fi

ufw enable
service ufw start
ufw app list
ufw enable ftp-data
ufw enable ftp

if (! dpkg --get-selections | grep install | grep vsftpd > /dev/null 2>&1); then
  apt-get install vsftpd -y --force-yes
fi

sed -i -e 's/anonymous_enable=YES/anonymous_enable=NO/' ../template/root/etc/vsftpd.conf
sed -i -e 's/allow_anon_ssl=YES/allow_anon_ssl=NO/' ../template/root/etc/vsftpd.conf
sed -i -e 's/local_enable=NO/local_enable=YES/' ../template/root/etc/vsftpd.conf

sed -i -e '/\b\(anon_root\)\b/d' ../template/root/etc/vsftpd.conf
sed -i -e '/\b\(no_anon_password\)\b/d' ../template/root/etc/vsftpd.conf
sed -i -e '/\b\(hide_ids\)\b/d' ../template/root/etc/vsftpd.conf

cp ../template/root/etc/vsftpd.conf /etc/vsftpd.conf 
service vsftpd restart
