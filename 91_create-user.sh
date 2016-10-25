#!/bin/bash

source ./config.sh
source ./lib.sh

USER=${1:-test}
PASSWORD=${2:-secret}
ADMIN=${3:-true}
GROUP=${4:-test}

echo "Add user $USER on all machines"
do_all sudo /usr/sbin/useradd -p '$(openssl passwd -1 secret)' ${USER}
do_all sudo /usr/sbin/groupadd -f ${GROUP}
do_all sudo /usr/sbin/usermod -G ${GROUP} ${USER}
echo "==> Done"

echo "Add user $USER to Ambari"
do_post users "{\"Users/user_name\":\"${USER}\",\"Users/password\":\"${PASSWORD}\",\"Users/active\":\"true\",\"Users/admin\":\"${ADMIN}\"}"
echo "==> Done"

echo "Add user home for $USER in HDFS"
do_amb sudo -u hdfs hdfs dfs -mkdir /user/${USER}
do_amb sudo -u hdfs hdfs dfs -chown ${USER}:hdfs /user/${USER}
echo "==> Done"
