provider "aws" {
  version = "~> 2.23.0"
  region  = var.aws_region
}

provider "cloudflare" {
  version    = "~> 2.0"
  email      = var.cloudflare_email
  api_token  = var.cloudflare_api_token
  account_id = var.cloudflare_account_id
}
