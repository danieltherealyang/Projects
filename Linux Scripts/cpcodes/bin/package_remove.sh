#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

CheckConfigureFileYesno() {
  read -p "Have you double checked the configuration file $1 against README (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}

CheckYesno() {
  read -p "Remove package $1 (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}

readToArray(){
    tmpfile=$1;
    unset tmparray
    count=0;
    while read oneline
    do
        echo "$oneline"|grep -P "^\s*#|^\s*$" >/dev/null 2>&1
        if [ ! $? -eq 0 ]; then
          tmparray[$count]="$oneline"
          count=`expr $count + 1`
        fi
    done < $tmpfile

    for ((rtaj=0;rtaj<${#tmparray[@]};rtaj++)); do
        tmpdir=${tmparray[$rtaj]}
        tmpexist="n";
        for ((rtai=0;rtai<${#myarray[@]};rtai++)); do
            dir=${myarray[$rtai]}
            if [ "$tmpdir" = "$dir" ]; then
                tmpexist="y";
                break;
            fi
        done
        if [ "$tmpexist" = "n" ]; then
            myarray[${#myarray[@]}]="${tmparray[$rtaj]}";
        fi
    done
}

getConfigurationArray(){
    unset myarray
    myfile=$1;
    if [ -f $myfile ]; then
        readToArray $myfile
    fi
}

removePackage() {
  package_name=$@
  dpkg --get-selections "$package_name" 2>/dev/null | grep install > /dev/null
  #dpkg -s $package_name | grep Status | grep install
  if [ "X$?" = "X0" ]; then
#    CheckYesno "$package_name"
#    if [ "X$?" = "X0" ]; then
      echo "Remove $package_name"
      apt-get -y --purge autoremove "$package_name"
#    fi
  fi
}

# check if current user is root
# Please do not change the following lines
############################################
current_user=$(whoami)
if [ "X$current_user" != "Xroot" ]; then
  echo "$0 MUST be run as root"
  exit 1
fi

# figure out the configuration file
# Please do not change the following lines
############################################
program_name=$(basename $0 | sed -s 's/.sh$//g')
if [ "X$top_dir" = "X" ]; then
  top_dir=$(dirname $0);
  if [ "X$top_dir" = "X." ]; then
    top_dir=$PWD
  fi
  configure_file=$top_dir/.${program_name}.config
fi
############################################

echo "Use configuration file: $configure_file"
#CheckConfigureFileYesno $configure_file
#if [ ! "X$?" = "X0" ]; then
#  echo "Abort and please check $configure_file against README and try against."
#  exit 1
#fi

getConfigurationArray $configure_file

rm -f /var/cache/apt/archives/lock

for ((i=0;i<${#myarray[@]};i++)); do
  package_name=${myarray[$i]}
  removePackage $package_name
done

echo "#---------------------------------"
echo "#  Attention please"
echo "#---------------------------------"

#itemgroups=(
#sambashare
#smmta smmsp
#ssh
#ssh
#telnet
#snmp
#mysql
#php5
#apache2
#)

items=(
samba
sendmail
openssh-server
openssh-sftp-server
telnet
snmp
mysql
php5
apache2
postgresql
ftp
vsftpd
)

for (( itemNum = 0 ; itemNum < ${#items[@]} ; itemNum++ )); do
  aPackage=${items[$itemNum]};
  dpkg --get-selections "$aPackage" 2>/dev/null | grep install > /dev/null
  if [ $? -eq 0 ]; then
      echo "If $aPackage is not required, you should";
      echo "    apt-get --purge autoremove $aPackage -y";
  fi
done
echo "#---------------------------------"

#-------- samba --------#
dpkg --get-selections samba 2>/dev/null | grep install > /dev/null
if [ $? -eq 1 ]; then
   grep sambashare /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "samba is not installed.  We will remove group of sambashare:  groupdel sambashare"
       groupdel sambashare
   fi 
fi

#-------- sendmail --------#
dpkg --get-selections sendmail 2>/dev/null | grep install > /dev/null
if [ $? -eq 1 ]; then
   grep smmta /etc/passwd > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "sendmail is not installed.  Please remove user of smmta:  userdel smmta"
   fi 
   grep smmsp /etc/passwd > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "sendmail is not installed.  Please remove user of passwd:  userdel smmsp"
   fi 
   grep smmta /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "sendmail is not installed.  Please remove group of smmta:  groupdel smmta"
   fi 
   grep smmsp /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "sendmail is not installed.  Please remove group of smmsp:  groupdel smmsp"
   fi 
fi

#-------- openssh-server --------#
dpkg --get-selections openssh-server 2>/dev/null | grep install > /dev/null
if [ $? -eq 1 ]; then
   grep sshd /etc/passwd > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "openssh-server is not installed.  Please remove user of sshd:  userdel sshd"
   fi 
   grep ssh /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "openssh-server is not installed.  Please remove group of ssh:  groupdel ssh"
   fi 
fi

#-------- apache2 --------#
dpkg --get-selections apache2 2>/dev/null | grep install > /dev/null
if [ $? -eq 1 ]; then
   grep www-data /etc/passwd > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "apache2 is not installed.  Please remove user of www-data:  userdel www-data"
   fi 
   grep www-data /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "apache2 is not installed.  Please remove group of www-data:  groupdel www-data"
   fi 
fi

#-------- mysql --------#
dpkg --get-selections mysql 2>/dev/null | grep install > /dev/null
if [ $? -eq 1 ]; then
   grep mysql /etc/passwd > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "mysql is not installed.  Please remove user of mysql:  userdel mysql"
   fi 
   grep mysql /etc/group > /dev/null 2>&1
   if [ $? -eq 0 ]; then
       echo "mysql is not installed.  Please remove group of mysql:  groupdel mysql"
   fi 
fi
