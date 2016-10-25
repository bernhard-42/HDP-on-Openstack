#!/bin/bash

source ./config.sh
source ./lib.sh

python 8_enableDenyPolicies.py ${ranger_url} ${ranger_user} ${ranger_password} "hdfs,hive"
