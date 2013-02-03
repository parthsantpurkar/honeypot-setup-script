#!/bin/bash

sudo apt-get install -y git python-pip g++
sudo pip install Django
sudo pip install pygeoip
sudo pip install django-pagination
sudo pip install django-tables2
sudo pip install django-compressor
sudo pip install django-htmlmin

# Django tables2 simplefilter
cd /tmp
git clone git://github.com/benjiec/django-tables2-simplefilter.git
cd django-tables2-simplefilter
sudo python setup.py install
#sudo pip install -e https://github.com/benjiec/django-tables2-simplefilter

# SubnetTree:
cd /tmp
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


# 2. Installing nodejs via package manager
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs npm
sudo npm install -g less

sudo apt-get install python-netaddr

# Installing Dionaea in /var
cd /var

# Getting DionaeaFR [the front end for Dionaea]
sudo git clone git://github.com/RootingPuntoEs/DionaeaFR.git

# GeoIP AND GeoLiteCity
sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz

sudo gunzip GeoLiteCity.dat.gz
sudo gunzip GeoIP.dat.gz

sudo mv GeoIP.dat DionaeaFR/DionaeaFR/static
sudo mv GeoLiteCity.dat DionaeaFR/DionaeaFR/static

cd /var/DionaeaFR
sudo python manage.py collectstatic
sudo sed -i 's:/opt/dionaea/var/dionaea/logsql.sqlite:/var/dionaea/logsql.sqlite:g' /var/DionaeaFR/DionaeaFR/settings.py

sudo chown -R nobody:nogroup /var/DionaeaFR/

# Installing the init script
#sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/init/dionaeafr -O /etc/init.d/dionaeafr
#sudo chmod +x /etc/init.d/dionaeafr
#sudo update-rc.d dionaeafr defaults
#sudo /etc/init.d/dionaeafr start

# Installing supervisord which contains a section to 
# autostart our DionaeaFR server.

sudo easy_install supervisor
sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/templates/supervisord.conf.tmpl -O /etc/supervisord.conf
supervisord -c /etc/supervisord.conf
echo "\nDone!\n"

