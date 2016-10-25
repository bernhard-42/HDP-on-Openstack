#!/bin/bash

source config.sh

echo "=> Stackname: ${stackname}"
echo "=> Stacksize: ${stacksize}"
echo "=> Ambari version: ${ambari_version}"
echo "=> HDP version: ${hdp_version}"
echo "=> Domain: ${domain}"
echo "=> Kerberos KDC: ${kdc}"
echo "=> Kerberos Realm: ${realm}"
echo ""

function do_all {
	pdsh -w "${stackname}[0-$((stacksize - 1))].${domain}" "$@; exit"
}

function do_amb {
	ssh "${stackname}0.${domain}" "$@"
}

function do_one {
	id=$1
	shift
	ssh "${stackname}${id}.${domain}" "$@"
}

function cp_all {
	for id in $(seq 0 $((stacksize - 1)) ); do
		scp "$1" "${stackname}${id}.${domain}:$2"
	done
}

function cp_amb {
	scp "$1" "${stackname}0.${domain}:$2"
}

function cp_one {
	id=$1
	shift
	scp "$1" "${stackname}${id}.${domain}:$2"
}

function do_get {
	curl -u "$ambari_cred" -H "X-Requested-By: ambari" -s "${base_url}/$1" 
}

function do_post {
	curl -u "$ambari_cred" -H "X-Requested-By: ambari" -w "\n==> %{http_code}\n" -X POST "${base_url}/$1" --data "$2"
}

function do_put {
	curl -u "$ambari_cred" -H "X-Requested-By: ambari" -w "\n==> %{http_code}\n" -X PUT  "${base_url}/$1" --data "$2"
}

