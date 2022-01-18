#!/bin/bash

if (! dpkg --get-selections | grep install | grep ufw > /dev/null 2>&1); then
     apt-get install ufw -y --force-yes
fi

ufw enable
service ufw start
ufw app list
ufw allow ftp-data
ufw allow ftp

if (! dpkg --get-selections | grep install | grep vsftpd > /dev/null 2>&1); then
  apt-get install vsftpd -y --force-yes
fi

if [ ! -d /var/ftp ]; then
  mkdir -p /var/ftp
fi
chmod 755 /var/ftp
chown nobody:nogroup /var/ftp

sed -i -e 's/anonymous_enable=NO/anonymous_enable=YES/' ../template/root/etc/vsftpd.conf
sed -i -e 's/allow_anon_ssl=NO/allow_anon_ssl=YES/' ../template/root/etc/vsftpd.conf
sed -i -e 's/local_enable=YES/local_enable=NO/' ../template/root/etc/vsftpd.conf

if (! grep 'anon_root=/var/ftp/' ../template/root/etc/vsftpd.conf >/dev/null 2>&1); then
  echo 'anon_root=/var/ftp/' >> ../template/root/etc/vsftpd.conf
fi

if (! grep 'no_anon_password=YES' ../template/root/etc/vsftpd.conf >/dev/null 2>&1); then
  echo 'no_anon_password=YES' >> ../template/root/etc/vsftpd.conf
fi

if (! grep 'hide_ids=YES' ../template/root/etc/vsftpd.conf >/dev/null 2>&1); then
  echo 'hide_ids=YES' >> ../template/root/etc/vsftpd.conf
fi

cp ../template/root/etc/vsftpd.conf /etc/vsftpd.conf
service vsftpd restart
