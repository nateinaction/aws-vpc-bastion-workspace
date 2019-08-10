// General
variable "aws_account_id" {}
variable "aws_region" {}

// EC2
variable "ssh_key" {
  description = "SSH key name used to log into EC2 instance"
}
