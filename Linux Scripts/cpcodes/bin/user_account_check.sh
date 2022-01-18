#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

user_with_zero_count=$(awk -F: '($3 == 0) {print}' /etc/passwd | wc -l)
if [ $user_with_zero_count -gt 1 ]; then
  echo "[ERROR] Only root should have UID of 0:"
  echo "-----------------------------------------"
  awk -F: '($3 == 0) {print}' /etc/passwd
  echo "-----------------------------------------"
fi

echo "Please double check the active/unlock accounts"
echo "-----------------------------------------"
egrep -v '.*:\*|:\!' /etc/shadow | awk -F: '{print $1}'
echo "-----------------------------------------"

bad_x_user_count=$(grep -v ':x:' /etc/passwd | wc -l)
if [ $bad_x_user_count -gt 0 ]; then
  echo "[ERROR] Make sure we have  a 'x' in the password field in /etc/passwd:"
  echo "-----------------------------------------"
  grep -v ':x:' /etc/passwd
  echo "-----------------------------------------"
fi

for username in $(awk -F: '$1 !~ /^root$/ && $2 !~ /^[!*]/ {print $1}' /etc/shadow); do
  userid=$(id -u $username)
  if [ $userid -lt 500 ]; then
    echo "[ERROR] System account with UID number less than 500 other than root"
    echo "-----------------------------------------"
    echo "username=$username UID=$userid: Fix Command: passwd -l $username"
    echo "-----------------------------------------"
  fi
done
