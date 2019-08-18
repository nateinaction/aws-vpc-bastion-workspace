// General
variable "project_name" {}

// Provider
variable "aws_account_id" {}
variable "aws_region" {}

// EC2
variable "ssh_key" {
  description = "SSH key name used to log into EC2 instance"
}
variable "bastion_users_bucket" {
  description = "S3 bucket where bastion user's public SSH keys are stored"
}
variable "bastion_scripts_bucket" {
  description = "S3 bucket where scripts that run on bastion are stored"
}
