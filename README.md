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

### How to ssh into execution

SSH Config:
```
Host bastion
    Hostname bastion.domain.com
    User username
    IdentityFile private_key
Host *.domain.com
    User username
    ForwardAgent no
    ProxyCommand ssh -q -W %h:%p bastion
    IdentityFile private_key
```

SSH:
```
ssh workspace.domain.com

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
```
