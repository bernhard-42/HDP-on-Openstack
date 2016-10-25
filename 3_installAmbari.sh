#!/bin/bash

source ./config.sh
source ./lib.sh

echo "stackname: ${stackname}"
echo "stacksize: ${stacksize}"
echo "ambari_version: ${ambari_version}"

echo "Getting ambari repo file"
do_all sudo wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/${ambari_version}/ambari.repo -O /etc/yum.repos.d/ambari.repo

echo "Installing Ambari Agents"
do_all sudo yum install -y ambari-agent
do_all sudo sed -i "s/hostname=.*/hostname=${stackname}0.${domain}/" /etc/ambari-agent/conf/ambari-agent.ini
do_all sudo ambari-agent start

echo "Installing Ambari Server"
do_amb sudo yum install -y ambari-server

echo "Setting up Ambari Server"
do_amb sudo ambari-server setup -s

echo "Starting Ambari Server"
do_amb sudo ambari-server start

echo "Done"