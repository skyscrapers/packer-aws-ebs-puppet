#!/bin/bash
sudo apt-get -q update
sleep 5
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
#sudo apt-get -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y autoremove
