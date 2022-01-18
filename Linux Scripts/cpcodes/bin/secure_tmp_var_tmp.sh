#!/bin/bash

if [ $UID -ne 0 ] ; then
    echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
    exit 1
fi

if [ ! -d /mnt ]; then
   mkdir /mnt
   chown root:root /mnt
   chmod 755 /mnt
fi

TMP_FS_FILE=/mnt/cptmpRDSK
TMP_BACKUP_DIR=/cptmpbackup
VAR_TMP_BACKUP_DIR=/cpvartmpbackup
if [ -f $TMP_FS_FILE ]; then
   echo "tmp file, $TMP_FS_FILE, has already been securied";
   exit 0;
fi 

# Create a filesystem file for the /tmp partition:
dd if=/dev/zero of=$TMP_FS_FILE bs=1024 count=1000000
chown root:root $TMP_FS_FILE
chmod 666 $TMP_FS_FILE

# Create a backup of the current /tmp folder:
if [ -d $TMP_BACKUP_DIR ]; then
  rm -rf $TMP_BACKUP_DIR
fi
cp -rpf /tmp/* $TMP_BACKUP_DIR/ 2>/dev/null

# Mount the new /tmp partition and set the right permissions:
mount -t tmpfs -o loop,noexec,nosuid,rw $TMP_FS_FILE /tmp
chmod 1777 /tmp

# Copy the data from the backup folder, and remove backup folder:
if [ -d $TMP_BACKUP_DIR ]; then
   cp -rpf $TMP_BACKUP_DIR/* /tmp/ 2>/dev/null
   rm -rf $TMP_BACKUP_DIR
fi

# Set the /tmp in fstab:
if [ ! -f /etc/fstab.org ]; then
  cp /etc/fstab{,.org}
fi
grep "$TMP_FS_FILE /tmp tmpfs loop,nosuid,noexec,rw 0 0" /etc/fstab || echo "$TMP_FS_FILE /tmp tmpfs loop,nosuid,noexec,rw 0 0" >> /etc/fstab

# Test your fstab entry: 
mount -o remount /tmp

if [ -d $VAR_TMP_BACKUP_DIR ]; then
  rm -rf $VAR_TMP_BACKUP_DIR
fi

mkdir -p $VAR_TMP_BACKUP_DIR
chmod a+rwx $VAR_TMP_BACKUP_DIR

if [ -d /var/tmp ]; then
  cp -rpf /var/tmp/* $VAR_TMP_BACKUP_DIR/ 2>/dev/null
  rm -rf /var/tmp
  ln -fs /tmp /var/tmp
  cp -rpf $VAR_TMP_BACKUP_DIR/* /tmp/ 2>/dev/null
fi

rm -rf $VAR_TMP_BACKUP_DIR
