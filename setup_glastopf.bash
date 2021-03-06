#!/bin/bash
# Source : https://github.com/glastopf/glastopf/blob/master/docs/source/installation/installation_ubuntu.rst

# Install the dependencies:
sudo apt-get update 1>/dev/null
sudo apt-get install -y -q python2.7 python-openssl python-gevent libevent-dev 
sudo apt-get install -y -q python2.7-dev build-essential make python-chardet 
sudo apt-get install -y -q python-requests python-sqlalchemy python-lxml 
sudo apt-get install -y -q python-beautifulsoup mongodb mongodb-server mongodb-clients python-pip python-dev 
sudo apt-get install -y -q python-numpy python-setuptools 
sudo apt-get install -y -q python-numpy-dev python-scipy libblas-dev libblas3 libatlas3-base libatlas-dev g++ 
sudo apt-get install -y -q git php5 php5-dev
sudo pip install --upgrade distribute

# Install and configure the PHP sandbox
cd /var
sudo git clone git://github.com/glastopf/BFR.git
cd /var/BFR
sudo phpize
sudo ./configure --enable-bfr
sudo make && sudo make install

# Install Glastopf: Either from source or via pip
sudo pip install glastopf

#cd /opt
#sudo git clone https://github.com/glastopf/glastopf.git
#cd glastopf
#sudo python setup.py install

# Configuration: Prepare glastopf environment
cd /var
sudo mkdir glastopf-honeypot
cd /var/glastopf-honeypot
sudo glastopf-runner.py