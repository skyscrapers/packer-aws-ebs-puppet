#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y clean
sudo apt-get -y autoremove

sudo rm /etc/sudoers.d/10-ubuntu &> /dev/null || true
