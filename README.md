Shellscript - Debian LAMP with PHP 7 and latest MySQL
=====================================================

This project is for everyday use of configuring new vps. These scripts has been tested in Digital Ocean droplet using Debian 8.6.

How to Use
----------

1. Login as root in your new droplet using ssh.
1. Copy 01-initial.sh to your server using `nano 01-initial.sh`.
1. Change permission of the file using `chmod 755 01-initial.sh`.
1. This file will create a new sudo user. To customize the user and password for it, edit it using `nano 01-initial.sh` in the line `SUDO_USER` and `SUDO_PASSWD`.
1. Run the script `./01-initial.sh`.

Setup LAMP Stack
----------------

1. Assume you are still logged in as sudo user.
1. Edit and use 02-lamp.sh script similar to section before.
