#!/bin/bash
echo -n "* Executing apt-get update"
sudo apt-get update
echo -n "* Attempting to install puppet"
sudo apt-get install -y --force-yes puppet
echo " - Done"
sudo /usr/bin/logger -t autobootstrap "installed puppet"
echo "* installing gems"
sudo gem install hiera-eyaml
sudo gem install aws-sdk -v '~> 2.6.11'
sudo gem install hiera-eyaml-kms
echo " - Done"
sudo /usr/bin/logger -t autobootstrap "installed puppet gems"
