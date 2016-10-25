#!/bin/bash 

source ./lib.sh

do_all sudo killall -9 java python python2.7 grafana-server

cat <<EOF > /tmp/drop.sql
DROP USER hive@'%';
DROP USER rangeradmin@'localhost';
DROP USER rangeradmin@'bwalter1.field.hortonworks.com';
DROP DATABASE hive;
DROP DATABASE ranger;
EOF

cp_one 1 /tmp/drop.sql /tmp/drop.sql
do_one 1 sudo bash -c "mysql -u root < /tmp/drop.sql"
do_one 1 rm /tmp/drop.sql
rm /tmp/drop.sql

sleep 3

do_amb sudo rm -fr /var/lib/pgsql/
do_amb sudo yum remove -y postgresql postgresql-libs postgresql-server ambari-server
do_all sudo yum remove -y ambari-agent
do_amb sudo rm -fr /etc/ambari-server
do_all sudo rm -fr /etc/ambari-agent


