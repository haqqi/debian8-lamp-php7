#!/usr/bin/env bash

# this script must be run by sudo user

# change this as you need before running the script
DBPASSWD=root
APACHE_USER=haqqi
APACHE_GROUP=haqqi

# Repository for latest MySQL
# http://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5
echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7" | sudo tee /etc/apt/sources.list.d/mysql.list

# update the package
echo -e "-- Updating OS packages...\n"
sudo apt-get update
sudo apt-get upgrade -y
echo -e "-- Finish updating OS packages.\n"

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/data-dir select ''"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $DBPASSWD"
sudo apt-get install -y mysql-server

# APACHE #######################################################################
echo -e "-- Installing Apache web server...\n"
sudo apt-get install -y apache2
echo -e "-- Finish installing Apache web server.\n\n"

# create symbolic link
if ! [ -L /var/www ]; then
  mkdir ~/web
  sudo rm -rf /var/www/html
  sudo ln -fs ~/web /var/www/html
fi

# installing php 7
grep -q -F 'deb http://packages.dotdeb.org jessie all' /etc/apt/sources.list || echo "deb http://packages.dotdeb.org jessie all" | sudo tee -a /etc/apt/sources.list
grep -q -F 'deb-src http://packages.dotdeb.org jessie all' /etc/apt/sources.list || echo "deb-src http://packages.dotdeb.org jessie all" | sudo tee -a /etc/apt/sources.list

wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
rm dotdeb.gpg
sudo apt-get update

sudo apt-get install -y curl php7.0 php7.0-mcrypt php7.0-imagick php7.0-mysql php7.0-curl php7.0-gd php7.0-bcmath php7.0-mbstring

# changing apache user group

echo -e "-- Changing user group of apache user...\n"
sudo sed -i "s/APACHE_RUN_USER=.*/APACHE_RUN_USER=$APACHE_USER/g" /etc/apache2/envvars
sudo sed -i "s/APACHE_RUN_GROUP=.*/APACHE_RUN_GROUP=$APACHE_GROUP/g" /etc/apache2/envvars

echo -e "\n--- Enabling mod-rewrite ---\n"
sudo a2enmod rewrite

echo -e "\n--- Allowing Apache override to all ---\n"
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Add 1GB swap for memory overflow
echo -e "-- Allocate swap for memory overflow...\n"
sudo fallocate -l 1024M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" | sudo tee -a /etc/fstab
printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# last process, must restart apache2 server
sudo service apache2 restart
