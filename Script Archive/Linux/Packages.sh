#!/bin/bash

if [ $UID -ne 0 ]; then
echo Need higher privileges
exit 0
fi

declare -a pkg=( psad fail2ban auditd nmap rkhunter chkrootkit apparmor clamav aide )

for i in ${pkg[@]} 
do
if [ "$(dpkg --get-selections | grep $i)" = "" ]; then

echo -n '$i is not installed. Do you want to install $i? [y or n]' 
read pkgresponse

case $pkgresponse in 
	y ) apt-get install $i
	;;
	n ) echo '$i will not be installed'
		read -p "Press any key to continue"
esac

fi
done 

declare -a pkg2=( 
telnet
sendmail
hydra
john
openldap-servers
openswan
xorg-x11-server-common
logkeys
ruby 
rails
httpry
nginx
dsniff
xinetd 
nikto
bind9 
cain
lighttpd 
medusa
)

for i in ${pkg2[@]}
do 
if [ "$(dpkg --get-selections | grep $i)" != "" ]; then

echo -n '$i is installed. Do you want to remove $i? [y or n]'
read pkg2response

case $pkg2response in 
	y ) apt-get --purge autoremove $i
	;;
	n ) echo '$i will not be removed'
		read -p "Press any key to continue"
esac

fi
done 

echo "-D
-b 1024
-a exit,always -S unlink -S rmdir
-a exit,always -S open -F loginuid=1001
-w /etc/group -p wa
-w /etc/passwd -p wa
-w /etc/shadow -p wa
-w /etc/sudoers -p wa
-w /etc/secret_directory -p r
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b32 -S init_module -S delete_module -k modules
-a always,exit -F arch=b32 -S chown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S chown -F auid=0 -k perm_mod 
-a always,exit -F arch=b32 -S fchown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchown -F auid=0 -k perm_mod 
-a always,exit -F arch=b32 -S fchownat -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchownat -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lchown -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S chmod -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S chmod -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S fchmod -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchmod -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchmodat -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fremovexattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S fsetxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fsetxattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S lremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lremovexattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S lsetxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lsetxattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S removexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S removexattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S setxattr -F auid=0 -k perm_mod
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid=0 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid=0 -k access
-w /etc/group -p wa -k audit_account_changes 
-w /etc/passwd -p wa -k audit_account_changes 
-w /etc/gshadow -p wa -k audit_account_changes 
-w /etc/shadow -p wa -k audit_account_changes 
-w /etc/security/opasswd -p wa -k audit_account_changes
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k audit_network_modifications 
-w /etc/issue -p wa -k audit_network_modifications 
-w /etc/issue.net -p wa -k audit_network_modifications 
-w /etc/hosts -p wa -k audit_network_modifications 
-w /etc/sysconfig/network -p wa -k audit_network_modifications
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export
-a always,exit -F arch=b32 -S mount -F auid=0 -k export
-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid=0 -k delete
-w /etc/sudoers -p wa -k actions
-e 2" > /etc/audit/audit.rules

chmod 0640 /etc/audit/auditd.conf && chown root /etc/audit/auditd.conf && chgrp root /etc/audit/auditd.conf && chmod go-w /etc/audit/auditd.conf

