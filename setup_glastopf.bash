#!/bin/bash

sudo apt-get update
sudo apt-get install -y git

cd /var
sudo git clone https://github.com/glastopf/glastopf.git
cd /var/glastopf

# Installing dependencies
sudo apt-get install -y python-numpy python-cython python-scipy python-lxml python-beautifulsoup python-setuptools python-pymongo python-chardet python-sqlalchemy python-requests
sudo pip install --use-mirrors cssselect 
sudo pip install --use-mirrors scikit_learn 
sudo pip install --use-mirrors requests

sudo chown -R nobody:nogroup /var/glastopf/

# Getting the custom config file
sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/templates/glastopf.cfg.tmpl -O /var/glastopf/glastopf.cfg

# Getting the init.d script and install as a system service
sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/init/glastopf -O /etc/init.d/glastopf
sudo chmod +x /etc/init.d/glastopf
sudo update-rc.d glastopf defaults
# Start glastopf
sudo /etc/init.d/glastopf start
echo "Done!"
