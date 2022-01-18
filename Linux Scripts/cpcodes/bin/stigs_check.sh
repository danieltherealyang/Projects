#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

rm -f /etc/security/console.perms
echo "" > /etc/securetty

grep rhosts_auth /etc/pam.d/*
grep pam_console.so /etc/pam.d/*

touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 0600 /etc/security/opasswd

find / -iname '*hosts.equiv' -delete
find / -iname '*.rhosts' -delete

#touch /etc/nologin
#chown root:root /etc/nologin
#chmod 0600 /etc/nologin

#pwck -r | grep 'no group'
#grpconv

# minlen=15 15 or greater
#grep -E 'pam_cracklib.so.*minlen' /etc/pam.d/* 

audit_logfile=$(grep "^log_file" /etc/audit/auditd.conf 2>/dev/null|sed s/^[^\/]*//)
if [ ! -z "$audit_logfile" ] && [ -f "$audit_logfile" ]; then
    echo "fix file permission and ownership $audit_logfile"
    chown root:root $audit_logfile
    chmod 0600 $audit_logfile
fi

if (! dpkg --get-selections "$package_name" 2>/dev/null | grep install > /dev/null); then
apt-get install ntp -y --force-yes
service ntp status
service ntp start
fi

if (grep -E '^[^#]*NOPASSWD' /etc/sudoers /etc/sudoers.d/* >/dev/null 2>&1); then
    echo "-----------------------------------------------------"
    grep -EH '^[^#]*NOPASSWD' /etc/sudoers /etc/sudoers.d/*
    echo "Find NOPASSWD /etc/sudoers /etc/sudoers.d/*"
    echo "   NOPASSWD should not be in the sudoers files"
    echo "-----------------------------------------------------"
fi
if (grep -E '^[^#]*!authenticate' /etc/sudoers /etc/sudoers.d/* >/dev/null 2>&1); then
    echo "-----------------------------------------------------"
    grep -EH '^[^#]*!authenticate' in /etc/sudoers /etc/sudoers.d/*
    echo "Find \!authenticate in /etc/sudoers /etc/sudoers.d/*"
    echo "   \!authenticate should not be in the sudoers files"
    echo "-----------------------------------------------------"
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

function config_line_in_file() {
local query=$1
local fname=$2
local checkstr=$(echo $query | sed -e 's/[ \t]\+/\[\[:blank:\]\]\*/g')

if [[ -e "${fname}" ]]; then
    if ! grep -wisEq -- "${checkstr}" "${fname}"; then
       echo "Missing $query in $fname"
    fi
fi
}

#------------------------------------------------
#  sysctl.conf
#------------------------------------------------
unset myarray
myfile=.sysctl_conf_add
readToArray $myfile

for ((i=0;i<${#myarray[@]};i++)); do
  one_entry=${myarray[$i]}
  config_line_in_file "$one_entry" /etc/sysctl.conf
done

#------------------------------------------------
#  sshd_config
#------------------------------------------------

if [ -f /etc/ssh/sshd_config ]; then
unset myarray
myfile=.sshd_config_add
readToArray $myfile

for ((i=0;i<${#myarray[@]};i++)); do
  one_entry=${myarray[$i]}
  config_line_in_file "$one_entry" /etc/ssh/sshd_config
done
fi
