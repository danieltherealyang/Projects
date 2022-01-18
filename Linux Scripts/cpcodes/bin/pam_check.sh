#!/bin/bash

rm -f /etc/security/console.perms
echo "" > /etc/securetty

grep rhosts_auth /etc/pam.d/*
grep pam_console.so /etc/pam.d/*

touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 0600 /etc/security/opasswd

find / -iname '*hosts.equiv'
find / -iname '*.rhosts'

#touch /etc/nologin
#chown root:root /etc/nologin
#chmod 0600 /etc/nologin

#pwck -r | grep 'no group'
#grpconv

# minlen=15 15 or greater
grep -E 'pam_cracklib.so.*minlen' /etc/pam.d/* 

grep "^log_file" /etc/audit/auditd.conf|sed s/^[^\/]*//|xargs stat -c %G:%n

service ntp status
service ntp start
