#!/bin/bash
yum -y install net-tools nginx
systemctl start nginx
MYIP=`ifconfig | grep -E '(inet).*(broadcast)' | awk '{ print $2 }' | cut -d ':' -f2`
echo 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html