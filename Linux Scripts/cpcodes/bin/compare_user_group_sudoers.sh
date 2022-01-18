#!/bin/bash

if [ $UID -ne 0 ] ; then
     echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
     exit 255
fi

Usage() {
     echo "Usage: $0 [-u]"
     echo "   $0    : output the difference to terminal"
     echo "   $0 -u : show the difference using meld diff GUI"
     exit 1
}

compare_one_file() {
     filename=$1
     basefilename=$(basename $filename)
     diff -q .${OS_TYPE}_${OS_MAJOR_VERSION}_${basefilename} $filename >/dev/null 2>&1
     if [ $? -ne 0 ]; then
         $DIFF_TOOL .${OS_TYPE}_${OS_MAJOR_VERSION}_${basefilename} $filename 2>/dev/null
     fi
#     tmpfilename=/tmp/.${basefilename}.$$
#     cp $filename $tmpfilename
#     $DIFF_TOOL .${OS_TYPE}_${OS_MAJOR_VERSION}_${basefilename} $tmpfilename
#     if [ -f $tmpfilename ]; then
#         rm -f $tmpfilename
#     fi
}

#useMeld=0
#DIFF_TOOL=diff
#if [ $# -ne 0 ] && [ $# -ne 1 ]; then
#     Usage
#fi
#
#if [ $# -eq 1 ]; then
#     if [ "X$1" = "X-u" ]; then
#         useMeld=1
#     elif [ "X$1" = "X-h" ]; then
#         Usage
#     else
#         Usage
#     fi
#fi

useMeld=1
DIFF_TOOL=meld

if [ ! -d /tmp ]; then
     echo "ERROR: /tmp/ does not exists or cannot be written!"
     echo "sudo mkdir /tmp"
     exit 255
fi

export OS_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//')
export OS_MAJOR_VERSION=$(lsb_release -r | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | cut -d "." -f 1)
export OS_TYPE=$(lsb_release -i | cut -d ":" -f 2 | sed -e 's/^[ \t]*//;s/[ \t]*$//' | tr "[:upper:]" "[:lower:]")

if [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_14" ] ||
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xubuntu_16" ] ||
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xdebian_7" ] ||
   [ "X${OS_TYPE}_${OS_MAJOR_VERSION}" = "Xdebian_8" ]; then
     #echo "The system is ${OS_TYPE}_${OS_VERSION}"

     if [ $useMeld -eq 1 ]; then
          DIFF_TOOL=meld
          dpkg --get-selections | grep install | grep meld > /dev/null 2>&1
          if [ $? -ne 0 ]; then
               apt-get install meld --force-yes -y
          fi
     fi

     compare_one_file /etc/passwd
     compare_one_file /etc/group
     compare_one_file /etc/sudoers
     compare_one_file /etc/crontab
     compare_one_file /etc/profile
fi

for i in $(ls /home); do
     compare_one_file /home/$i/.bashrc
     compare_one_file /home/$i/.profile
     compare_one_file /home/$i/.bash_logout
done

pwck -r 
grpck -r
