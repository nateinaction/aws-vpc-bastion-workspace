terraform {
  backend "s3" {
    bucket         = "worldpeace-terraform-state"
    key            = "network-infrastructure.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "worldpeace-terraform-lock"
  }
}
