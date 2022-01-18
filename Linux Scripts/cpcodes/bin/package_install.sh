#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

CheckConfigureFileYesno() {
  read -p "Have you double checked the configuration file $1 against README (y/n)?->" yesno
  if [[ "x$yesno" = "xy" || "x$yesno" = "xY" ]]; then
    return 0
  fi
  return 1
}

CheckYesno() {
  read -p "$1 package $2 (y/n)?->" yesno
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

installPackage() {
  package_name=$@
  dpkg --get-selections "$package_name" | grep install
  #dpkg -s "$package_name" | grep Status | grep install
  if [ ! $? -eq 0 ]; then
#    CheckYesno Install "$package_name"
#    if [ $? -eq 0 ]; then
      echo "Install $package_name"
      apt-get -y install "$package_name"
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

rm -f /var/cache/apt/archives/lock;

for ((i=0;i<${#myarray[@]};i++)); do
  package_name=${myarray[$i]}
  installPackage $package_name
done
