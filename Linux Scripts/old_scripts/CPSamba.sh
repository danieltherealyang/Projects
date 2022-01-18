#!/bin/bash

#==============================================#
#                                              #              
#			    FILE=CPSamba.sh                #
#         WRITTEN BY=DANIEL YANG               #
#        DESCRIPTION=Completes tasks on        #
#     the Cyber Patriot Checklist Website      #
#                                              #
#==============================================#

echo "DANIEL YANG is a boss"
echo "DANIEL YANG's LINUX SCRIPT 'CPSamba2.sh' IS ACTIVE"

#----------------------------------------

##### Beginning of Script #####
echo -n "Is Samba already installed? [y or n]"
read install

case $install in
		y ) echo "No need to install Samba"
			read -p "Press [Enter] key continue..."
			echo "Configuration will continue"
		;;
		n ) echo -n "Do you want to install Samba now? [y or n]"
			read installn
			
			case $installn in 
			y ) echo "Samba will be installed"
				sudo apt-get install samba
				echo "Samba is done installing"
				read -p "Press [Enter] key continue..."
				echo "Configuration will continue"
			;;
			n ) echo "Ending script"
				exit
			esac
esac
#####Mod#####
sudo sed -i '/[global]/a\client signing = mandatory' /etc/samba/smb.conf 
sudo sed -i '/[global]/a\guest ok = no' /etc/samba/smb.conf
sudo sed -i '/[global]/a\encrypt passwords = yes' /etc/samba/smb.conf
echo "Script is finished"
read -p "Press [Enter] key continue..."