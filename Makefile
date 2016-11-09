AWS_SOURCE_AMI ?= ami-7abd0209
AWS_REGION ?= eu-west-1

check-variables:


build:
	test -n "$(SOURCE_AMI)"  # $$SOURCE_AMI
	test -n "$(PROJECT)"  # $$PROJECT
	test -n "$(ENVIRONMENT)"  # $$ENVIRONMENT
	test -n "$(FUNCTION)"  # $$FUNCTION
	test -n "$(PUPPET_REPO)"  # $$PUPPET_REPO
	test -n "$(PACKER_PROFILE)" #$$PACKER_PROFILE
	if [[ ! -d "puppet/" ]]; then git clone $(PUPPET_REPO) puppet; fi
	cd puppet && git pull && git submodule update --init --recursive
	packer build --debug -var 'aws_region=$(AWS_REGION)' -var 'aws_source_ami=$(SOURCE_AMI)' -var 'project=$(PROJECT)' -var 'environment=$(ENVIRONMENT)' -var 'function=$(FUNCTION)' -var 'aws_ec2_profile=$(PACKER_PROFILE)' aws.json

clean:
	rm -rf puppet
