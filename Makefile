WORKDIR := /workspace
DOCKER_RUN := docker run --rm -it -v `pwd`:$(WORKDIR):delegated
TERRAFORM_IMAGE := hashicorp/terraform:0.12.6
AWS_VAULT_ENV_VARS := -e AWS_VAULT -e AWS_DEFAULT_REGION -e AWS_REGION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN
TERRAFORM_RUN := $(DOCKER_RUN) $(AWS_VAULT_ENV_VARS) $(TERRAFORM_IMAGE)
SRCDIR := $(WORKDIR)/src

all: lint terraform_plan

lint:
	$(TERRAFORM_RUN) /bin/bash -c "cd $(SRCDIR) \
		&& terraform fmt"

terraform_plan:
	aws-vault exec users -- $(TERRAFORM_RUN) /bin/bash -c "cd $(SRCDIR) \
		&& terraform init \
		&& terraform plan"

deploy: terraform_apply

terraform_apply:
	aws-vault exec users -- $(TERRAFORM_RUN) /bin/bash -c "cd $(SRCDIR) \
		&& terraform init \
		&& terraform apply"
