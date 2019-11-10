WORKDIR := /workspace
DOCKER_RUN := docker run --rm -it -w $(WORKDIR)
TERRAFORM_IMAGE := hashicorp/terraform:0.12.13
PACKER_IMAGE := hashicorp/packer:light
AWS_VAULT_ENV_VARS := -e AWS_VAULT -e AWS_DEFAULT_REGION -e AWS_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN
TERRAFORM_RUN := $(DOCKER_RUN) -v `pwd`/src:$(WORKDIR):delegated $(AWS_VAULT_ENV_VARS) $(TERRAFORM_IMAGE)
PACKER_RUN := $(DOCKER_RUN) -v `pwd`/packer:$(WORKDIR):delegated $(AWS_VAULT_ENV_VARS) $(PACKER_IMAGE)

all: lint setup plan

lint: validate_packer_template lint_terraform

lint_terraform:
	$(TERRAFORM_RUN) fmt

setup:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) init

plan:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) plan

deploy:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) apply

destroy:
	aws-vault exec worldpeace -- $(TERRAFORM_RUN) destroy

validate_packer_template:
	$(PACKER_RUN) validate base_image.json

build_ami: build_ami_base build_ami_bastion

build_ami_base:
	aws-vault exec worldpeace -- $(PACKER_RUN) build base_image.json

build_ami_bastion:
	aws-vault exec worldpeace -- $(PACKER_RUN) build bastion_image.json
