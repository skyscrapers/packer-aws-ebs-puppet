# packer-aws-ebs-puppet
Create an AMI from puppet files

## Usage
`PUPPET_REPO="git@github.com:skyscrapers/puppet.git" SOURCE_AMI=ami-0d77397e PROJECT=internal ENVIRONMENT=staging FUNCTION=bastion PACKER_PROFILE=profile_packer_staging make build`

## Required variables
* [`SOURCE_AMI`]: The ami to base the packer build on
* [`PROJECT`]: The name of the project, used in facter
* [`ENVIRONMENT`]: The environment, used in facter
* [`FUNCTION`]: The instance function, used in facter
* [`PUPPET_REPO`]: A git url to the puppet files
* [`PACKER_PROFILE`]: The name of the profile to use when running packer
