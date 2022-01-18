#!/bin/bash

#==============================================#
#                                              #
#			  FILE = CPMYSQL.SH                #   
#       WRITTEN BY = DANIEL YANG               #
#             TASK = Secures MYSQL             #
#                                              #
#==============================================#

echo "DANIEL YANG is the best"
echo "DANIEL YANG's LINUX SCRIPT 'CPMYSQL.sh' IS ACTIVE"

#####INFO#####
#Use CHROOT
#Stop Local Files from Being Loaded
#Set Bind Address to Standard
#Changes Log Settings
#Makes MYSQL Directories Not World Readable
#####END of INFO#####

#----------------------------------------

#====MANUAL STEPS (READ THIS)====#
#                                #
#Run: mysql -u root -p           #
#                                #
#Will see table as output        #
#with three columns-user, host,  #
#password                        #
#                                #
#Set password for all non-root   #
#users                           #
#                                #
#Set host to "localhost"for all  #
#non-root users                  #
#                                #
#Delete blank users where user=""#
#                                #
#After making changes,           #
#FLUSH PRIVILEGES;               #
#                                #
#================================#

#----------------------------------------

#####Beginning of Script#####
echo -n "Is MySQL already installed? [y or n]"
read answer

case $answer in 
		y ) echo "No need to install MySQL"
			read -p "Press [Enter] key continue..."
			echo "Configuration will continue"
		;;
		n ) echo -n "Do you want to install MySQL now? [y or n]"
			read installn
			
			case $installn in 
			y ) echo "MySQL will be installed"
				sudo apt-get install mysql-server
				echo "MySQL is done installing"
				read -p "Press [Enter] key continue..."
				echo "Configuration will continue"
			;;
			n ) echo "Ending script"
				exit
			esac
esac
#####Use CHROOT#####
sudo sed -i "/socket/c\socket		= /var/chroot/mysql" /etc/mysql/my.cnf
#####END of CHROOT#####
echo "END of CHROOT"
#####STOP LOCAL FILES FROM BEING LOADED#####
sudo sed -i "/mysqld/a\local-infile    = 0" /etc/mysql/my.cnf
#####END of STOP LOCAL FILES FROM BEING LOADED#####
echo "END of STOP LOCAL FILES FROM BEING LOADED"
#####SET BIND ADDRESS#####
sudo sed -i "/bind-address/c\bind-address		= 127.0.0.1" /etc/mysql/my.cnf
#####END of SET BIND ADDRESS#####
echo "END of SET BIND ADDRESS"
#####LOGS#####
sudo sed -i "/log=/c\log=/var/log/mysql-logfile" /etc/mysql/my.cnf
#####END of LOGS#####
echo "END of LOGS"
sudo sed -i '/slow-query-log/s/^#//g' /etc/mysql/my.cnf
sudo sed -i '/slow-query-log-file/s/^#//g' /etc/mysql/my.cnf
sudo sed -i '/long_query_time/s/^#//g' /etc/mysql/my.cnf
sudo service mysql restart
sudo tail -f /var/log/mysql/mysql-slow.log
echo -n "Do you want to make MYSQL restart automatically? [y or n]"
read restartsql

case $resartsql in
		y ) sudo touch /home/$USER/mysql-check.sh
			sudo bash -c 'echo "#!/bin/bash
/usr/bin/mysqladmin ping"' | grep 'mysqld is alive' > /dev/null 2>&1
if [ $? != 0 ]
then
    sudo service mysql restart
fi > /home/$USER/mysql-check.sh
sudo chmod +x /home/$USER/mysql-check.sh
sudo sed -i '$ a\* * * * * sh -x /home/$USER/mysql-check.sh' /etc/crontab
		;;
		n ) echo "Task will not be created"
esac
#####READABILITY#####
sudo ls -l /var/log/mysql*
#####END of READABILITY#####
echo "END of READABILITY"

echo "DANIEL YANG's LINUX SCRIPT IS FINISHED"
read -p "Press [Enter] key continue..."

#####End of Script#####