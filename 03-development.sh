#!/usr/bin/env bash

# this script must be run by sudo user

# install git
echo "Install Git"
sudo apt-get install -y git

echo "Install composer"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

#install webmin
echo "Install webmin"
grep -q -F 'deb http://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list || echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee -a /etc/apt/sources.list
sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sudo apt-get update -qq
sudo apt-get install -y webmin

echo -e "Install nodejs 6 & bower"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g bower
