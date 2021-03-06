#!/bin/bash

currentdir=`pwd`
# Install DionaeaFR dependencies
sudo apt-get install -y git python-pip g++
sudo pip install --use-mirrors Django
sudo pip install --use-mirrors pygeoip
sudo pip install --use-mirrors django-pagination
sudo pip install --use-mirrors django-tables2
sudo pip install --use-mirrors django-compressor
sudo pip install --use-mirrors django-htmlmin

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
#sudo add-apt-repository -y ppa:chris-lea/node.js
echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /tmp/nodejs.list
echo "deb-src http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main" >> /tmp/nodejs.list
mv /tmp/nodejs.list /etc/apt/sources.list.d/
sudo apt-get update
sudo apt-get install -y nodejs npm
sudo npm install -g less

sudo apt-get install -y python-netaddr

# Installing DionaeaFR in /var
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

sudo pip install --use-mirrors supervisor
sudo cp $currentdir/templates/supervisord.conf.tmpl /etc/supervisord.conf
sudo supervisord -c /etc/supervisord.conf
echo -e "\e[1mDone!\e[0m"

