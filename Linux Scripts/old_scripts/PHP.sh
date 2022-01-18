#!/bin/bash
echo -n "Is php5 already installed? [y or n]"
read answer

case $answer in 
		y ) echo "No need to install php5"
			read -p "Press [Enter] key continue..."
			echo "Configuration will continue..."
			;;
		n )
			echo -n "Do you want to install it now?"
			read response
				
			case $response in
			y ) sudo apt-get install php5
			;;
			n ) echo "Ending script"
				exit
			esac
esac
	
sudo sed -i 'display_errors =/c\display_errors = Off' /etc/php5/cli/php.ini
sudo sed -i 'session.cookie_httponly =/c\session.cookie_httponly = 1' /etc/php5/cli/php.ini
sudo sed -i 'register_globals =/c\register_globals = Off' /etc/php5/cli/php.ini
sudo sed -i 'allow_url_fopen =/c\allow_url_fopen = Off' /etc/php5/cli/php.ini
sudo sed -i 'allow_url_include =/c\allow_url_include = Off' /etc/php5/cli/php.ini
sudo sed -i 'file_uploads = Off/c\file_uploads = Off' /etc/php5/cli/php.ini	
sudo sed -i 'session.save_path =/c\session.save_path = /var/lib/php' /etc/php5/cli/php.ini
sudo sed -i 'session.cookie_httponly/c\session.cookie_httponly = 1' /etc/php5/cli/php.ini
sudo sed -i 'expose_php =/c\expose_php = Off' /etc/php5/cli/php.ini
sudo sed -i 'session.use_trans_sid =/c\session.use_trans_sid = 0' /etc/php5/cli/php.ini
sudo sed -i 'log_errors =/c\log_errors = On' /etc/php5/cli/php.ini
sudo sed -i 'error_log =/c\error_log = /var/log/httpd/php_scripts_error.log' /etc/php5/cli/php.ini
sudo sed -i 'sql.safe_mode =/c\sql.safe_mode = On' /etc/php5/cli/php.ini
sudo sed -i 'html_errors =/c\html_errors = Off' /etc/php5/cli/php.ini
sudo sed -i 'display_errors =/c\display_errors = Off' /etc/php5/apache2/php.ini
sudo sed -i 'session.cookie_httponly =/c\session.cookie_httponly = 1' /etc/php5/apache2/php.ini
sudo sed -i 'register_globals =/c\register_globals = Off' /etc/php5/apache2/php.ini
sudo sed -i 'allow_url_fopen =/c\allow_url_fopen = Off' /etc/php5/apache2/php.ini
sudo sed -i 'allow_url_include =/c\allow_url_include = Off' /etc/php5/apache2/php.ini
sudo sed -i 'file_uploads = Off/c\file_uploads = Off' /etc/php5/apache2/php.ini	
sudo sed -i 'session.save_path =/c\session.save_path = /var/lib/php' /etc/php5/apache2/php.ini
sudo sed -i 'session.cookie_httponly/c\session.cookie_httponly = 1' /etc/php5/apache2/php.ini
sudo sed -i 'expose_php =/c\expose_php = Off' /etc/php5/apache2/php.ini
sudo sed -i 'session.use_trans_sid =/c\session.use_trans_sid = 0' /etc/php5/apache2/php.ini
sudo sed -i 'log_errors =/c\log_errors = On' /etc/php5/apache2/php.ini
sudo sed -i 'sql.safe_mode =/c\sql.safe_mode = On' /etc/php5/apache2/php.ini
sudo sed -i 'error_log =/c\error_log = /var/log/httpd/php_scripts_error.log' /etc/php5/apache2/php.ini
sudo sed -i 'html_errors =/c\html_errors = Off' /etc/php5/apache2/php.ini
echo "Script is finished"