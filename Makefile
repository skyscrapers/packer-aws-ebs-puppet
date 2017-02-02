SHELL := /bin/bash
AWS_SOURCE_AMI ?= ami-7abd0209
AWS_REGION ?= eu-west-1
ROOT_VOLUME_SIZE ?= 8
ROOT_VOLUME_TYPE ?= standard

ifeq ($(wildcard ../modules),)
  MODULE_PATHS ?= '"puppet/modules"'
else
  MODULE_PATHS ?= '"puppet/modules","../modules"'
endif

check-variables:


build:
	test -n "$(SOURCE_AMI)"  # $$SOURCE_AMI
	test -n "$(PROJECT)"  # $$PROJECT
	test -n "$(ENVIRONMENT)"  # $$ENVIRONMENT
	test -n "$(FUNCTION)"  # $$FUNCTION
	test -n "$(PUPPET_REPO)"  # $$PUPPET_REPO
	test -n "$(PACKER_PROFILE)" #$$PACKER_PROFILE
	test -n "$(ROOT_VOLUME_SIZE)" #$$ROOT_VOLUME_SIZE
	test -n "$(ROOT_VOLUME_TYPE)" #$$ROOT_VOLUME_TYPE
	if [[ -d "puppet/" ]] && ! git --git-dir=./puppet/.git remote get-url origin | grep --quiet $(PUPPET_REPO); then rm -rf ./puppet; fi
	if [[ ! -d "puppet/" ]]; then git clone $(PUPPET_REPO) puppet; fi
	cd puppet
	if [[ -f Puppetfile]]; then r10k puppetfile install; fi
	git pull && git submodule update --init --recursive
	packer build -var 'aws_region=$(AWS_REGION)' -var 'aws_source_ami=$(SOURCE_AMI)' -var 'project=$(PROJECT)' -var 'environment=$(ENVIRONMENT)' -var 'function=$(FUNCTION)' -var 'root_volume_size=$(ROOT_VOLUME_SIZE)' -var 'root_volume_type=$(ROOT_VOLUME_TYPE)' -var 'aws_ec2_profile=$(PACKER_PROFILE)' -var 'module_paths=$(MODULE_PATHS)' aws.json

clean:
	rm -rf puppet
