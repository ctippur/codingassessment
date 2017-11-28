#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo mkdir -p /var/www/html
sudo mkdir -p /var/log/tdcustom/accesslogs
sudo chmod -R 755 /var/www
echo "hello world!" > /tmp/index.html
sudo mv /tmp/index.html /var/www/html
# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

# Variables
USERNAME='www-data'
sudo chown -R $USERNAME /var/www/html

sudo adduser $WEB_USER
sudo sed -i 's|export APACHE_LOG_DIR=/var/log/apache2$SUFFIX|export APACHE_LOG_DIR=/var/log/tdcustom/accesslogs|' /etc/apache2/envvars
sudo sed -i 's|Listen 80|Listen 8900|' /etc/apache2/ports.conf
sudo sed -i 's|Directory /var/www/|Directory /var/www/html|' /etc/apache2/apache2.conf
sudo service apache restart

