.PHONY: all

SHELL := /bin/bash
SOURCE_AMI ?= ami-7abd0209
AWS_REGION ?= eu-west-1
ROOT_VOLUME_SIZE ?= 8
ROOT_VOLUME_TYPE ?= standard
GIT_BRANCH ?= master
DEBUG ?= false
PUPPET_REPO_PATH ?= puppet
MANAGE_GIT ?= true

MANIFEST_FILE ?= $(PUPPET_REPO_PATH)/manifests/default.pp
HIERA_PATH ?= $(PUPPET_REPO_PATH)/hiera
HIERA_CONFIG_PATH ?= $(HIERA_PATH)/hiera.yaml

ifeq ($(wildcard ../modules),)
  MODULE_PATHS ?= '"$(PUPPET_REPO_PATH)/modules"'
else
  MODULE_PATHS ?= '"$(PUPPET_REPO_PATH)/modules","../modules"'
endif

ifeq ($(DEBUG),true)
  DEBUG_FLAG ?= -debug
else
  DEBUG_FLAG ?=
endif

check-variables:

init:
ifeq ($(MANAGE_GIT),true)
	./scripts/init_git.sh
endif
	if [[ -e "$(PUPPET_REPO_PATH)/Puppetfile" ]]; then cd $(PUPPET_REPO_PATH); r10k puppetfile install; fi

build: init
	test -n "$(PACKER_PROFILE)" #$$PACKER_PROFILE
	test -n "$(SOURCE_AMI)"  # $$SOURCE_AMI
	test -n "$(ENVIRONMENT)"  # $$ENVIRONMENT
	test -n "$(PROJECT)"  # $$PROJECT
	test -n "$(FUNCTION)"  # $$FUNCTION
	test -n "$(AWS_REGION)"  # $$AWS_REGION

	packer build $(DEBUG_FLAG) -var 'share_accounts=$(SHARE_ACCOUNTS)'  -var 'aws_region=$(AWS_REGION)' -var 'aws_source_ami=$(SOURCE_AMI)' -var 'project=$(PROJECT)' -var 'environment=$(ENVIRONMENT)' -var 'function=$(FUNCTION)' -var 'root_volume_size=$(ROOT_VOLUME_SIZE)' -var 'root_volume_type=$(ROOT_VOLUME_TYPE)' -var 'aws_ec2_profile=$(PACKER_PROFILE)' -var 'hiera_config_path=$(HIERA_CONFIG_PATH)' -var 'hiera_path=$(HIERA_PATH)/' -var 'manifest_file=$(MANIFEST_FILE)' -var 'module_paths=$(MODULE_PATHS)' aws.json

clean:
	rm -rf puppet
