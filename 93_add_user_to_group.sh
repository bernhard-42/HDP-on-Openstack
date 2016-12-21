#!/bin/bash

source ./config.sh
source ./lib.sh

USER=$1
GROUP=$2

echo "Add user $USER on all machines"
do_all sudo /usr/sbin/usermod -a -G ${GROUP} ${USER}
echo "==> Done"
