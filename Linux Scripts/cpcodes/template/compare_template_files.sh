#!/bin/bash

current_user=$(whoami)
if [ "X$current_user" != "Xroot" ]; then
  echo "$0 MUST be run as root"
  exit 1
fi

Usage() {
     echo "Usage: $0 [-u]"
     echo "   $0    : overwrite file directly."
     echo "   $0 -u : use meld diff GUI"
     exit 1
}

useMeld=0
if [ $# -ne 0 ] && [ $# -ne 1 ]; then
     Usage
fi

if [ $# -eq 1 ]; then
     if [ "X$1" = "X-u" ]; then
         useMeld=1
     elif [ "X$1" = "X-h" ]; then
         Usage
     else
         Usage
     fi
fi

if [ $useMeld -eq 0 ]; then
    echo "Directly copy"
else
    echo "Use meld"
fi

CheckYesno() {
  read -p "Install meld (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}

if [ $useMeld -eq 1 ]; then
    DIFF_TOOL=meld
    dpkg --get-selections | grep installed | grep meld
    if [ $? -ne 0 ]; then
        apt-get install meld -y --force-yes
    fi
else
    DIFF_TOOL=cp
fi

# The following files might not exist.
# If the file does not exist, create an empty file.
items=(
/etc/init/control-alt-delete.override
/etc/resolvconf/resolv.conf.d/base
/etc/inittab
/etc/modprobe.d/usb-storage.conf
/etc/modprobe.d/bluetooth.conf
/etc/lightdm/lightdm.conf
/etc/motd
)
for (( itemNum = 0 ; itemNum < ${#items[@]} ; itemNum++ )); do
  aFile=${items[$itemNum]};
  if [ ! -f $aFile ]; then
    touch $aFile
    chmod 644 $aFile
    chown root:root $aFile
  fi
done

# The following directories might not exist.
# If the directory does not exist, create directory.
items=(
/var/log/audit
/var/log/apache2
)
for (( itemNum = 0 ; itemNum < ${#items[@]} ; itemNum++ )); do
  aDir=${items[$itemNum]};
  if [ ! -d $aDir ]; then
    mkdir $aDir
    chmod 700 $aDir
    chown root:root $aDir
  fi
done

export current_dir=$(dirname $0);
if [ "X$current_dir" = "X." ]; then
  export current_dir=$PWD
fi

# get system info
kernel_arch=$(uname -i);
if [ "X$kernel_arch" = "Xunknown" ]; then
    kernel_arch=$(uname -m);
fi
OS_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//')
OS_MAJOR_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | cut -d "." -f 1)
OS_TYPE=$(lsb_release -i | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | tr "[:upper:]" "[:lower:]")

echo "kernel_arch=$kernel_arch"
echo "OS_TYPE=$OS_TYPE"
echo "OS_VERSION=$OS_VERSION"
echo "OS_MAJOR_VERSION=$OS_MAJOR_VERSION"

getTPLFileName() {
    src=$1
    
    if [ "X$src" = "Xroot/etc/audit/audit.rules" ]; then
         if [ "X$kernel_arch" = "Xx86_64" ]; then
           echo ${src}.x86_64.${OS_TYPE}
           exit 0
         else
           echo ${src}.i686.${OS_TYPE}
           exit 0
         fi
    fi
    if [ -f ${src}.${OS_TYPE}_${OS_MAJOR_VERSION} ]; then
      echo ${src}.${OS_TYPE}_${OS_MAJOR_VERSION}
      exit 0
    elif [ -f ${source}.${OS_TYPE} ]; then
      echo ${src}.${OS_TYPE}
      exit 0
    else
      echo ${src}
      exit 0
    fi
}

echo `date` " : Comparison START" >> cp_work.log
echo "------------------------------" >> cp_work.log
echo "--------------------------"
change_count=0
cp_backup_top=cp_backup
for source in $(find root -type f | grep -Ev "debian|ubuntu"); do 
  target=$(echo $source | sed -e "s/^root//g")
  #if [ ! -f $target ]; then
  #    echo "$target does not exist!";
  #fi
  if [ -f $target ]; then
    realSource=$(getTPLFileName $source)
    diff -q $realSource $target > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      #echo "diff: diff -q $realSource $target"

      if [ ! -d $cp_backup_top ]; then
        mkdir -p $cp_backup_top
      fi
      target_cpbackup=${cp_backup_top}${target}
      target_cpbackup_base=$(dirname $target_cpbackup);
      if [ ! -d $target_cpbackup_base ]; then
        mkdir -p $target_cpbackup_base
      fi
      if [ -f ${target_cpbackup} ]; then
        flist=`ls -1 ${target_cpbackup}.* 2>/dev/null | sort`
        fextension=0
        for fullfile in $flist; do
          filename=$(basename "$fullfile")
          fextension="${filename##*.}"
        done
        fextension=$((fextension+1))
        target_backup_file=${target_cpbackup}.$fextension
      else
        target_backup_file=${target_cpbackup}
      fi

      cp $target $target_backup_file
      if [ $? -ne 0 ]; then
        echo "ERROR: cp $target $target_backup_file"
        exit 1
      fi
      echo "diff $target $target_backup_file" >> cp_work.log
      change_count=$((change_count+1))
      $DIFF_TOOL $realSource $target
      #echo $DIFF_TOOL $realSource $target
      if [ "X$target" = "X/etc/sysctl.conf" ]; then
        #echo "sysctl -p > /dev/null 2>&1"
        sysctl -p > /dev/null 2>&1
      fi
      if [ "X$target" = "X/etc/ssh/sshd_config" ]; then
        #echo "/etc/init.d/ssh restart"
        /etc/init.d/ssh restart
      fi
      if [ "X$target" = "X/etc/apache2/apache2.conf" ]; then
        a2enmod headers
        a2enmod rewrite
        service apache2 restart
      fi
      if [ "X$target" = "X/etc/php5/apache2/php.ini" ]; then
        a2enmod headers
        a2enmod rewrite
        service apache2 restart
      fi
      if [ "X$target" = "X/etc/vsftpd.conf" ]; then
        service vsftpd restart
      fi
      if [ "X$target" = "X/etc/audit/audit.rules" ]; then
        service auditd restart
      fi
      if [ "X$target" = "X/etc/audit/auditd.conf" ]; then
        service auditd restart
      fi
    fi
  fi
done
echo "------------------------------" >> cp_work.log
echo "    $change_count modified. See cp_work.log for detailed" >> cp_work.log
echo "------------------------------" >> cp_work.log
echo `date` " : Comparison END" >> cp_work.log

if [ $change_count -gt 0 ]; then
  echo "-------------------------------"
  echo "  $change_count file modified. See cp_work.log for detailed"
fi
  echo "-------------------------------"
echo "Please manually configure /etc/ufw/before.rules"
echo "    see root/etc/ufw/before.rules.template"
echo "Please manually configure /etc/hosts.deny"
echo "    see root/etc/hosts.deny.template"
echo "To find all of files you modified:"
echo "    look into " `pwd`"/cp_backup"

# killall -HUP smbd nmbd
# /etc/init.d/smbd restart
