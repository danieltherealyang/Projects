#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

Usage() {
     echo "Usage: $0 "userlist" "admin_user_list" "
     echo "   $0    : output the active users to terminal"
     echo "   $0 \"cpadmin john kevin\" \"cpadmin kevin\""
     echo "         where cpadmin and kevin are administrators "
     exit 1
}

CheckYesno() {
  read -p "$1 $2 (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}

listUser=1
if [ $# -ne 0 ] && [ $# -ne 2 ]; then
     Usage
fi

if [ $# -eq 2 ]; then
     userlist=$1
     adminlist=$2
     if [ "X$userlist" != "X" ] && [ "X$adminlist" != "X" ]; then
         listUser=0
     fi
fi

if [ $listUser -eq 1 ]; then
echo "-----------------------------------------------------"
echo "Please review the following active accounts carefully against README"
echo "-----------------------------------------------------"
cat /etc/passwd | grep -E -v '\/false|\/nologin|\/shutdown|\/halt' |cut -d':' -f 1,7 | grep -vEw "root|libuuid|sync|speech-dispatcher" 
echo "-----------------------------------------------------"
echo "You can use this script to automatically add and delete users:"
echo "   $0 \"cpadmin john kevin\" \"cpadmin kevin\""
echo "         where cpadmin and kevin are administrators "

else
echo " Userlist: $userlist"
echo "Adminlist: $adminlist"
CheckYesno "Are UserList and AdminList correct?" ""
if [ $? = 1 ]; then
     exit 0
fi

# check if the required users exits
for i in $userlist $adminlist; do
   id $i >/dev/null 2>&1
   if [ $? -eq 1 ]; then
       echo "$i does not exist.  Do you want to create user: $i ?"
       CheckYesno "Create user" $i
       if [ $? = 0 ]; then
           useradd $i           
       fi
   fi
done

# check if the required admin users in sudo group
for i in $adminlist; do
   id $i 2>&1 | grep sudo >/dev/null 2>&1
   if [ $? -eq 1 ]; then
       CheckYesno "admin user $i does not belong to sudo group.  Do you want to add $i to sudo group" ""
       if [ $? = 0 ]; then
           usermod -aG sudo $i           
       fi
   fi
done

currentUserList=$(cat /etc/passwd | grep -Ev "false|nologin|shutdown|halt" |cut -d":" -f 1 | grep -vEw "root|libuuid|sync|speech-dispatcher|nobody")
for j in $currentUserList; do
    found=0
    for i in $userlist $adminlist; do
        if [ "X$j" = "X$i" ]; then
            found=1
            break
        fi
    done
    if [ $found -eq 0 ]; then
         CheckYesno "Delete user" $j
         if [ $? = 0 ]; then
              #deluser --remove-home --remove-all-files $j
              deluser --remove-home $j
         fi
    fi
done

fi

pwck -r 
grpck -r

