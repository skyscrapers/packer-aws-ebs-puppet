#!/bin/bash
echo -n "* Executing apt-get update"
sudo apt-get update
echo -n "* Attempting to install puppet"
sudo apt-get install -y --force-yes puppet
echo " - Done"
sudo /usr/bin/logger -t autobootstrap "installed puppet"
echo "* installing gems"
sudo gem install hiera-eyaml
# aws-codedeploy-agent 1.0-1.1067 depends on aws-sdk-core ~2.6.11 and will ERROR on newer versions (~2.7).
# We'll probably have to update again once they release the newest version with commit:
# https://github.com/aws/aws-codedeploy-agent/commit/50db2ec9013cfe8f1a857de53c806d6c67d8d07b
sudo gem install aws-sdk -v '~> 2.6.11'
sudo gem install hiera-eyaml-kms
echo " - Done"
sudo /usr/bin/logger -t autobootstrap "installed puppet gems"
