#!/bin/bash

mkdir -p /root/shell
cp -r ./src/shell/* /root/shell
chmod +x /root/shell/*
echo $1 > /root/shell/config

cp ./src/etc/billmgr_mod_service_vds-aeza.xml /usr/local/mgr5/etc/xml/
mysql -u root -p billmgr < ./src/etc/db_with_products.sql

/usr/local/mgr5/sbin/mgrctl -m billmgr --restart