#!/bin/bash

source ./config.sh
source ./lib.sh

cat <<EOF > /tmp/admin.sql
CREATE USER 'admin'@'%' IDENTIFIED WITH mysql_native_password;

SET old_passwords = 0;
SET PASSWORD FOR 'admin'@'%' = PASSWORD('secret');

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

EOF

cp_one 1 /tmp/admin.sql /tmp/admin.sql
do_one 1 sudo bash -c "mysql -u root < /tmp/admin.sql"
do_one 1 sudo rm /tmp/admin.sql
rm /tmp/admin.sql

do_amb sudo ambari-server setup --jdbc-db="mysql" --jdbc-driver="/usr/share/java/mysql-connector-java.jar"


