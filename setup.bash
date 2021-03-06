#!/bin/bash

currentdir=`pwd`
# update apt repositories
sudo apt-get update 1>/dev/null

#user iface choice
sudo apt-get -y install python-pip gcc python-dev
sudo pip install netifaces
#sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/scripts/iface-choice.py -O /tmp/iface-choice.py
#python /tmp/iface-choice.py
#iface=$(<~/.honey_iface)


# Move SSH server from Port 22 to Port 65535
sudo sed -i 's:Port 22:Port 65535:g' /etc/ssh/sshd_config
sudo service ssh reload


## install p0f ##

sudo apt-get install -y p0f
sudo mkdir /var/p0f/

# dependency for add-apt-repository
sudo aptitude install -y software-properties-common
sudo apt-get install -y python-software-properties

## install dionaea ##

#add dionaea repo
#sudo add-apt-repository -y ppa:honeynet/nightly
echo "deb http://ppa.launchpad.net/honeynet/nightly/ubuntu precise main" >> /tmp/dionaearepo.list
echo "deb-src http://ppa.launchpad.net/honeynet/nightly/ubuntu precise main" >> /tmp/dionaearepo.list
sudo mv /tmp/dionaearepo.list /etc/apt/sources.list.d/
sudo apt-get update 1>/dev/null
sudo apt-get install -y --force-yes dionaea

#make directories
sudo mkdir -p /var/dionaea/wwwroot
sudo mkdir -p /var/dionaea/binaries
sudo mkdir -p /var/dionaea/log
sudo mkdir -p /var/dionaea/bistreams
sudo chown -R nobody:nogroup /var/dionaea/

#edit config
sudo mkdir -p /etc/dionaea
sudo cp $currentdir/templates/dionaea.conf.tmpl /etc/dionaea/dionaea.conf
#note that we try and strip :0 and the like from interface here
#sudo sed -i "s|%%IFACE%%|${iface%:*}|g" /etc/dionaea/dionaea.conf

## install kippo - we want the latest so we have to grab the source ##

#kippo dependencies
sudo apt-get install -y subversion python-dev openssl python-openssl python-pyasn1 python-twisted iptables

#install kippo to /opt/kippo
sudo mkdir /opt/kippo/
sudo svn checkout http://kippo.googlecode.com/svn/trunk/ /opt/kippo/

sudo cp $currentdir/templates/kippo.cfg.tmpl /opt/kippo/kippo.cfg

#add kippo user that can't login
sudo useradd -r -s /bin/false kippo

#set up log dirs
sudo mkdir -p /var/kippo/dl
sudo mkdir -p /var/kippo/log/tty
sudo mkdir -p /var/run/kippo

#delete old dirs to prevent confusion
sudo rm -rf /opt/kippo/dl
sudo rm -rf /opt/kippo/log

#set up permissions
sudo chown -R kippo:kippo /opt/kippo/
sudo chown -R kippo:kippo /var/kippo/
sudo chown -R kippo:kippo /var/run/kippo/

#point port 22 at port 2222 
#we should have -i $iface here but it was breaking things with virtual interfaces
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

#persist iptables config
sudo iptables-save > /etc/iptables.rules

#setup iptables restore script
sudo echo '#!/bin/sh' >> /etc/network/if-up.d/iptablesload 
sudo echo 'iptables-restore < /etc/iptables.rules' >> /etc/network/if-up.d/iptablesload 
sudo echo 'exit 0' >> /etc/network/if-up.d/iptablesload 
#enable restore script
sudo chmod +x /etc/network/if-up.d/iptablesload 

#download init files and install them
#sudo wget https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/templates/p0f.init.tmpl -O /etc/init.d/p0f
#sudo sed -ii "s|%%IFACE%%|$iface|g" /etc/init.d/p0f

sudo cp $currentdir/init/dionaea /etc/init.d/dionaea
sudo cp $currentdir/init/kippo /etc/init.d/kippo

#install system services
sudo chmod +x /etc/init.d/dionaea
sudo chmod +x /etc/init.d/kippo

sudo update-rc.d dionaea defaults
sudo update-rc.d kippo defaults

#start the honeypot software
sudo /etc/init.d/kippo start
sudo p0f -i any -u ubuntu -Q /tmp/p0f.sock -d -o /var/p0f.log -q -l -N -p -r -M
sudo /etc/init.d/dionaea start

#install DionaeaFR from setup_dionaea.bash
cd $currentdir
$currentdir/setup_dionaeafr.bash
