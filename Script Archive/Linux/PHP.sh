#!/bin/bash
#check for root usage
if [ $UID -ne 0 ]; then 
echo "You are not root"
read -p "Press any key to continue..."
exit 0
fi

###Functions###

changeLine () { #changeLine "string" "new line" "file"
if test -e "$3"; then #test if file exists
	if grep -q "$1" "$3"; then #????? test if string is in file
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
sed -i "/$1/s/^/#/g" "$2" 
}

uncommentLine () { #uncommentLine "string" "file"
sed -i "/$1/s/^#//g" "$2"
}

php_ini_files=$(find / -iname 'php.ini')
declare -a php_ini_files
#error_log = /valid_path/PHP-logs/php_error.log
#doc_root                = /path/DocumentRoot/PHP-scripts/
#open_basedir            = /path/DocumentRoot/PHP-scripts/
#include_path            = /path/PHP-pear/
#extension_dir           = /path/PHP-extensions/
#mime_magic.magicfile 	  = /path/PHP-magic.mime
#upload_tmp_dir          = /path/PHP-uploads/
#session.save_path       = /path/PHP-session/

for i in "{$php_ini_files[@]}"
do
changeLine "expose_php =" "expose_php = Off" "$i"
changeLine "error_reporting =" "error_reporting = E_ALL" "$i"
changeLine "display_errors =" "display_errors = Off" "$i"
changeLine "display_startup_errors =" "display_startup_errors = Off" "$i"
changeLine "log_errors =" "log_errors = On" "$i"
changeLine "ignore_repeated_errors =" "ignore_repeated_errors = Off" "$i"
changeLine "allow_url_fopen =" "allow_url_fopen = Off" "$i"
changeLine "allow_url_include =" "allow_url_include = Off" "$i"
changeLine "variables_order =" "variables_order = \"GPSE\"" ""
changeLine "allow_webdav_methods =" "allow_webdav_methods = Off"
changeLine "register_globals =" "register_globals = Off" "$i"
changeLine "safe_mode =" "safe_mode = Off" "$i"
changeLine "session.gc_maxlifetime =" "session.gc_maxlifetime = 600" "$i"
changeLine "file_uploads =" "file_uploads = On" "$i"
changeLine "upload_max_filesize =" "upload_max_filesize = 2M" "$i"
changeLine "max_file_uploads =" "max_file_uploads = 2" "$i"
changeLine "enable_dl =" "enable_dl = On" "$i"
changeLine "disable_functions =" "disable_functions = system, exec, shell_exec, passthru, phpinfo, show_source, popen, proc_open, chdir, mkdir, rmdir, chmod, rename, filepro, filepro_rowcount, filepro_retrieve, posix_mkfifo" "$i"
changeLine "session.auto_start =" "session.auto_start = Off" "$i"
changeLine "session.hash_function =" "session.hash_function = 1" "$i"
changeLine "session.hash_bits_per_character =" "session.hash_bits_per_character = 6" "$i"
changeLine "session.use_trans_sid =" "session.use_trans_sid = 0" "$i"
changeLine "session.cookie_lifetime =" "session.cookie_lifetime = 0" "$i"
changeLine "session.cookie_secure =" "session.cookie_secure = On" "$i"
changeLine "session.cookie_httponly =" "session.cookie_httponly = 1" "$i"
changeLine "session.use_only_cookies =" "session.use_only_cookies = 1" "$i"
changeLine "session.cache_expire =" "session.cache_expire = 30" "$i"
changeLine "default_socket_timeout =" "default_socket_timeout = 60" "$i"
changeLine "memory_limit =" "memory_limit = 8M" "$i"
changeLine "post_max_size =" "post_max_size = 8M" "$i"
changeLine "max_execution_time =" "max_execution_time = 60" "$i"
changeLine "report_memleaks =" "report_memleaks = On" "$i"
changeLine "track_errors =" "track_errors = Off" "$i"
changeLine "html_errors =" "html_errors = Off" "$i"
done 