#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

readToArray(){
    tmpfile=$1;
    unset tmparray
    count=0;
    while read oneline
    do
        echo "$oneline"|grep -P "^\s*#|^\s*$" >/dev/null 2>&1
        if [ ! "x$?" = "x0" ]; then
          tmparray[$count]="$oneline"
          count=`expr $count + 1`
        fi
    done < $tmpfile

    for ((rtaj=0;rtaj<${#tmparray[@]};rtaj++)); do
        tmpdir=`eval echo \`echo ${tmparray[$rtaj]}|awk -F " " '{print $1}'\``
        tmpexist="n";
        for ((rtai=0;rtai<${#myarray[@]};rtai++)); do
            dir=`eval echo \`echo ${myarray[$rtai]}|awk -F " " '{print $1}'\``
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

getConfigurationArray $configure_file

for ((i=0;i<${#myarray[@]};i++)); do
  sys_account=${myarray[$i]}
  login_shell=$(grep -E "^${sys_account}:" /etc/passwd | cut -d':' -f 7)
  if [ ! "X$login_shell" = "X/usr/sbin/nologin" ] && [ ! "X$login_shell" = "X" ]; then
    echo "usermod -s /usr/sbin/nologin $sys_account"
    usermod -s /usr/sbin/nologin $sys_account >/dev/null 2>&1
  fi
done
