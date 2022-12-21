#!/bin/bash
#check if script is run as root
if [ $UID -ne 0 ]; then 
echo "You are not root"
read -p "Press any key to continue..."
exit 0
fi

#development
set -o errexit
set -o nounset
set -o xtrace

###Functions###

changeLine () { #changeLine "string" "new line" "file"
if test -e "$3"; then #test if file exists
	if [ -n "$(grep \"$1\" \"$3\")" ]; then #test if string is in file
		sed -i "/^#/!s/.*$1.*/$2/g" "$3" #replace line containing string
	else
		echo "$2" >> "$3" #if string not found, add to end of file
	fi	
else
	echo "$3 doesn't exist" #file does not exist
	sleep 1
	echo -n "Do you want to create file for configuration? [y or n] : " 
	read createFileresponse
		case $createFileresponse in 
		y ) touch "$3" #if y, create file and add line to end of file
			echo "$2" >> "$3"
		;;
		n ) echo "Skipping.........." #if n, skip the configuration
			sleep 1
		esac
	clear
fi
}

commentLine () { #commentLine "string" "file"
sed -i "/$1/s/^/#/g" $2 
}

uncommentLine () { #uncommentLine "string" "file"
sed -i "/$1/s/^#//g" $2
}
#Authentication
	#skipped all pam.d files because too risky

	#/etc/login.defs
sed -i '/^#/!s/PASS_MAX_DAYS.*/PASS_MAX_DAYS	90/g' /etc/login.defs
sed -i '/^#/!s/PASS_MIN_DAYS.*/PASS_MIN_DAYS	7/g' /etc/login.defs
sed -i '/^#/!s/PASS_WARN_AGE.*/PASS_WARN_AGE	14/g' /etc/login.defs
sed -i '/^#/!s/ENCRYPT_METHOD.*/ENCRYPT_METHOD SHA512/g' /etc/login.defs

	#disable Guest
changeLine "allow-guest=" "allow-guest=false" "/usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf"
	
#Manual_password hashes

	#disable shell accounts
until [ "$shellAcct" = "done" ]; do
	clear
	cat /etc/passwd | egrep -v '\/false|\/nologin|\/shutdown|\/halt' |cut -d':' -f 1,7
	read -p "These accounts are active"
	echo -n "Disable Account ('done' to end): "
	read shellAcct
		if [ "$shellAcct" != "done" ]; then
		usermod -s /usr/sbin/nologin "$shellAcct"
		fi
done

	#disable wellknown accounts
passwd -l bin
passwd -l sys
passwd -l uucp

#Manual_check UID 0

	#hosts.equiv and .rhosts files
hostsEquiv=$(find / -iname '*hosts.equiv' -o -iname '*.rhosts')
declare -a hostsEquiv
if [ -n "${hostsEquiv[*]}" ]; then
	for i in "${hostsEquiv[@]}" 
	do
	rm $i
	done
fi

#Manual_/etc/pam_ldap.conf

	#/etc/pam.d/login
changeLine "pam_lastlog.so" "session required pam_lastlog.so showfailed" "/etc/pam.d/login"

#Manual_delete xinetd + xinetd services
#/etc/init.d/xinetd status
#chkconfig --list | awk '/xinetd based services/,/""/'
#sysv-rc-conf <service> off

#Disable/Remove Services
bannedServices=$(dpkg -l | egrep -i "telnet|ftpd|rsh-server|rstatd|finger|talk|rexec|rlogin|tftp|netconsole|dovecot-*|sendmail|nfs-|portmap|rpcbind|snmp")
declare -a bannedServices


if [ -n "${bannedServices[*]}" ]; then 
	for i in "${bannedServices[@]}" 
	do 
	apt-get purge $i
	clear
	done
fi
	
	#autofs
changeLine "SUBSYSTEM==\"usb\"" "SUBSYSTEM==\"usb\", ENV{UDISKS_AUTO}=\"0\"" "/etc/udev/rules.d/85-no-automount.rules"

	#avahi
echo "manual" > /etc/init/avahi-daemon.override

	#bluetooth
changeLine "InitiallyPowered" "InitiallyPowered = false" "/etc/bluetooth/main.conf"

	#cups
echo "manual" >> /etc/init/cups.override

	#modemmanager
echo "manual" > /etc/init/modemmanager.override

	#whoopsie
changeLine "report_crashes" "report_crashes=false" "/etc/default/whoopsie"

	#apport
changeLine "enabled" "enabled = 0" "/etc/default/apport"

	#irqbalance
changeLine "ENABLED" "ENABLED=\"0\"" "/etc/default/irqbalance"

	#AppleTalk, SCTP, DCCP, RDS, TIPC
echo "install appletalk /bin/true" >> /etc/modprobe.conf
echo "install sctp /bin/true" >> /etc/modprobe.conf
echo "install dccp /bin/true" >> /etc/modprobe.conf 
echo "install dccp_ipv4 /bin/true" >> /etc/modprobe.conf 
echo "install dccp_ipv6 /bin/true" >> /etc/modprobe.conf
echo "install rds /bin/true" >> /etc/modprobe.conf 
echo "install tipc /bin/true" >> /etc/modprobe.conf

#Firewall
ufw enable

#Restriction su Access to System and Shared Accounts
passwd -l root
chmod 700 /bin/su

#Manual_sudo visudo

#Kernal Tunable Security Parameters
echo "# Controls IP packet forwarding
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
########## IPv6 networking ends ##############
#disable ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >>  /etc/sysctl.conf

sysctl -p

#Remote Desktop
changeLine "greeter-show-remote-login" "greeter-show-remote-login=false" "/usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf"

#Hide User List
changeLine "greeter-hide-users" "greeter-hide-users=true" "/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf"
changeLine "greeter-show-manual-login" "greeter-show-manual-login" "/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf"

#Removable Media
	#disable USB storage detection
changeLine "install usb-storage" "install usb-storage /bin/true" "/etc/modprobe.d/usb-storage.conf"
	#disable bluetooth
changeLine "install net-pf-31" "install net-pf-31 /bin/true" "/etc/modprobe.d/bluetooth.conf"
changeLine "install bluetooth" "install bluetooth /bin/true" "/etc/modprobe.d/bluetooth.conf"

#Review Inittab and boot scripts
	#disable Ctrl-alt-Delete to prevent accidental reboots
commentLine "exec shutdown -r now \"Control-Alt-Delete pressed\"" "/etc/init/control-alt-delete.conf"
changeLine "\"Ctrl-Alt-Delete pressed\"" "exec /usr/bin/logger -p security.info \"Ctrl-Alt-Delete pressed\"" "/etc/init/control-alt-delete.override"

	#disable X Windowing
touch /etc/inittab
changeLine "id:3" "id:3:initdefault:" "/etc/inittab"

#File Permissions
	#/etc/passwd
chgrp root /etc/passwd
chmod 0644 /etc/passwd
	#/etc/shadow
chgrp root /etc/shadow
chmod 0000 /etc/shadow
	#/etc/gshadow
chgrp root /etc/gshadow
chmod 0000 /etc/gshadow
	#dev files
chmod 666 /dev/null
chmod 666 /dev/tty
chmod 666 /dev/console
	#lib
chmod go-w -R /lib 
chmod go-w -R /usr/lib 
	#bins
declare -a bins=(/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin)
for i in "${bins[@]}"
do
chmod go-w -R $i
chown -R root $i
done
	#grubs
declare -a grubs=(/etc/grub.d /etc/default/grub /boot/grub/grub.cfg)
for i in "${grubs[@]}"
do 
chown -R root $i
chgrp -R root $i
chmod 600 $i
done
	#grub.cfg
changeLine "kernel /vmlinuz-version" "kernel /vmlinuz-version ro vga=ext root=/dev/VolGroup00/LogVol00 rhgb quiet audit=1" "/boot/grub/grub.cfg"
chmod 0700 /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* 

#Check for Shellshock Bash Vulnerability
if [ -n "$(env VAR='() { :;}; echo Bash is vulnerable!' bash -c "echo Bash Test" | grep "vulnerable")" ]; then
apt-get update && apt-get install --only-upgrade bash
fi

#Restrict Direct Login Access for System and Shared Accounts
uncommentLine "pam_access.so" "/etc/pam.d/login"
changeLine "-:ALL" "-:ALL EXCEPT users :ALL" "/etc/security/access.conf"

#Prevent Accidental DoS
changeLine "order" "order bind,hosts" "/etc/host.conf"
changeLine "nospoof" "nospoof on" "/etc/host.conf"

sed -i '/*filter/a\:ufw-http - [0:0]' /etc/ufw/before.rules
sed -i '/*filter/a\:ufw-http-logdrop - [0:0]' /etc/ufw/before.rules
sed -i '/^#/!s/COMMIT//g' /etc/ufw/before.rules
echo '-A ufw-before-input -p tcp --dport 80 -j ufw-http
-A ufw-before-input -p tcp --dport 443 -j ufw-http
-A ufw-http -p tcp --syn -m connlimit --connlimit-above 50 --connlimit-mask 24 -j ufw-http-logdrop
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --set
-A ufw-http -m state --state NEW -m recent --name conn_per_ip --update --seconds 10 --hitcount 20 -j ufw-http-logdrop
-A ufw-http -m recent --name pack_per_ip --set
-A ufw-http -m recent --name pack_per_ip --update --seconds 1 --hitcount 20 -j ufw-http-logdrop
-A ufw-http -j ACCEPT
-A ufw-http-logdrop -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW HTTP DROP] "
-A ufw-http-logdrop -j DROP
-A INPUT -p icmp -m limit --limit 6/s --limit-burst 1 -j ACCEPT
-A INPUT -p icmp -j DROP
COMMIT' >> /etc/ufw/before.rules

	#ipv6 firewall
changeLine "IPV6" "IPV6=no" "/etc/default/ufw"
ufw reload

#OpenSSL Heartbleed
mydate=$(openssl version -v | cut -d " " -f 3,4,5)
year=$(date -d "$mydate" "+%Y")
month=$(date -d "$mydate" "+%m") 
day=$(date -d "$mydate" "+%d") 
sslver="$year$month$day"
if (( $(echo "$sslver < 20140407" | bc -l) )); then
apt-get update 
curl https://www.openssl.org/source/openssl-1.0.2l.tar.gz | tar xz && cd openss$
ln -sf /usr/local/ssl/bin/openssl `which openssl`
fi

#Secure the console
ttyNum=$(grep "tty[1-9]" /etc/securetty | grep -v tty1)
declare -a ttyNum
for i in "${ttyNum[@]}"
do
commentLine "$i" "/etc/securetty"
done

if [ -n "$(grep \"^vc/*\" /etc/securetty)" ]; then
sed -i '/^vc\/*/d' /etc/securetty
fi

if [ -n "$(grep \"^ttyS*\" /etc/securetty)" ]; then
sed -i '/^ttyS*/d' /etc/securetty
fi

chown root:root /etc/securetty
chmod 0600 /etc/securetty

#Secure Shared Memory
changeLine "tmpfs /run/shm" "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" "/etc/fstab"

#Secure /tmp and /var/tmp
	#tmp
dd if=/dev/zero of=/usr/tmpDSK bs=1024 count=1024000
cp -Rpf /tmp /tmpbackup
mount -t tmpfs -o loop,noexec,nosuid,rw /usr/tmpDSK /tmp
chmod 1777 /tmp
cp -Rpf /tmpbackup/ /tmp/
rm -rf /tmpbackup/
changeLine "/usr/tmpDSK" "/usr/tmpDSK /tmp tmpfs loop,nosuid,noexec,rw 0 0" "/etc/fstab"
mount -o remount /tmp
	#/var/tmp
mv /var/tmp /var/tmpold
ln -s /tmp /var/tmp
cp -prf /var/tmpold/ /tmp/

#Umask Settings
bashrcArray=$(find / -iname ".bashrc")
declare -a bashrcArray

for i in "${bashrcArray[@]}"
do 
changeLine "umask 077" "$i"
done

changeLine "umask 077" "/etc/csh.cshrc"
changeLine "UMASK 077" "/etc/login.defs"
changeLine "umask 027" "/lib/lsb/init-functions"

#STIGS
changeLine "iface" "iface 0 inet static" "/etc/network/interfaces"
changeLine "core" "* hard core 0" "/etc/security/limits.conf"
changeLine "maxlogins" "* hard maxlogins 10" "/etc/security/limits.conf"
changeLine "INACTIVE" "INACTIVE=35" "/etc/default/useradd"
if [ -e "/etc/security/console.perms" ]; then
rm /etc/security/console.perms
fi 