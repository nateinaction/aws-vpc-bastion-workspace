// General
variable "project_name" {}

// Provider
variable "aws_account_id" {}
variable "aws_region" {}

// EC2
variable "bastion_users_bucket" {
  description = "S3 bucket where bastion user's public SSH keys are stored"
}
variable "bastion_scripts_bucket" {
  description = "S3 bucket where scripts that run on bastion are stored"
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
