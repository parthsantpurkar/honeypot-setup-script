#!/bin/bash

sudo apt-get install git
sudo apt-get install python-pip
pip install Django
pip install pygeoip
pip install django-pagination
pip install django-tables2
pip install django-compressor
pip install django-htmlmin

# Django tables2 simplefilter
pip install -e https://github.com/benjiec/django-tables2-simplefilter
#SubnetTree:
git clone git://git.bro-ids.org/pysubnettree.git
cd pysubnettree
sudo python setup.py install

# Two ways to install nodejs 1. from source 2. via package manager
# Both are included here for convenience
# Choose which ever method suits you.

# 1. Installing nodejs from source
#nodejs:
#wget http://nodejs.org/dist/v0.8.16/node-v0.8.16.tar.gz
#tar xzvf node-v0.8.16.tar.gz
#cd node-v0.8.16
#./configure
#sudo make
#sudo make install
#sudo apt-get install npm
#sudo npm install -g less


# 2. Installing nodejs via package manager
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs npm


sudo apt-get install python-netaddr

# Installing Dionaea in /var
cd /var

# Getting DionaeaFR [the front end for Dionaea]
git clone git://github.com/RootingPuntoEs/DionaeaFR.git

# GeoIP AND GeoLiteCity
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz

gunzip GeoLiteCity.dat.gz
gunzip GeoIP.dat.gz

sudo mv GeoIP.dat DionaeaFR/DionaeaFR/static
sudo mv GeoLiteCity.dat DionaeaFR/DionaeaFR/static

cd /var/DionaeaFR
python manage.py collectstatic

