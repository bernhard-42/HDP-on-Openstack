#!/bin/bash

source ./config.sh
source ./lib.sh

for i in $(seq 0 $((stacksize - 1)) ); do
	ping -W 1 -c 1 "${stackname}$i.${domain}" 2>&1 > /dev/null
	if [ $? -eq 0 ]; then 
		RET="OK"
	else
		RET="FAIL"
	fi
	echo "${stackname}$i.${domain} ==> $RET"
done