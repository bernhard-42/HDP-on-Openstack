#!/bin/bash

source ./config.sh
source ./lib.sh

GROUP=$1

echo "Create group $GROUP on all machines"
do_all sudo /usr/sbin/groupadd -f ${GROUP}
echo "==> Done"
