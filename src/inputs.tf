// General
variable "project_name" {}

// Provider
variable "aws_account_id" {}
variable "aws_region" {}

// EC2
variable "bastion_users_bucket" {
  description = "S3 bucket where bastion user's public SSH keys are stored"
}
variable "bastion_instance_type" {
  description = "Instance type to use for the bastion server"
}
variable "execution_instance_type" {
  description = "Instance type to use for the execution server"
}
variable "number_of_instances" {
  description = "Number of bastion and execution replicas"
}

// Cloudflare
variable "cloudflare_email" {
  description = "Email address for the Cloudflare account"
}
variable "cloudflare_api_token" {
  description = "Limited scope Cloudflare API token"
}
variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
}
variable "cloudflare_zone_id" {
  description = "Zone ID for the domain managed by Cloudflare"
}
