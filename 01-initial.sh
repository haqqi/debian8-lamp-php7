#!/usr/bin/env bash

# to run this script, login as root first

# change this as you need before running the script
SUDO_USER=haqqi
SUDO_PASSWD=haqqi

# update package
apt-get update
apt-get install sudo -y
apt-get install -y apt-transport-https

# setup new user
adduser --quiet --disabled-password --gecos "$SUDO_USER" $SUDO_USER
echo "$SUDO_USER:$SUDO_PASSWD" | chpasswd
usermod -a -G sudo $SUDO_USER
su - $SUDO_USER

# permit root login
sudo sed -i "s/#\?PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo systemctl restart ssh
