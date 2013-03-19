honeypot-setup-script
=====================

A script to install and deploy a honeypot automatically and without user interaction. 

Currently installs and sets up:

* kippo
* dionaea
* p0f


These will all be installed as system services so running this script once should turn a vanilla install in to a robust honeypot. Aims to use useful _and secure_ defaults. 

Currently tested on **Ubuntu 12.04**

**Use with caution**: This script will happily and without prompt overwrite files, change the port your SSH server runs and all sorts. It is intended to be run on a vanilla install of Ubuntu 12.04. No thoughts have been made for the integrity of existing installations of softwar - so be careful!

Usage
---------------------
**This can script can cause damage to your system. It is meant only to be used in vanilla installed**

Only run this if you **know what you are doing**.

    wget -q https://raw.github.com/parthsantpurkar/honeypot-setup-script/master/setup.bash -O /tmp/setup.bash && bash /tmp/setup.bash

Effects
---------------------

* Moves SSH server from port 22 to 9000
* Installs [Dionaea](http://dionaea.carnivore.it/), [Kippo](http://code.google.com/p/kippo/), [p0f](http://lcamtuf.coredump.cx/p0f3/#/)
* Sets up Dionaea, Kippo and p0f as system services that run on startup
* Sets up DionaeaFR, a front-end to visualize data from Dionaea

Directory Structure
---------------------
**Logging and Binaries**
* Dionaea: `/var/dionaea/`
* Kippo: `/var/kippo/`
* p0f: `/var/p0f/`
* DionaeaFR: `/var/DionaeaFR`

**Configuration**
* Dionaea: /etc/dionaea
* Kippo: /etc/kippo
* DionaeaFR: `/var/DionaeaFR`
