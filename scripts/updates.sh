#!/bin/bash
sudo export DEBIAN_FRONTEND=noninteractive

sudo apt-get -q update
sudo apt-get -y upgrade
#sudo apt-get -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y autoremove
