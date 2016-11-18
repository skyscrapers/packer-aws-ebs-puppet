AWS_SOURCE_AMI ?= ami-7abd0209

ifeq ($(wildcard ../modules),)
  MODULE_PATHS ?= '"puppet/modules"'
else
  MODULE_PATHS ?= '"puppet/modules", "../modules"'
endif

check-variables:


build:
	test -n "$(SOURCE_AMI)"  # $$SOURCE_AMI
	test -n "$(PROJECT)"  # $$PROJECT
	test -n "$(ENVIRONMENT)"  # $$ENVIRONMENT
	test -n "$(FUNCTION)"  # $$FUNCTION
	test -n "$(PUPPET_REPO)"  # $$PUPPET_REPO
	test -n "$(PACKER_PROFILE)" #$$PACKER_PROFILE
	git clone $(PUPPET_REPO) puppet
	cd puppet && git submodule update --init --recursive
	packer build -var 'aws_source_ami=$(SOURCE_AMI)' -var 'project=$(PROJECT)' -var 'environment=$(ENVIRONMENT)' -var 'function=$(FUNCTION)' -var 'aws_ec2_profile=$(PACKER_PROFILE)' -var 'module_paths=$(MODULE_PATHS)' aws.json

clean:
	rm -rf puppet
