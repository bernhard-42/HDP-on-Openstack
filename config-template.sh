#!/bin/bash

stackname="demo-xyz"
stacksize=6
ambari_version=2.4.1.0
hdp_version=2.5

domain="example.com"
kdc="${stackname}0.${domain}"
realm="EXAMPLE.COM"

# Ambari
ambari_password="admin"
ambari_cred="admin:${ambari_password}"
base_url="http://${stackname}0.${domain}:8080/api/v1"

# Ranger
ranger="${stackname}0.${domain}"
ranger_url="http://${ranger}:6080/service/public/v2/api"
ranger_user="admin"
ranger_password="admin"
