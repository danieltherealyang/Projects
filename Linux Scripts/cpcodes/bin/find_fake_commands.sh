#!/bin/bash

if [ $UID -ne 0 ] ; then
        echo "ERROR: YOU MUST BE ROOT TO RUN THIS SCRIPT!"
        exit 255
fi

for ACMD in sudo su bash sh passwd; do
  CMD_NUMBER=$(which -a $ACMD | wc -l);
  if [ $CMD_NUMBER -ne 1 ]; then
    echo "---------------------------------";
    echo "$ACMD is suspecious.  Please check the output of \"which -a $ACMD\"";
    echo "---------------------------------";
    which -a $ACMD
  fi
done
