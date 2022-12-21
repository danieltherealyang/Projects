#!/bin/bash
if [ -e /etc/ssh/sshd_config ]; then
echo "SSH CONFIG FILE EXISTS"
else
sudo apt-get -qq install ssh
fi

read -p "Press any key to continue"

declare -a yesarray=(
UsePrivilegeSeparation 
StrictModes 
IgnoreRhosts 
RSAAuthentication
PrintLastLog)

for i in ${yesarray[@]}
do 
if [ "$(cat /etc/ssh/sshd_config | grep $i)" != "" ]; then
sudo sed -i "/$i/c\\$i yes" /etc/ssh/sshd_config
else
sudo sed -i "$ a\\$i yes" /etc/ssh/sshd_config
fi
done

declare -a noarray=(
PermitRootLogin
AllowTcpForwarding
X11Forwarding
HostbasedAuthentication
RhostsRSAAuthentication
PermitEmptyPasswords
PermitUserEnvironment
PasswordAuthentication
UseDNS)

for i in ${noarray[@]}
do 
if [ "$(cat /etc/ssh/sshd_config | grep $1)" != "" ]; then
sudo sed -i "/$i/c\\$i no" /etc/ssh/sshd_config
else 
sudo sed -i "$ a\\$i no" /etc/ssh/sshd_config
fi
done

if [ "$(cat /etc/ssh/sshd_config | grep Protocol)" != "" ]; then
sudo sed -i '/Protocol/c\Protocol 2' /etc/ssh/sshd_config
else
sudo sed -i '$ a\Protocol 2' /etc/ssh/sshd_config
fi

if [ "$(grep ClientAliveInterval /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/ClientAliveInterval/c\ClientAliveInterval 300' /etc/ssh/sshd_config
else
sudo sed -i '$ a\ClientAliveInterval 300' /etc/ssh/sshd_config
fi

if [ "$(grep ClientAliveCountMax /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/ClientAliveCountMax/c\ClientAliveCountMax 0' /etc/ssh/sshd_config
else
sudo sed -i '$ a\ClientAliveCountMax 0' /etc/ssh/sshd_config
fi

if [ "$(grep LoginGraceTime /etc/ssh/sshd_config)" != "" ]; then
sudo sed '/LoginGraceTime/c\LoginGraceTime 300' /etc/ssh/sshd_config
else
sudo sed -i '$ a\LoginGraceTime 300' /etc/ssh/sshd_config
fi

if [ "$(grep MaxStartups /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/MaxStartups/c\MaxStartups 2' /etc/ssh/sshd_config
else
sudo sed -i '$ a\MaxStartups 2' /etc/ssh/sshd_config
fi

if [ "$(grep LogLevel /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/LogLevel/c\LogLevel VERBOSE' /etc/ssh/sshd_config
else
sudo sed -i '$ a\LogLevel VERBOSE' /etc/ssh/sshd_config
fi

if [ "$(grep Banner /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/Banner/c\Banner /etc/issue' /etc/ssh/sshd_config
else
sudo sed -i '$ a\Banner /etc/issue' /etc/ssh/sshd_config
fi

if [ "$(grep Ciphers /etc/ssh/sshd_config)" != "" ]; then
sudo sed -i '/Ciphers/c\Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc' /etc/ssh/sshd_config
else 
sudo sed -i '$ a\Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc' /etc/ssh/sshd_config
fi

sudo /etc/init.d/ssh restart
