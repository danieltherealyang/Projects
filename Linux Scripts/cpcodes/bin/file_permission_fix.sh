#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

CheckYesno() {
  read -p "Repair (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}
#if [ "x$?" = "x0" ]; then
#fi

ChangeOwnerAndMod(){
    # echo "chown $3 $1; chmod $2 $1;"
    chown $3 $1;
    chmod $2 $1;
}

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

echo "-----------------------------------------------------"
echo "Use configuration file: $configure_file"
echo "-----------------------------------------------------"
getConfigurationArray $configure_file


for ((i=0;i<${#myarray[@]};i++)); do
  dir=`eval echo \`echo ${myarray[$i]}|awk -F " " '{print $1}'\``
  mod=`echo ${myarray[$i]}|awk -F " " '{print $2}'`
  own=`echo ${myarray[$i]}|awk -F " " '{print $3}'`
  ChangeOwnerAndMod $dir $mod $own
done

chown root:root /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* 2>/dev/null
chmod 0700 /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* 2>/dev/null
chown root:root /var/log/audit/*
chmod go-rwx /var/log/audit/*
if [ -f /etc/security/opasswd ]; then
    touch /etc/security/opasswd
    chown root:root /etc/security/opasswd
    chmod 0600 /etc/security/opasswd
fi

[ -f /etc/samba/smb.conf ] && setfacl --remove-all /etc/samba/smb.conf

[ -f /var/lib/samba/private/passdb.tdb ] && chown root:root /var/lib/samba/private/passdb.tdb
[ -f /var/lib/samba/private/passdb.tdb ] && chmod 0600 /var/lib/samba/private/passdb.tdb
[ -f /var/lib/samba/private/passdb.tdb ] && setfacl --remove-all /var/lib/samba/private/passdb.tdb

[ -f /var/lib/samba/private/randseed.tdb ] && chown root:root /var/lib/samba/private/randseed.tdb
[ -f /var/lib/samba/private/randseed.tdb ] && chmod 0600 /var/lib/samba/private/randseed.tdb
[ -f /var/lib/samba/private/randseed.tdb ] && setfacl --remove-all /var/lib/samba/private/randseed.tdb

[ -f /var/lib/samba/private/secrets.tdb ] && chown root:root /var/lib/samba/private/secrets.tdb
[ -f /var/lib/samba/private/secrets.tdb ] && chmod 0600 /var/lib/samba/private/secrets.tdb
[ -f /var/lib/samba/private/secrets.tdb ] && setfacl --remove-all /var/lib/samba/private/secrets.tdb
echo "-----------------------------------------------------"
