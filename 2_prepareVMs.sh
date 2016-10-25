#!/bin/bash

source ./config.sh
source ./lib.sh

echo -e "\n==> Preparing installation\n"

for i in $(seq 0 $((stacksize - 1)) ); do
	ssh -t "${stackname}$i.${domain}" "sudo sed -i 's/Defaults.*requiretty//' /etc/sudoers"
done

do_all sudo yum install -y yum-utils deltarpm openssl ntp wget numpy git mysql mysql-connector-java

do_all sudo ln -s /mnt /hadoop

do_all sudo service ntpd restart

do_all sudo setenforce 0



# echo -e "\n==> Preparing ssh configuration for Ambari Server\n"

# KEY=$(cat id_rsa.pub)
# do_all "sudo sed -i.bak \"$ a\ ${KEY}\" /root/.ssh/authorized_keys"

# scp -q id_rsa id_rsa.pub "${stackname}0.${domain}:/home/centos"
# do_amb sudo mv /home/centos/id_rsa* /root/.ssh/
# do_amb sudo chmod 600 /root/.ssh/id_rsa /root/.ssh/id_rsa.pub




echo -e "\n==> Creating /etc/hosts"

for i in $(seq 0 $((stacksize - 1)) ); do
	IP=$(ssh ${stackname}$i.${domain} "hostname -i")
	HOST="$IP ${stackname}$i.${domain}"
	do_all "sudo sed -i \"$ a ${HOST}\" /etc/hosts"
	echo $HOST
done

