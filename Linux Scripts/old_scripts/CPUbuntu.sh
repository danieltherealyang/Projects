#!/bin/bash

#==============================================#
#                                              #
#				FILE=CPUBUNTU.SH               #
#         WRITTEN BY=DANIEL YANG               #
#        DESCRIPTION=Completes tasks on        #
#     the Cyber Patriot Checklist Website      #
#                                              #
#==============================================#

echo "DANIEL YANG is a boss"
echo "DANIEL YANG's LINUX SCRIPT 'CPUBUNTU.sh' IS ACTIVE"

##### INFO #####
	##### SECTIONS OF THE CHECKLIST WEBSITE SCRIPT COVERS #####
	# Authentication
	# Disable/Remove Unnecessary Services
	# Restrict System Access from Servers and Networks (Firewall)
	# Restricting su Access to System and Shared Accounts
	# Kernel Tunable Security Parameters
	# Remote Desktop
	# Hide User List
	# Removable Media
	# Review Inittab and Boot Scripts
	# Secure Servers/Services
	# Check File Permissions and Ownership
	# Check for Shellshock Bash Vulnerability
	# Restrict Direct Login Access for System and Shared Accounts
	# Software
	# Prevent Accidental Denial of Service
	# Secure the Console
	# Secure Shared Memory
	# Secure /tmp and /var/tmp
	# Umask Settings
	# Host-Based Linux Monitering and Intrusion Detection
	# STIGS
	##### END OF SECTIONS OF THE CHECKLIST WEBSITE SCRIPT COVERS #####

#----------------------------------------

	##### SECTIONS OF THE CHECKLIST WEBSITE SCRIPT EXCLUDES #####
	# Software Management/Updates
	# Vulnerability Scan 
	# Login/Screensaver Configuration
	# Check Listening Network Ports
	# Look for Hidden Files and Multimedia Files
	# Secure Browser
	##### END OF SECTIONS OF THE CHECKLIST WEBSITE SCRIPT EXCLUDES #####
##### End of INFO #####

#----------------------------------------

##### Variables #####
bash=$(env VAR='() { :;}; echo Bash is vulnerable!' bash -c "echo Bash Test")
username=$(cat /etc/passwd | egrep -v '\/false|\/nologin|\/shutdown|\/halt' |cut -d':' -f 1,7)
file5=/etc/fstab
file6=.bashrc
file7=/etc/csh.cshrc
file8=/etc/profile
file9=/etc/login.defs
file10=/etc/audit/audit.rules
##### End of Variables #####

#----------------------------------------

##### Functions #####
function functfail2ban_conf {
	sudo bash -c 'echo "enabled = true" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "port = ssh" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "filter = sshd" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "logpath = /var/log/auth.log" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "maxretry = 2" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "[ssh]" >> /etc/fail2ban/jail.local'
	sudo bash -c 'echo "[ssh-ddos]" >> /etc/fail2ban/jail.local'
}

function functmodprobe_conf {
	sudo bash -c 'echo "install appletalk /bin/true" >> /etc/modprobe.conf'
	#SCTP, Disable SCTP to lower attack surface on the OS
	sudo bash -c 'echo "install sctp /bin/true" >> /etc/modprobe.conf'
	#DCCP, Disable DCCP to lower attack surface on the OS
	sudo bash -c 'echo "install dccp /bin/true" >> /etc/modprobe.conf' 
	sudo bash -c 'echo "install dccp_ipv4 /bin/true" >> /etc/modprobe.conf'
	sudo bash -c 'echo "install dccp_ipv6 /bin/true" >> /etc/modprobe.conf'
	#RDS, Disable RDS to lower attack surface on the OS
	sudo bash -c 'echo "install rds /bin/true" >> /etc/modprobe.conf'
	#TIPC, Disable TIPC to lower attack surface on the OS
	sudo bash -c 'echo "install tipc /bin/true" >> /etc/modprobe.conf'
}

#####End of Functions#####

#----------------------------------------

##### Beginning of Script #####

#####Authentication#####
#remove unnecessary accounts
echo "go to user account settings -> unlock -> delete unnecessary accounts"
#check if cracklib is installed	
	if [[ $(dpkg -l | grep "libpam-cracklib") ]]; then 
		echo "Libpam-Cracklib is installed"
	else 
		echo "Libpam-Cracklib is not installed"
		sudo apt-get install libpam-cracklib
	fi
#getting rid of a hole in password security	
sudo sed -i '/auth sufficient pam_permit.so/d' /etc/pam.d/common-auth
sudo sed -i 's/try_first_pass//g' /etc/pam.d/common-password	
#/etc/pam.d/common-password
#    Verify that null passwords cannot be used
sudo sed -i 's/nullok//g' /etc/pam.d/common-password
#    Minimum Password Length and Comparison
	if [[ $(grep "pam_cracklib.so" /etc/pam.d/common-password) ]]; then	
		sudo sed -i '/pam_cracklib.so/c\password        requisite                       pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1' /etc/pam.d/common-password
	else 
		sudo sed -i '/"Primary"/a\password        requisite                       pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1' /etc/pam.d/common-password
	fi
#    Password history
	if [[ $(grep "pam_pwhistory.so" /etc/pam.d/common-password) ]]; then
		sudo sed -i '/pam_pwhistory.so/c\password        requisite                       pam_pwhistory.so use_authtok remember=24 enforce_for_root' /etc/pam.d/common-password
	else 
		sudo sed -i '$ a\password        requisite                       pam_pwhistory.so use_authtok remember=24 enforce_for_root' /etc/pam.d/common-password
	fi
#    Hashing Algorithm
	if [[ $(grep "pam_unix.so"	/etc/pam.d/common-password) ]]; then
		sudo sed -i '/pam_unix.so/c\password [success=1 default=ignore] pam_unix.so obscure use_authtok sha512 shadow remember=24' /etc/pam.d/common_password
	fi
#/etc/login.defs
#    Setup Password Policy
sudo sed -i '/PASS_MAX_DAYS/c\PASS_MAX_DAYS	90' /etc/login.defs
sudo sed -i '/PASS_MIN_DAYS/c\PASS_MIN_DAYS	7' /etc/login.defs
sudo sed -i '/PASS_WARN_AGE/c\PASS_WARN_AGE	14' /etc/login.defs
echo "Login.defs password policy set"
#    Hashing Algorithm
sudo sed -i '/ENCRYPT_METHOD/c\ENCRYPT_METHOD SHA512' /etc/login.defs
echo "Login.defs hashing algorithm set"
#/etc/lightdm/lightdm.conf
#    Disable guest login
sudo sed -i '$ a\allow-guest=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
echo "Guest login disabled"
#/etc/passwd
#    Password Hashes
sudo awk -F: '($2 != "x") {print}' /etc/passwd >> deleteacct.txt
echo "check the file 'deleteacct.txt' to see which accounts to delete"
#    Disable shell accounts
sudo usermod -s /usr/sbin/nologin "$username"
echo "Shell accounts disabled"
#Check for hosts.equiv and .rhosts files
sudo find / -name .rhosts -exec rm {} \; 
sudo find / -name .shosts -exec rm {} \; 
sudo find / -name hosts.equiv -exec rm {} \; 
sudo find / -name shosts.equiv -exec rm {} \;
#/etc/pam_ldap.conf 
#    if 'cert' is not in /etc/pam_ldap.conf, then add the 	
	if [[ $(grep "cert" /etc/pam_ldap.conf) ]]; then 
		sudo sed -i '$ a\ssl start_tlset' /etc/pam_ldap.conf
		sudo sed -i '$ a\tls_cacertdir /etc/pki/tls/CA' /etc/pam_ldap.conf
	fi
#/etc/pam.d/login
	if [[ $(grep 'pam_lastlog.so' /etc/pam.d/login)  ]]; then 
		sudo sed '/pam_lastlog.so/c\ session required pam_lastlog.so showfailed' /etc/pam.d/login
	fi
#####End of Authentication#####



echo "END of AUTHENTICATION"



#####Disable/Remove Unnecessary Services#####
#telnet
sudo apt-get purge telnetd inetutils-telnetd telnetd-ssl
sudo sysv-rc-conf telnet off
echo "Telnet off"
#FTP
sudo ufw deny ftp
	if [[ $(dpkg -l | grep ftpd) ]]; then
		sudo service $ftp stop
		sudo apt-get -qq remove $ftp
		sudo apt-get -qq purge $ftp
	fi
echo "FTP off"
#rsh
	if [[ $(dpkg -l | grep rsh-server) ]]; then 
		sudo apt-get --purge autoremove rsh-server 
	fi
sudo sysv-rc-conf rsh off
echo "RSH off"
#autofs
sudo touch /etc/udev/rules.d/85-no-automount.rules
sudo sed -i '$ i\SUBSYSTEM=="usb", ENV{UDISKS_AUTO}="0"' /etc/udev/rules.d/85-no-automount.rules 
sudo service udev restart
echo "Autofs configured"
#avahi
sudo bash -c 'echo "manual" > /etc/init/avahi-daemon.override'
echo "Avahi configured"
#bluetooth
	if [[ $(grep 'InitiallyPowered' /etc/bluetooth/main.conf) ]]; then 
		sudo sed -i '/InitiallyPowered/c\InitiallyPowered = false' /etc/bluetooth/main.conf
	else 
		sudo sed -i '$ a\InitiallyPowered = false' /etc/bluetooth/main.conf
	fi
echo "Bluetooth configured"
#cups
sudo bash -c 'echo "manual" > /etc/init/cups.override'
echo "Cups configured" 
#modemmanager
sudo bash -c 'echo "manual" > /etc/init/modemmanager.override'
	if [[ $(dpkg -l | grep dovecot-*) ]]; then 
		sudo apt-get -qq purge dovecot-*
	fi
	if [[ $(dpkg -l | grep sendmail) ]]; then
		sudo apt-get -qq --purge autoremove sendmail
	fi
	if [[ $(dpkg -l | grep "nfs-kernel-server") ]]; then
		sudo apt-get -qq purge nfs-kernel-server
	fi
	if [[ $(dpkg -l | grep "nfs-common") ]]; then
		sudo apt-get -qq purge nfs-common
	fi
	if [[ $(dpkg -l | grep "portmap") ]]; then
		sudo apt-get -qq purge portmap
	fi
	if [[ $(dpkg -l | grep "rpcbind") ]]; then
		sudo apt-get -qq purge rpcbind
	fi
	if [[ $(dpkg -l | grep "autofs") ]]; then
		sudo apt-get -qq purge autofs
	fi
	if [[ $(dpkg -l | grep snmp) ]]; then 
		sudo apt-get -qq --purge autoremove snmp
	fi
echo "SNMP removed"
#whoopsie
sudo sed -i '$ a\report_crashes=false' /etc/default/whoopsie
#apport
sudo sed -i '4 c\enabled = 0' /etc/default/apport
#irqbalance
sudo sed -i '4 c\ENABLED="0"' /etc/default/irqbalance
#rexec
sudo sysv-rc-conf rexec off
#rlogin
sudo sysv-rc-conf rlogin off
#netconsole
sudo sysv-rc-conf netconsole off && service netconsole stop
#autofs
sudo sysv-rc-conf --level 0123456 autofs off && service autofs stop
#AppleTalk
	if [[ $(find /etc -iname "modprobe.conf" | grep "No such file or directory") ]]; then 
		echo "modprobe.conf is not here"
		sudo touch /etc/modprobe.conf
		functmodprobe_conf
	else 
		echo "modprobe.conf is here"
		functmodprobe_conf
	fi
echo "Modprobe configured"
#####End of Disable/Remove Unnecessary Services#####



echo "END of DISABLE/REMOVE UNNECESSARY SERVICES"



#####Restrict System Access from Servers and Networks (Firewall)#####
sudo ufw enable
sudo ufw deny ssh
sudo ufw deny telnet
sudo ufw deny smtp
sudo ufw deny dns
sudo ufw deny http
sudo sed -i '$ a\ALL : ALL' /etc/hosts.deny
#####End of Restrict System Access from Servers and Networks (Firewall)#####



echo "END of RESTRICT SYSTEM ACCESS FROM SERVERS AND NETWORKS (FIREWALL)"



#####Restricting su Access to System and Shared Accounts#####
sudo chmod 700 /bin/su
#####End of Restricting su Access to System and Shared Accounts#####



echo "END of RESTRICTING SU ACCESS TO SYSTEM AND SHARED ACCOUNTS"



#####Kernel Tunable Security Parameters#####
sudo bash -c 'echo "# Controls IP packet forwarding
net.ipv4.ip_forward = 0
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1
# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
# Block SYN attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1
# Accept Redirects? No, this is not router
net.ipv4.conf.all.secure_redirects = 0
# Log packets with impossible addresses to kernel log? yes
net.ipv4.conf.default.secure_redirects = 0
#Enable ExecShield protection
kernel.exec-shield = 1
kernel.randomize_va_space = 1
########## IPv6 networking start ##############
# Number of Router Solicitations to send until assuming no routers are present.
# This is host and not router
net.ipv6.conf.default.router_solicitations = 0
# Accept Router Preference in RA?
net.ipv6.conf.default.accept_ra_rtr_pref = 0
# Learn Prefix Information in Router Advertisement
net.ipv6.conf.default.accept_ra_pinfo = 0
# Setting controls whether the system will accept Hop Limit settings from a router advertisement
net.ipv6.conf.default.accept_ra_defrtr = 0
#router advertisements can cause the system to assign a global unicast address to an interface
net.ipv6.conf.default.autoconf = 0
#how many neighbor solicitations to send out per address?
net.ipv6.conf.default.dad_transmits = 0
# How many global unicast IPv6 addresses can be assigned to each interface?
net.ipv6.conf.default.max_addresses = 1
########## IPv6 networking ends ##############" >> /etc/sysctl.conf'
#disable IPv6
sudo bash -c 'echo "#disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'
#Apply Changes
sudo sysctl -p
echo "Sysctl configured"
#####End Kernel Tunable Security Parameters#####



echo "END of KERNEL TUNABLE SECURITY PARAMETERS"



#####Remote Desktop#####
sudo sed -i '$ a\greeter-show-remote-login=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
echo "Remote Desktop disabled"
#####End Remote Desktop#####



echo "END of REMOTE DESKTOP"



#####Hide User List#####
sudo sed -i '$ a\greeter-hide-users=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
sudo sed -i '$ a\greeter-show-manual-login=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
echo "User List Hidden"
#####End of Hide User List#####



echo "END of HIDE USER LIST"



#####Removable Media#####
	if [[ $(find /etc/modprobe.d/ -iname "usb-storage.conf") ]]; then
		sudo sed -i '$ a\install usb-storage /bin/true' /etc/modprobe.d/usb-storage.conf
	else 
		sudo touch /etc/modprobe.d/usb-storage.conf
		sudo sed -i '$ a\install usb-storage /bin/true' /etc/modprobe.d/usb-storage.conf
	fi
	
	if [[ $(find /etc/modprobe.d/ -iname "bluetooth.conf") ]]; then 
		sudo sed -i '$ a\install net-pf-31 /bin/true' /etc/modprobe.d/bluetooth.conf
		sudo sed -i '$ a\install bluetooth /bin/true' /etc/modprobe.d/bluetooth.conf
	else
		sudo touch /etc/modprobe.d/bluetooth.conf
		sudo sed -i '$ a\install net-pf-31 /bin/true' /etc/modprobe.d/bluetooth.conf
		sudo sed -i '$ a\install bluetooth /bin/true' /etc/modprobe.d/bluetooth.conf
	fi
#####End Removable Media#####



echo "END of REMOVABLE MEDIA"



#####Review Inittab and Boot Scripts######
sudo sed -i '/shutdown -r/s/^/#/g' /etc/init/control-alt-delete.conf
sudo sed -i '$ a\exec /usr/bin/logger -p security.info "Ctrl-Alt-Delete pressed"' /etc/init/control-alt-delete.conf
sudo touch /etc/inittab
sudo bash -c 'echo "id:3:initdefault:" >> /etc/inittab'
echo "Control-Alt-Delete disabled"
#####End of Review Inittab and Boot Scripts#####



echo "END of REVIEW INITTAB AND BOOT SCRIPTS"



#####Check File Permissions and Ownership#####
#Change permissions of /etc/passwd
sudo chgrp root /etc/passwd
sudo chmod 0644 /etc/passwd
#Change permissions of /etc/shadow
sudo chgrp root /etc/shadow
sudo chmod 0000 /etc/shadow
#Change permissions of /etc/gshadow
sudo chgrp root /etc/gshadow
sudo chmod 0000 /etc/gshadow
#/dev/null, /dev/tty, /dev/console should be world writable but never executable
sudo chmod 666 /dev/null
sudo chmod 666 /dev/tty
sudo chmod 666 /dev/console
#Library files must have mode 0755 or less permissive (/lib and /usr/lib)
sudo chmod go-w /lib
sudo chmod go-w /usr/lib
#All system command files must have mode 755 or less permissive, and owned by root
sudo chmod go-w /bin
sudo chmod go-w /usr/bin
sudo chmod go-w /usr/local/bin
sudo chmod go-w /sbin
sudo chmod go-w /usr/sbin
sudo chmod go-w /usr/local/sbin
sudo chown root:root /lib
sudo chown root:root /usr/lib
sudo chown root:root /bin
sudo chown root:root /usr/bin
sudo chown root:root /usr/local/bin
sudo chown root:root /sbin
sudo chown root:root /usr/sbin
sudo chown root:root /usr/local/sbin
#The system boot loader configuration file(s) must be owned and group-owned by root
sudo chown root:root /etc/grub.d
sudo chown root:root /etc/default/grub
sudo chown root:root /boot/grub/grub.cfg
sudo chmod 600 /etc/grub.d
sudo chmod 600 /etc/default/grub
sudo chmod 600 /boot/grub/grub.cfg
#Ensure all processes are audited
sudo sed -i '$ a\kernel /vmlinuz-version ro vga=ext root=/dev/VolGroup00/LogVol00 rhgb quiet audit=1' /boot/grub/grub.cfg
#Secure cron files 
sudo chmod 0700 /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* 
#/var/log/auth.log is owned by root
sudo chown /var/log/auth.log
#####End of Check File Permissions and Ownership#####



echo "END of CHECK FILE PERMISSIONS AND OWNERSHIP"



#####Check for Shellshock Bash Vulnerability#####
	if [[ $($bash | grep "Bash is vulnerable!") ]]; then 
		sudo apt-get update && sudo apt-get install --only-upgrade bash
	fi
#####End of Check for Shellshock Bash Vulnerability#####



echo "END of CHECK FOR SHELLSHOCK BASH VULNERABILITY"



#####Restrict Direct Login Access for System and Shared Accounts#####
sudo sed -i '/pam_access.so/s/^#//g' /etc/pam.d/login
sudo sed -i '$ a\-:ALL EXCEPT users :ALL' /etc/security/access.conf
#####End of Restrict Direct Login Access for System and Shared Accounts#####



echo "END of RESTRICT DIRECT LOGIN ACCESS FOR SYSTEM AND SHARED ACCOUNTS"



#####Prevent Accidental Denial of Service#####
#Enable IP Spoofing Protection
sudo sed -i '$ a\order bind,hosts' /etc/host.conf
sudo sed -i '$ a\nospoof on' /etc/host.conf
#Configure UFW
sudo sed -i '/COMMIT/d' /etc/ufw/before.rules
sudo bash -c 'echo "### Start HTTP ###
# Enter rule
-A ufw-before-input -p tcp --dport 80 -j ufw-http
-A ufw-before-input -p tcp --dport 443 -j ufw-http
# Limit connections per Class C
-A ufw-http -p tcp --syn -m connlimit --connlimit-above 50 --connlimit-mask 24 -j ufw-http-logdrop
# Limit connections per IP
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 10 --hitcount 20 -j ufw-http-logdrop
# Limit packets per IP
-A ufw-http -m recent --name pack_per_ip --set
-A ufw-http -m recent --name pack_per_ip --update --seconds 1 --hitcount 20 -j ufw-http-logdrop
# Finally accept
-A ufw-http -j ACCEPT
# Log
-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] "
-A ufw-http-logdrop -j DROP
### End HTTP ##
-A INPUT -p icmp -m limit --limit 6/s --limit-burst 1 -j ACCEPT
-A INPUT -p icmp -j DROP
COMMIT" >> /etc/ufw/before.rules'
#Disable IPv6 for firewall
sudo sed -i '/IPV6/c\IPV6=no' /etc/default/ufw
#Run
sudo ufw reload
#####End of Prevent Accidental Denial of Service#####



echo "END of PREVENT ACCIDENTAL DENIAL OF SERVICE"



#####Auditd#####
#	Install auditd
	if [[ $(dpkg -l | grep "auditd") ]]; then 
		echo "Auditd installed"
	else
		echo "Auditd is not installed"
		sudo apt-get install auditd audispd-plugins
	fi
#	Configure auditd
sudo bash -c 'echo "# first of all, reset the rules (delete all)
-D
# increase the buffers to survive stress events. make this bigger for busy systems.
-b 1024
# monitor unlink() and rmdir() system calls.
-a exit,always -S unlink -S rmdir
# monitor open() system call by Linux UID 1001.
-a exit,always -S open -F loginuid=1001
# monitor write-access and change in file properties (read/write/execute) of the following files.
-w /etc/group -p wa
-w /etc/passwd -p wa
-w /etc/shadow -p wa
-w /etc/sudoers -p wa
# monitor read-access of the following directory.
-w /etc/secret_directory -p r
# configure the system to audit execution of module management programs
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b32 -S init_module -S delete_module -k modules
# audit changing of file ownership (chown, fchown, fchownat)
-a always,exit -F arch=b32 -S chown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S chown -F auid=0 -k perm_mod 
# audit calls to "fchown" (file ownership)
-a always,exit -F arch=b32 -S fchown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchown -F auid=0 -k perm_mod 
# audit calls to "fchownat" (file ownership)
-a always,exit -F arch=b32 -S fchownat -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchownat -F auid=0 -k perm_mod
# audit calls to "lchown" (file ownership)
-a always,exit -F arch=b32 -S lchown -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lchown -F auid=0 -k perm_mod
# audit changing of file permissions (chmod, fchmod, fchmodat)
-a always,exit -F arch=b32 -S chmod -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S chmod -F auid=0 -k perm_mod
# audit calls to "fchmod" (file permissions)
-a always,exit -F arch=b32 -S fchmod -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchmod -F auid=0 -k perm_mod
# audit calls to "fchmodat" (file permissions)
-a always,exit -F arch=b32 -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fchmodat -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via fremovexattr
-a always,exit -F arch=b32 -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fremovexattr -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via fsetxattr
-a always,exit -F arch=b32 -S fsetxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S fsetxattr -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via lremovexattr
-a always,exit -F arch=b32 -S lremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lremovexattr -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via lsetxattr
-a always,exit -F arch=b32 -S lsetxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S lsetxattr -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via removexattr
-a always,exit -F arch=b32 -S removexattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S removexattr -F auid=0 -k perm_mod
# audit DAC modifications (file permissions) via setxattr
-a always,exit -F arch=b32 -S setxattr -F auid>=500 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S setxattr -F auid=0 -k perm_mod
# audit unsuccessful attempts to access files
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid=0 -k access 
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid=0 -k access
# audit_account_changes 
-w /etc/group -p wa -k audit_account_changes 
-w /etc/passwd -p wa -k audit_account_changes 
-w /etc/gshadow -p wa -k audit_account_changes 
-w /etc/shadow -p wa -k audit_account_changes 
-w /etc/security/opasswd -p wa -k audit_account_changes
# audit_network_modifications 
-a always,exit -F arch=ARCH -S sethostname -S setdomainname -k audit_network_modifications 
-w /etc/issue -p wa -k audit_network_modifications 
-w /etc/issue.net -p wa -k audit_network_modifications 
-w /etc/hosts -p wa -k audit_network_modifications 
-w /etc/sysconfig/network -p wa -k audit_network_modifications
# audit successful file system mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export
-a always,exit -F arch=b32 -S mount -F auid=0 -k export
# audit user deletions of files and programs
-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid=0 -k delete
# audit changes to the /etc/sudoers file
-w /etc/sudoers -p wa -k actions
# lock the audit configuration to prevent any modification of this file.
-e 2" > $file10'
#	auditd conf file
sudo bash -c 'echo "# make sure audit system alerts when audit storage volume approaches capacity
space_left_action = syslog
# the system should be configured to email the admin when disk space is low
space_left_action = email
# set log rotation by setting the total storage large enough
num_logs = 5
# log file size should be 6 MB or higher
max_log_file = 6
# ensure that log rotation occurs when a log file reaches its max size
max_log_file_action = rotate
# switch the system to single-user mode when available audit storage volume becomes dangerously low
admin_space_left_action = suspend
# audit storage action
disk_full_action = single
# audit disk error action
disk_error_action = single, halt
# set the account messages should be sent to
action_mail_acct = root" > /etc/audit/auditd.conf'
#####End of Auditd#####



echo "End of Auditd"



#####Secure the Console#####
#Only allow one terminal
sudo sed -i '/tty2/,/tty63/s/^/#/' /etc/securetty
#Restrict root logins to virtual console devices 
sudo sed -i '/vc/d' /etc/securetty
#Restrict root login from serial ports
sudo sed -i '/ttyS/d' /etc/securetty
#make sure only root can modify 
sudo chown root:root /etc/securetty
sudo chmod 0600 /etc/securetty
#####End of Secure the Console#####



echo "END of SECURE THE CONSOLE"



#####Secure Shared Memory#####
sudo sed -i '$ i\tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0' $file5
#####End of Secure Shared Memory#####



echo "END of SECURE SHARED MEMORY"



#####Umask Settings#####
#	umask bash
	if [[ $(grep -q "umask" "$file6") ]]; then
	    sudo sed -i '/umask/c\umask 077' "$file6"
	else 
	    bash -c 'echo "umask 077" >> "$file6"'
	fi
#	umask csh
	if [[ $(grep -q "umask" "$file7") ]]; then
	    sudo sed -i '/umask/c\umask 077' "$file7"
	else 
	    bash -c 'echo "umask 077" >> "$file7"'
	fi
#	umask profile
	if [[ $(grep -q "umask" "$file8") ]]; then
	    sudo sed -i '/umask/c\umask 077' "$file8"
	else 
	    bash -c 'echo "umask 077" >> "$file8"'
	fi
#	umask login.defs
sudo sed -i '/KILLCHAR/ a UMASK           077' "$file9"
sudo sed -i '$ a\umask 22' /lib/lsb/init-functions	
#####End of Umask Settings#####



echo "END of UMASK SETTINGS"



#####Host-Based Linux Monitering and Intrusion Detection#####
#Install PSAD
echo -n "Do you want to install PSAD? [y or n]"
read psadrep

case $psadrep in 
		y ) echo "PSAD will be installed"
			sudo apt-get install psad
			echo "PSAD is done installing"
			read -p "Press [Enter] key continue..."
		;;
		n ) echo "PSAD will not be installed"
			read -p "Press [Enter] key continue..."
esac

#	Add iptables log rules for both ipv4 and ipv6
sudo iptables -A INPUT -j LOG
sudo iptables -A FORWARD -j LOG
sudo ip6tables -A INPUT -j LOG
sudo ip6tables -A FORWARD -j LOG
#	Set the local firewall to implement a deny-all, allow-by exception policy for packets
sudo iptables -P INPUT DROP
sudo ip6tables -P INPUT DROP
#	Block furtive port scanner
sudo iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
#	Restart PSAD
sudo psad -R
sudo psad --sig-update
sudo psad -H
#Install Fail2Ban
echo -n "Do you want to install fail2ban? [y or n]"
read fbrep

case $fbrep in 
		y ) echo "fail2ban will be installed"
			sudo apt-get install fail2ban
			echo "fail2ban is done installing"
			read -p "Press [Enter] key continue configuration..."
			functfail2ban_conf
			sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
			sudo service fail2ban restart
		;;
		n ) echo "fail2ban will not be installed"
			read -p "Press [Enter] key continue..."
esac
#AppArmour
echo -n "Do you want to install apparmor-profiles? [y or n]"
read aa

case $aa in 
		y ) echo "apparmor-profiles will be installed"
			sudo apt-get install apparmor-profiles
			echo "apparmor-profiles is done installing"
			read -p "Press [Enter] key continue..."
		;;
		n ) echo "apparmor-profiles will not be installed"
			read -p "Press [Enter] key continue..."
esac
#Clam AV
echo -n "Do you want to install clam av? [y or n]"
read cav

case $cav in 
		y ) echo "clamav will be installed"
			sudo apt-get install clamav
			echo "clamav is done installing"
			read -p "Press [Enter] key continue..."
		;;
		n ) echo "clamav will not be installed"
			read -p "Press [Enter] key continue..."
esac

echo -n "Do you want to install clamtk? [y or n]"
read ctk

case $ctk in 
		y ) echo "clamtk will be installed"
			sudo apt-get install clamtk
			echo "clamtk is done installing"
			read -p "Press [Enter] key continue..."
		;;
		n ) echo "clamtk will not be installed"
			read -p "Press [Enter] key continue..."
esac
#Aide
echo -n "Do you want to install aide? [y or n]"
read ade

case $ade in 
		y ) echo "aide will be installed"
			sudo apt-get install aide
			echo "aide is done installing"
			read -p "Press [ENTER] key continue..."
			sudo sed -i '/MAILTO/c\MAILTO = root' /etc/default/aide
		;;
		n ) echo "aide will not be installed"
			read -p "Press [ENTER] key continue..."
esac
#debsecan
echo -n "Do you want to install debsecan? [y or n]"
read debsec

case $debsec in
		y ) echo "debsecan will be installed"
		    sudo apt-get install debsecan
			echo "debsecan is done installing"
			read -p "Press [ENTER] key continue..."
		;;	
		n )	echo "debsecan will not be installed"
		    read -p "Press [ENTER] key continue..."
esac
#debsums
echo -n "Do you want to install debsums? [y or n]"
read debsums

case $debsums in 
		y ) echo "debsums will be installed"
		    sudo apt-get install debsums
			echo "debsums is done installing"
			read -p "Press [ENTER] key continue..."
		;;
		n ) echo "debsums will not be installed"
			read -p "Press [ENTER] key continue..."
#####End of Host-Based Linux Monitoring and Intrusion Detection#####



echo "END of HOST-BASED LINUX MONITORING AND INTRUSION DETECTION"



#####STIGS#####
#/etc/security/limits.conf
echo "do * hard core 0 for /etc/security/limits.conf"
echo "do * hard maxlogins 10 for /etc/security/limits.conf"
#SElinux
sudo sed -i '/selinux=0/d' /boot/grub/grub.conf
#Other Stuff
sudo sed -i '/INACTIVE/c\INACTIVE=35' /etc/default/useradd
sudo find -iname /etc/pam.d "pam_console.so*" -exec rm -rf {} \;
sudo find -iname /etc/security "console.perms" -exec rm -rf {} \;
#####End of STIGS#####

echo "END of STIGS"

echo "DANIEL YANG's LINUX SCRIPT IS FINISHED"
read -p "Press [Enter] key continue..."

#####End of Script#####