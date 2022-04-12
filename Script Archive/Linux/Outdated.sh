#!/bin/bash
#check if script is being run as root
if [ $UID -ne 0 ]; then
echo "You are too stupid to run this script"
exit 0
fi

#update repository
apt-get update

#CL: Authentication

sed -i '/^#/!s/PASS_MAX_DAYS/PASS_MAX_DAYS 90/g' /etc/login.defs
sed -i '/^#/!s/PASS_MIN_DAYS/PASS_MIN_DAYS 7/g' /etc/login.defs
sed -i '/^#/!s/PASS_WARN_AGE/PASS_WARN_AGE 14/g' /etc/login.defs
sed -i '/^#/!s/ENCRYPT_METHOD/ENCRYPT_METHOD SHA512/g' /etc/login.defs

if [ -e /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf ]; then
	if [ "$(grep allow-guest /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf)" != "" ]; then
	sed -i '/allow-guest/c\allow-guest=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
	else
	sed -i '$ a\allow-guest=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
	fi
fi

find / -iname '*hosts.equiv' -exec rm -f {} \;
find / -iname '*.rhosts' -exec rm -f {} \;

if [ -e /etc/pam_ldap.conf ]; then
	if [ "$(grep cert /etc/pam_ldap.conf)" = "" ]; then
	sed -i '$ a\tls_cacertdir /etc/pki/tls/CA' /etc/pam_ldap.conf
		if [ "$(grep ssl /etc/pam_ldap.conf)" != "" ]; then
		sed -i '/ssl/c\ssl start_tls' /etc/pam_ldap.conf
		else
		sed -i '$ a\ssl start_tls' /etc/pam_ldap.conf
		fi
	fi
fi

if [ -e /etc/pam.d/login ]; then
	if [ "$(grep pam_lastlog.so /etc/pam.d/login)" != *"showfailed"* ]; then
	sed -i '/pam_lastlog.so/c\session required pam_lastlog.so showfailed' /etc/pam.d/login
	fi
fi

echo "Authentication has been completed"

echo "Script will begin Disabling unnecessary services"
read -p "Press any key to continue"

if [ "$(dpkg -l | grep sysv-rc-conf)" = "" ]; then 
apt-get install sysv-rc-conf
fi

if [ "$(dpkg -l | grep telnet)" != "" ]; then 
apt-get purge telnet
fi

if [ "$(dpkg -l | grep rsh-server)" != "" ]; then 
apt-get purge rsh-server
fi

if [ "$(sysv-rc-conf --list | grep rstatd)" != "" ]; then
sysv-rc-conf rstatd off
fi

if [ "$(sysv-rc-conf --list | grep finger)" != "" ]; then
sysv-rc-conf finger off
fi

if [ "$(sysv-rc-conf --list | grep talk)" != "" ]; then
sysv-rc-conf talk off
sysv-rc-conf ntalk off
fi

if [ -e /etc/udev/rules.d/85-no-automount.rules ]; then
	sed -i '$ a\SUBSYSTEM=="usb", ENV{UDISKS_AUTO}="0"' /etc/udev/rules.d/85-no-automount.rules
	service udev restart
else
	touch /etc/udev/rules.d/85-no-automount.rules
	sed -i '$ a\SUBSYSTEM=="usb", ENV{UDISKS_AUTO}="0"' /etc/udev/rules.d/85-no-automount.rules
	service udev restart
fi

echo "manual" > /etc/init/avahi-daemon.override

if [ -e /etc/bluetooth/main.conf ]; then 
	if [ "$(< /etc/bluetooth/main.conf grep InitiallyPowered)" != "" ]; then 
	sed -i '/InitiallyPowered/c\InitiallyPowered = false' /etc/bluetooth/main.conf
	else
	sed -i '$ a\InitiallyPowered = false' /etc/bluetooth/main.conf
	fi
else 
	touch /etc/bluetooth/main.conf
	echo "InitiallyPowered = false" > /etc/init/cups.override
fi

echo "manual" > /etc/init/cups.override

if [ "$(dpkg -l | grep dovecot)" != "" ]; then
apt-get purge dovecot-*
fi

echo "manual" > /etc/init/modemmanager.override

if [ "$(dpkg -l | grep sendmail)" != "" ]; then
apt-get --purge autoremove sendmail
fi

echo -n "Is file sharing necessary [y or n]"
read nfserver
case $nfserver in
	y ) echo "nfs-server and tftp will not be removed"
		read -p "Press any key to continue"
	;;
	n ) apt-get purge nfs-kernel-server nfs-common portmap rpcbind
		if [ "$(sysv-rc-conf --list | grep tftp)" != "" ]; then
		sysv-rc-conf tftp off
		fi
		read -p "Press any key to continue"
esac

if [ -e /etc/default/whoopsie ]; then
	if [ "$(< /etc/default/whoopsie grep report_crashes)" != "" ]; then
	sed -i '/report_crashes/c\report_crashes=false' /etc/default/whoopsie
	else
	sed -i '$ a\report_crashes=false' /etc/default/whoopsie
	fi
else
touch /etc/default/whoopsie
sed -i '$ a\report_crashes=false' /etc/default/whoopsie
fi

if [ -e /etc/default/apport ]; then
	if [ "$(< /etc/default/apport grep enabled)" != "" ]; then
	sed -i '/enabled/c\enabled = 0' /etc/default/apport
	else 
	sed -i '$ a\enabled = 0' /etc/default/apport
	fi
else
touch /etc/default/apport
echo "enabled = 0" >> /etc/default/apport
fi 

if [ -e /etc/default/irqbalance ]; then
	if [ "$(< /etc/default/irqbalance grep ENABLED)" != "" ]; then
	sed -i '/ENABLED/c\ENABLED="0"' /etc/default/irqbalance
	else 
	sed -i '$ a\ENABLED="0"' /etc/default/irqbalance
	fi
fi

if [ "$(sysv-rc-conf --list | grep rlogin)" != "" ]; then
sysv-rc-conf rlogin off
fi

if [ "$(sysv-rc-conf --list | grep netconsole)" != "" ]; then
sysv-rc-conf netconsole off && service netconsole stop
fi

if [ ! -e /etc/modprobe.conf ]; then
touch /etc/modprobe.conf
fi

echo "install appletalk /bin/true
install sctp /bin/true 
install dccp /bin/true 
install dccp_ipv4 /bin/true
install dccp_ipv6 /bin/true
install rds /bin/true
install tipc /bin/true" >> /etc/modprobe.conf

if [ "$(ufw status | grep in)" != "" ]; then
ufw enable
fi

if [ "$(passwd --status root | grep L)" = "" ]; then
passwd -l root
fi

if [ -e /etc/sysctl.conf ]; then
echo "net.ipv4.ip_forward = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
kernel.exec-shield = 1
kernel.randomize_va_space = 1
net.ipv6.conf.default.router_solicitations = 0
net.ipv6.conf.default.accept_ra_rtr_pref = 0
net.ipv6.conf.default.accept_ra_pinfo = 0
net.ipv6.conf.default.accept_ra_defrtr = 0
net.ipv6.conf.default.autoconf = 0
net.ipv6.conf.default.dad_transmits = 0
net.ipv6.conf.default.max_addresses = 1
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
fi

if [ -e /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf ]; then
	if [ "$(< /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf grep greeter-show-remote-login)" != "" ]; then
	sed -i '/greeter-show-remote-login/c\greeter-show-remote-login=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
	else
	sed -i '$ a\greeter-show-remote-login=false' /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
	fi
fi

if [ -e /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf ]; then
	if [ "$(< /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf grep greeter-hide-users)" != "" ]; then
	sed -i '/greeter-hide-users/c\greeter-hide-users=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	else 
	sed -i '$ a\greeter-hide-users=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	fi
	
	if [ "$(< /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf grep greeter-show-manual-login)" != "" ]; then
	sed -i '/greeter-show-manual-login/c\greeter-show-manual-login=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	else
	sed -i '$ a\greeter-show-manual-login=true' /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	fi
fi

if [ -e /etc/modprobe.d/usb-storage.conf ]; then
echo "install usb-storage /bin/true" >> /etc/modprobe.d/usb-storage.conf
else 
touch /etc/modprobe.d/usb-storage.conf
fi

if [ -e /etc/modprobe.d/bluetooth.conf ]; then
echo "install net-pf-31 /bin/true" >> /etc/modprobe.d/bluetooth.conf
echo "install bluetooth /bin/true" >> /etc/modprobe.d/bluetooth.conf
else 
touch /etc/modprobe.d/bluetooth.conf
echo "install net-pf-31 /bin/true" >> /etc/modprobe.d/bluetooth.conf
echo "install bluetooth /bin/true" >> /etc/modprobe.d/bluetooth.conf
fi

if [ -e /etc/init/control-alt-delete.conf ]; then
sed -i '/exec shutdown -r now “Control-Alt-Delete pressed”/s/^/#/g' /etc/init/control-alt-delete.conf
touch /etc/init/control-alt-delete.override
sed -i '$ a\exec /usr/bin/logger -p security.info "Ctrl-Alt-Delete pressed"' /etc/init/control-alt-delete.conf
fi

touch /etc/inittab
echo "id:3:initdefault:" >> /etc/inittab

if [ "$(ls -l /etc/passwd | grep -e '–rw-r--r-- 1 root')" = "" ]; then
chgrp root /etc/passwd
chmod 0644 /etc/passwd
fi

if [ "$(ls -l /etc/shadow | grep -e '–--------- 1 root')" = "" ]; then
chgrp root /etc/shadow
chmod 0000 /etc/shadow
fi

if [ "$(ls -l /etc/gshadow | grep -e '–--------- 1 root')" = "" ]; then
chgrp root /etc/gshadow 
chmod 0000 /etc/gshadow
fi

declare -a devarray=(/dev/null /dev/tty /dev/console)
for i in "${devarray[@]}"
do 
	if [ "$(ls -l "$i" | grep -e '–rw-rw-rw- 1 root')" = "" ]; then
	chmod 666 "$i"
	fi
done

declare -a libarray=(/lib /usr/lib)
for i in "${libarray[@]}"
do
	declare -a libarrayarray=($(find "$i" -perm /022 -type f))
	for e in "${libarrayarray[@]}"
	do
	chmod go-w "$e"
	done
done

declare -a binarray=(/bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin)
for i in "${binarray[@]}"
do 
	declare -a binarrayarray=($(find "$i" -perm /022 -type f))
	for e in "${binarrayarray[@]}"
	do 
	chmod go-w "$e"
	done
	
	declare -a xbinarrayarray=($(find "$i" \! -user root))
	for e in "${xbinarrayarray[@]}"
	do
	chown root "$e"
	done
done

declare -a grubarray=(/etc/grub.d /etc/default/grub /boot/grub/grub.cfg)
for i in "${grubarray[@]}"
do
	declare -a grubarrayarray=($(ls -lL "$i" | grep -v 'root * root' | grep -v 'total' | grep -oE '[^ ]+$'))
	for a in "${grubarrayarray[@]}"
	do 
	chown root "$i"/"$a"
	chgrp root "$i"/"$a"
	done
	
	declare -a grubarrayarray2=($(ls -lL "$i" | grep -v '-rw-------' | grep -v 'total' | grep -oE '[^ ]+$'))
	for a in "${grubarrayarray2[@]}"
	do
	chmod 600 "$i"/"$a" 
	done
done

if [ -e /boot/grub/grub.cfg ]; then
echo "kernel /vmlinuz-version ro vga=ext root=/dev/VolGroup00/LogVol00 rhgb quiet audit=1" > /boot/grub/grub.cfg
fi

chmod 0700 /etc/cron*

if [ "$(env VAR='() { :;}; echo Bash is vulnerable!' bash -c "echo Bash Test" | grep "Bash is vulnerable!")" != "" ]; then
apt-get update && apt-get install --only-upgrade bash
fi 

if [ -e /etc/pam.d/login ]; then
sed -i '/pam_access.so/s/^#//g' /etc/pam.d/login
echo "-:ALL EXCEPT users :ALL" >> /etc/security/access.conf
fi

if [ "$(grep 'order hosts,bind' /etc/host.conf)" = "" ]; then
echo "order hosts,bind" >> /etc/host.conf
fi

if [ "$(grep 'nospoof on' /etc/host.conf)" = "" ]; then
echo "nospoof on" >> /etc/host.conf
fi

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

if [ "$(grep IPV6 /etc/default/ufw)" != "" ]; then
sed -i '/IPV6/c\IPV6=no' /etc/default/ufw
ufw reload
else 
echo "IPV6=no" >> /etc/default/ufw
ufw reload
fi

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

declare -a ttyarray=($(grep ^tty[1-9] /etc/securetty | grep -v tty1))
for i in ${ttyarray[@]}
do
sed -i "/^$i/s/^/#/g" /etc/securetty
done

if [ "$(grep ^vc/* /etc/securetty)" != "" ]; then
sed -i '/^vc\/*/d' /etc/securetty
fi

if [ "$(grep ^ttyS* /etc/securetty)" != "" ]; then
sed -i '/^ttyS*/d' /etc/securetty
fi

chown root:root /etc/securetty
chmod 0600 /etc/securetty

a=12.04
b=$(grep RELEASE /etc/lsb-release | cut -d = -f 2)
if (( $(echo "$b > $a" | bc -l) )); then
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab
else 
echo "tmpfs /dev/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab
fi

declare -a umaskarray=( ~/.bashrc /etc/csh.cshrc /etc/profile ) 
for i in ${umaskarray[@]} 
do
if [ -e $i ]; then 
	if [ "$(grep umask $i)" != "" ]; then
	sed -i '/umask/c\umask 077' $i
	else
	echo "umask 077" >> $i
	fi
fi
done

if [ -e /etc/login.defs ]; then
	if [ "$(grep UMASK /etc/login.defs)" != "" ]; then
	sed -i '/UMASK/c\UMASK 077' /etc/login.defs
	else
	echo "UMASK 077" >> /etc/login.defs
	fi
fi

if [ -e /lib/lsb/init-functions ]; then
	if [ "$(grep umask /lib/lsb/init-functions)" != "" ]; then
	sed -i '/umask/c\umask 022' /lib/lsb/init-functions
	else
	echo "umask 022" >> /lib/lsb/init-functions
	fi
fi

iptables -A INPUT -p ICMP --icmp-type timestamp-request -j DROP 
iptables -A INPUT -p ICMP --icmp-type timestamp-reply -j DROP
iptables -A INPUT -p icmpv6 -d ff02::1 --icmpv6-type 128 -j DROP 
iptables :FORWARD DROP [0:0] 
iptables :INPUT DROP [0:0]
iptables -A INPUT -p tcp --syn -j DROP
iptables -A INPUT -p tcp --syn --destination-port 22 -j ACCEPT
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -N LOGDROP
iptables -A INPUT -p tcp --syn --dport 25 -j ACCEPT
iptables -N port-scan
iptables -A port-scan -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j RETURN
iptables -A port-scan -j DROP
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m state --state NEW -m multiport --dports ssh,smtp,http,https -j ACCEPT
iptables -A INPUT -j LOG
iptables -A FORWARD -j LOG
ip6tables -A INPUT -j LOG
ip6tables -A FORWARD -j LOG
iptables -P INPUT DROP
ip6tables -P INPUT DROP
