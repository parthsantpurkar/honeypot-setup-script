#!/bin/bash

apt-get update
apt-get install python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make python-chardet python-requests python-sqlalchemy python-lxml python-beautifulsoup mongodb python-pip python-dev python-numpy python-setuptools python-numpy-dev python-scipy libatlas-dev g++ git php5 php5-dev
pip install --upgrade distribute

cd /var
git clone git://github.com/glastopf/BFR.git
cd /var/BFR
phpize
./configure --enable-bfr
make && make install


cd /var
git clone https://github.com/glastopf/glastopf.git
cd /var/glastopf
python setup.py install


cd /var
mkdir glastopf-honeypot
cd /var/glastopf-honeypot
python glastopf-runner.py