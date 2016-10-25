#!/bin/bash

source ./config.sh
source ./lib.sh

# krb5.conf

createKrb5 () {
	cat << EOF > /tmp/krb5.conf
[logging]
  default = FILE:/var/log/krb5libs.log
  kdc = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log

[libdefaults]
  dns_lookup_realm = false
  ticket_lifetime = 24h
  renew_lifetime = 7d
  forwardable = true
  rdns = false
  default_realm = $realm
  default_ccache_name = KEYRING:persistent:%{uid}

[realms]
$realm = {
  kdc = $kdc
  admin_server = $kdc
}

[domain_realm]
  .$domain = $realm
  $domain = $realm

EOF

}


echo "Install Kerberos clients"

createKrb5
cp_all /tmp/krb5.conf /tmp/krb5.conf
do_all sudo rm -fr /var/kerberos/krb5kdc
do_all sudo mv /tmp/krb5.conf /etc/
do_all sudo chown root:root /etc/krb5.conf

do_all sudo yum remove -y krb5-workstation
do_all sudo yum install -y krb5-workstation

echo "Install Kerberos server"

do_amb sudo yum install -y rng-tools krb5-server krb5-libs

# Entropy helper
echo "Entropy helper"
do_amb sudo /sbin/rngd -r /dev/urandom -o /dev/random -f --background

echo "KDC config"
# KDC / Kadmin installation
do_amb sudo kdb5_util create -s
echo "*/admin@${realm}  *" > kadm5.acl
cp_amb kadm5.acl /tmp
do_amb sudo rm -f /var/kerberos/krb5kdc/kadm5.acl
do_amb sudo mv /tmp/kadm5.acl /var/kerberos/krb5kdc/ 
do_amb sudo chown root:root /var/kerberos/krb5kdc/kadm5.acl
do_amb sudo chmod 400 /var/kerberos/krb5kdc/kadm5.acl
rm kadm5.acl 

do_amb sudo systemctl start kadmin.service
do_amb sudo systemctl start krb5kdc.service

echo "configure admin"
cat << EOF2 > create_princ.sh
echo secret > pwd
echo secret >> pwd
sudo kadmin.local -q "addprinc admin/admin" < pwd
rm pwd
EOF2

cp_amb create_princ.sh /tmp
do_amb bash /tmp/create_princ.sh
do_amb rm -f /tmp/create_princ.sh

rm -f create_princ.sh

echo "Enter 'secret' as password for admin/admin"
echo "KDC machine"
do_amb kdestroy
do_amb kinit admin/admin
do_amb klist

echo "An other machine"
do_one 1 kdestroy
do_one 1 kinit admin/admin
do_one 1 klist