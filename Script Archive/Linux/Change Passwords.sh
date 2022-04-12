#!/bin/bash
if [ $UID -ne 0 ]; then
echo "You are too stupid to run this script"
exit 0
fi

echo -n "Type your username: "
read userName
userList=$(cat /etc/passwd | grep /bin/bash | grep -v -e root -e $userName | cut -d : -f1)
declare -a userList

echo -n "Type the password to be set: "
read passwd
for user in ${userList[@]}
do 
echo $user:$passwd | chpasswd
echo "$user's password has been changed"
done
