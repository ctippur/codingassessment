#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo mkdir -p /var/www/html
sudo mkdir -p /var/log/tdcustom/accesslogs
sudo chmod -R 755 /var/www
echo "hello world!" > /tmp/index.html
sudo mv /tmp/index.html /var/www/html
# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

# Variables
WEB_DIR='/var/www'
USERNAME='www-data'
USER='webserver'
sudo chown -R $USERNAME /var/www/html

sudo adduser $WEB_USER
sudo sed -i 's|/var/log/nginx/access.log|/var/log/tdcustom/accesslogs/acceess.log|' /etc/nginx/nginx.conf
sudo sed -i 's|/var/log/nginx/error.log|/var/log/tdcustom/accesslogs/error.log|' /etc/nginx/nginx.conf
sudo sed -i 's|listen 80 default_server;|listen 8900 default_server;|' /etc/nginx/sites-enabled/default
sudo sed -i 's|root /usr/share/nginx/html;|root /var/www/html;|' /etc/nginx/sites-enabled/default
sudo service nginx restart

