#!/bin/bash
eval `cat /etc/lsb-release`
sudo wget -qO - https://apt.puppetlabs.com/pubkey.gpg | sudo apt-key add -
echo -n "* added puppetlabs apt key"
if [[ ! -e "/etc/apt/sources.list.d/puppet.list" ]];
  then
    sudo echo "deb https://apt.puppetlabs.com/ $(sudo lsb_release -c -s) PC1" | sudo tee -a /etc/apt/sources.list.d/puppet.list
    echo -n "* added puppetlabs apt repo"
else
  if ! grep -q "deb https://apt.puppetlabs.com/ $(sudo lsb_release -c -s) PC1" /etc/apt/sources.list.d/puppet.list;
   then
       sudo echo "deb https://apt.puppetlabs.com/ $(sudo lsb_release -c -s) PC1" | sudo tee -a /etc/apt/sources.list.d/puppet.list
       echo -n "* added puppetlabs apt repo"
   else
     echo -n "* repo already added... moving on"

  fi
fi
echo -n "* Executing apt-get update"
sudo apt-get update
echo -n "* Attempting to install puppet"
sudo apt-get install -y --force-yes puppet-agent=1.8.*
echo " - Done"
if [[ ! -e /usr/bin/puppet ]]; then
  sudo ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet
fi
sudo /usr/bin/logger -t autobootstrap "installed puppet"
echo "* installing gems"
sudo /opt/puppetlabs/puppet/bin/gem install hiera-eyaml
# aws-codedeploy-agent 1.0-1.1067 depends on aws-sdk-core ~2.6.11 and will ERROR on newer versions (~2.7).
# We'll probably have to update again once they release the newest version with commit:
# https://github.com/aws/aws-codedeploy-agent/commit/50db2ec9013cfe8f1a857de53c806d6c67d8d07b
sudo /opt/puppetlabs/puppet/bin/gem install aws-sdk -v '~> 2.6.11'
sudo /opt/puppetlabs/puppet/bin/gem install hiera-eyaml-kms
sudo /opt/puppetlabs/puppet/bin/gem install deep_merge
echo " - Done"
sudo /usr/bin/logger -t autobootstrap "installed puppet gems"
