# network-infrastructure

### Setup
- Verify Docker and brew installed locally
- Install aws-vault: `brew install aws-vault`
- Setup your aws account creds: `aws-vault add worldpeace`
- You may want to setup a `terraform.tfvars` with any information that is requested during the deploy

### How to lint and test infrastructure changes
- `make`

### How to deploy
- `make deploy`
