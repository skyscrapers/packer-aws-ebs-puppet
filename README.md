# packer-aws-ebs-puppet
Create an AMI from puppet files

## Usage
`PUPPET_REPO="git@github.com:skyscrapers/puppet.git" SOURCE_AMI=ami-0d77397e PROJECT=internal ENVIRONMENT=staging FUNCTION=bastion PACKER_PROFILE=profile_packer_staging make build`

## Variables
* [`SOURCE_AMI`]: The ami to base the packer build on
* [`PROJECT`]: The name of the project, used in facter
* [`ENVIRONMENT`]: The environment, used in facter
* [`FUNCTION`]: The instance function, used in facter
* [`PUPPET_REPO`]: A git url to the puppet files
* [`PACKER_PROFILE`]: The name of the profile to use when running packer
* [`ROOT_VOLUME_SIZE`]: The size (in GiB) of the root volume, default to `8`
* [`ROOT_VOLUME_TYPE`]: The size of the root volume, default to `standard`
* [`DEBUG`]: Add the `--debug` flag in Packer, defaults to false
* [`PUPPET_REPO_PATH`]: Path to the Puppet directory, relative to the Makefile, defaults to `puppet`.
* [`GIT_BRANCH`]: Git branch to use in the Puppet repository, defaults to `master`.
* [`MANAGE_GIT`]: Prepare the Puppet repository by cloning it (if it doesn't exist), checkout `GIT_BRANCH` and pulling latest changes, defaults to `true`.
* [`INSTANCE_TYPE`]: Sets the instance type to build on, defaults to `t2.micro`.
* [`OVERRIDE_RACKER_TEMPLATES`]: You can provide additional [Racker](https://github.com/aspring/racker) templates to override the main packer spec (`json`) file. You need to provide the paths of the templates, relative the this packer repo, and separated by a space.

## Requirements

You need the following to run packer with this repo:

- [Packer](https://www.packer.io/)
- [r10k](https://github.com/puppetlabs/r10k) - `gem install r10k`
- [Racker](https://github.com/aspring/racker) - `gem install racker`
- Git
