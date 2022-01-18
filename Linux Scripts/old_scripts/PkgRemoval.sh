#!/bin/bash

#==============================================#
#                                              #
#			FILE=PkgRemoval.SH                 #
#         WRITTEN BY=DANIEL YANG               #
#    DESCRIPTION=Removes Vulnerable Packages   #
#              and hacking tools               #
#                                              #
#==============================================#

echo "DANIEL YANG is a boss"
echo "DANIEL YANG's LINUX SCRIPT 'PkgRemoval.sh' IS ACTIVE"

#----------------------------------------


declare -a array=( john 
                   hydra 
				   php5
				   netcat
				   netcat-traditional
				   wireshark
                   openldap-servers 
                   openswan
                   xinetd 
                   ruby 
				   telnet
                   rails
                   httpry 
                   nginx
                   vsftpd 
                   ftp  
                   frostwire 
                   vuze 
                   samba
                   nikto 
                   apache2 
                   postgresql
                 )
# Scan
for i in "${array[@]}"
do 
if [[ "$(dpkg -l | grep $i)" ]]; then 
echo "$i is installed"
fi 
done

echo -n "Do you want to remove the package(s) [y or n]"
read answer

case $answer in 
	y ) until [[ $response = "none" ]]
        do 
        echo -n "Which package to remove? Type the package name. Type 'none' to end script."
        read response 
		    
			case $response in
            none ) exit
            esac 
			
        sudo apt-get --purge autoremove $response
done
	;;
	n ) exit
esac