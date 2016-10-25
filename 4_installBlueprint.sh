#!/bin/bash 

source ./lib.sh

cat << EOF > host-mapping.json
{
  "blueprint" : "Demo",
  "default_password" : "admin",
  "host_groups" :[
    {
      "name" : "host_group_1", 
      "hosts" : [         
        { "fqdn" : "${stackname}0.${domain}" }
      ]
    },
    {
      "name" : "host_group_2", 
      "hosts" : [         
        { "fqdn" : "${stackname}1.${domain}" }
      ]
    },
    {
      "name" : "host_group_3", 
      "hosts" : [         
        { "fqdn" : "${stackname}2.${domain}" }
      ]
    },
    {
      "name" : "host_group_4", 
      "hosts" : [         
        { "fqdn" : "${stackname}3.${domain}" },
        { "fqdn" : "${stackname}4.${domain}" },
        { "fqdn" : "${stackname}5.${domain}" }
      ]
    }
  ]
}
EOF

echo -e "\n==> Uploading blueprint"
do_post "blueprints/Demo"  "@blueprint-6host.json"

echo -e "\n==> Triggering Installation"
do_post "clusters/Demo"    "@host-mapping.json"