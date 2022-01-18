#!/bin/bash

#==============================================#
#                                              #              
#			    FILE=CPApache2.sh              #
#         WRITTEN BY=DANIEL YANG               #
#        DESCRIPTION=Completes tasks on        #
#     the Cyber Patriot Checklist Website      #
#                                              #
#==============================================#

echo "DANIEL YANG is a boss"
echo "DANIEL YANG's LINUX SCRIPT 'CPAPACHE2.sh' IS ACTIVE"

#----------------------------------------

##### Beginning of Script #####
echo -n "Is Apache2 already installed? [y or n]"
read install

case $install in
		y ) echo "No need to install Apache2"
			read -p "Press [Enter] key continue..."
			echo "Configuration will continue"
		;;
		n ) echo -n "Do you want to install Apache2 now? [y or n]"
			read installn
			
			case $installn in 
			y ) echo "Apache2 will be installed"
				sudo apt-get install apache2
				echo "Apache2 is done installing"
				read -p "Press [Enter] key continue..."
				echo "Configuration will continue"
			;;
			n ) echo "Ending script"
				exit
			esac
esac
#####Disable Version Signature#####
sudo sed -i '$ a\ServerSignature Off' /etc/apache2/conf-enabled/security.conf
sudo sed -i '$ a\ServerTokens Prod' /etc/apache2/conf-enabled/security.conf
#####END of Disable Version Signature#####
echo "END of DISABLE VERSION SIGNATURE"
#####SSLv3 support disabled#####
sudo sed -i '/SSLProtocol all -SSLv2/c\SSLProtocol all -SSLv2 -SSLv3' /etc/apache2/mods-available/ssl.conf
#####END of SSLv3 support disabled#####
echo "END of SSLv3 SUPPORT DISABLED"
#####Mod Security/Evasive#####
#	Mod Security
echo -n "Do you want to install libapapache2-modsecurity? [y or n]"
read answer

case $answer in
		y ) echo "Libapache2-modsecurity will be installed" 
			sudo apt-get install libapache2-modsecurity
			echo "Libapache2-modsecurity has finished installing"
			echo "Modsec will be configured"
			sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
			sudo sed -i '/SecRuleEngine/c\SecRuleEngine On' /etc/modsecurity/modsecurity.conf
			sudo sed -i '/SecRequestBodyLimit/c\SecRequestBodyLimit 1638400' /etc/modsecurity/modsecurity.conf
			sudo sed -i '/SecRequestBodyInMemoryLimit/c\SecRequestBodyInMemoryLimit 1638400' /etc/modsecurity/modsecurity.conf
			sudo sed -i '/SecResponseBodyAccess/c\SecResponseBodyAccess Off' /etc/modsecurity/modsecurity.conf
			sudo a2enmod mod-security
			echo "Modsec is done configuring"
		;;
		n ) echo "Libapache2-modsecurity was not installed"
esac
read -p "Press [Enter] key continue..."
#Mod Evasive
echo -n "Do you want to install libapache2-modevasive? [y or n]"
read evasiveans
case $evasiveans in 
		y ) echo "Libapache2-modevasive will be installed"
			sudo apt-get install libapache2-mod-evasive
			echo "Libapache2-modevasive has finished installing"
			echo "Modev will be configured"
			touch /var/log/apache2/mod_evasive.log
			sudo chown www-data:www-data /var/log/apache2/mod_evasive.log
			sudo sed -i '/DOSHashTableSize/c\DOSHashTableSize 309' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSPageCount/c\DOSPageCount 10' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSSiteCount/c\DOSSiteCount 30' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSPageInterval/c\DOSPageInterval 1' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSSiteInterval/c\DOSSiteInterval  3' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSBlockingPeriod/c\DOSBlockingPeriod  3600' /etc/apache2/mods-available/evasive.conf
			sudo sed -i '/DOSLogDir/c\DOSLogDir /var/log/apache2/mod_evasive.log' /etc/apache2/mods-available/evasive.conf
		 	sudo a2enmod mod-evasive
			echo "Modev is done configuring"
		;;
		n ) echo "Libapache2-modevasive was not installed"
esac
read -p "Press [Enter] key continue..."
#####END of MOD SECURITY/EVASIVE#####
echo "END of MOD SECURITY/EVASIVE"
#####Access#####
sudo bash -c 'echo "<Directory />
	Options none
	Order deny,allow
	Deny from all
	Allow from [required group]
	</Directory>" >> /etc/apache2/apache2.conf'
#####END of ACCESS#####
echo "END of ACCESS"
#####ETC#####
#	Symlinks
sudo bash -c 'echo "Options -FollowSymLinks" >> /etc/apache2/apache2.conf'
echo "END of SYMLINKS"
#	Request size
sudo bash -c 'echo "<Directory [directory]>
LimitRequestBody 512000
</Directory>" >> /etc/apache2/apache2.conf'
echo "END of REQUEST SIZE"
#	Loglevel warn
sudo sed -i "/LogLevel/c\LogLevel warn" /etc/apache2/apache2.conf
echo "END of LOGLEVEL WARN"
#####END of ETC##### 
echo "End of ETC"
#####Modsecurity#####

#Restart Apache
sudo /etc/init.d/apache2 restart
#END of RESTART APACHE

echo "Apache has been secured" 

echo "DANIEL YANG's LINUX SCRIPT IS FINISHED"
read -p "Press [Enter] key continue..."

#####End of Script#####