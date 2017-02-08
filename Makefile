SHELL := /bin/bash
AWS_SOURCE_AMI ?= ami-7abd0209
AWS_REGION ?= eu-west-1
ROOT_VOLUME_SIZE ?= 8
ROOT_VOLUME_TYPE ?= standard
MANIFEST_FILE ?= puppet/manifests/default.pp
HIERA_CONFIG_PATH ?= puppet/hiera/hiera.yaml
GIT_BRANCH ?= master

ifeq ($(wildcard ../modules),)
  MODULE_PATHS ?= '"puppet/modules"'
else
  MODULE_PATHS ?= '"puppet/modules","../modules"'
endif

check-variables:

init:
	test -n "$(SOURCE_AMI)"  # $$SOURCE_AMI
	test -n "$(PROJECT)"  # $$PROJECT
	test -n "$(ENVIRONMENT)"  # $$ENVIRONMENT
	test -n "$(FUNCTION)"  # $$FUNCTION
	test -n "$(PUPPET_REPO)"  # $$PUPPET_REPO
	test -n "$(PACKER_PROFILE)" #$$PACKER_PROFILE

	if [[ -d "puppet/" ]] && ! git --git-dir=./puppet/.git remote get-url origin | grep --quiet $(PUPPET_REPO); then rm -rf ./puppet; fi
	if [[ ! -d "puppet/" ]]; then git clone -b $(GIT_BRANCH) $(PUPPET_REPO) puppet; fi
	cd puppet && git pull && git checkout $(GIT_BRANCH) && git submodule update --init --recursive
	if [[ -e "puppet/Puppetfile" ]]; then cd puppet; r10k puppetfile install; fi

build: init
	packer build -var 'aws_region=$(AWS_REGION)' -var 'aws_source_ami=$(SOURCE_AMI)' -var 'project=$(PROJECT)' -var 'environment=$(ENVIRONMENT)' -var 'function=$(FUNCTION)' -var 'root_volume_size=$(ROOT_VOLUME_SIZE)' -var 'root_volume_type=$(ROOT_VOLUME_TYPE)' -var 'aws_ec2_profile=$(PACKER_PROFILE)' -var 'hiera_config_path=$(HIERA_CONFIG_PATH)' -var 'manifest_file=$(MANIFEST_FILE)' -var 'module_paths=$(MODULE_PATHS)' aws.json

clean:
	rm -rf puppet
