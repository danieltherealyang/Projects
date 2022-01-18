#!/bin/bash
#==============================================#
#                                              #              
#			    FILE=CPSSH.sh                  #
#         WRITTEN BY=DANIEL YANG               #
#        DESCRIPTION=Completes tasks on        #
#     the Cyber Patriot Checklist Website      #
#                                              #
#==============================================#

echo "DANIEL YANG is a boss"
echo "DANIEL YANG's LINUX SCRIPT 'CPAPACHE2.sh' IS ACTIVE"

#----------------------------------------

##### Beginning of Script #####
echo -n "Is SSH already installed? [y or n]"
read install

case $install in
		y ) echo "No need to install SSH"
			read -p "Press [Enter] key continue..."
			echo "Configuration will continue"
		;;
		n ) echo -n "Do you want to install Apache2 now? [y or n]"
			read installn
			
			case $installn in 
			y ) echo "SSH will be installed"
				sudo apt-get install ssh
				echo "SSH is done installing"
				read -p "Press [Enter] key continue..."
				echo "Configuration will continue"
			;;
			n ) echo "Ending script"
				exit
			esac
esac
sudo sed -i '/PermitRootLogin/c\PermitRootLogin no' /etc/ssh/sshd_config
sudo sed -i '/UsePrivilegeSeparation/c\UsePrivilegeSeparation yes' /etc/ssh/sshd_config
sudo sed -i '/Protocol/c\Protocol 2' /etc/ssh/sshd_config
sudo sed -i '/AllowTcpForwarding/c\ AllowTcpForwarding no' /etc/ssh/sshd_config
sudo sed -i '/X11Forwarding/c\X11Forwarding no' /etc/ssh/sshd_config
sudo sed -i '/StrictModes/c\StrictModes yes' /etc/ssh/sshd_config
sudo sed -i '/IgnoreRhosts/c\IgnoreRhosts yes' /etc/ssh/sshd_config
sudo sed -i '/HostbasedAuthentication/c\HostbasedAuthentication no' /etc/ssh/sshd_config
sudo sed -i '/RhostsRSAAuthentication/c\RhostsRSAAuthentication no' /etc/ssh/sshd_config
sudo sed -i '/Permit Empty Passwords/c\Permit Empty Passwords no' /etc/ssh/sshd_config
sudo sed -i '$ i\PermitUserEnvironment no' /etc/ssh/sshd_config
sudo sed -i '/PrintLastLog/c\PrintLastLog yes' /etc/ssh/sshd_config
sudo sed -i '/Password Authentication/c\Password Authentication no' /etc/ssh/sshd_config
sudo sed -i '/Port/c\Port 1022' /etc/ssh/sshd_config
sudo sed -i '/UseDNS/c\UseDNS no' /etc/ssh/sshd_config
sudo sed -i '/ClientAliveInterval/c\ClientAliveInterval 300' /etc/ssh/sshd_config
sudo sed -i '/ClientAliveCountMax/c\ClientAliveCountMax 0' /etc/ssh/sshd_config
sudo sed -i '/LoginGraceTime /c\LoginGraceTime 300' /etc/ssh/sshd_config
sudo sed -i '/MaxStartups/c\MaxStartups 2' /etc/ssh/sshd_config
sudo sed -i '/LogLevel/c\LogLevel VERBOSE' /etc/ssh/sshd_config
sudo sed -i '/Banner/c\Banner /etc/issue' /etc/ssh/sshd_config
sudo sed -i '$ i\Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

echo "SSH has been secured"

echo "DANIEL YANG's LINUX SCRIPT IS FINISHED"
read -p "Press [Enter] key continue..."

#####END of SCRIPT#####