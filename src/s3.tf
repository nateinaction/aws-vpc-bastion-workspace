data "aws_s3_bucket" "bastion_users_bucket" {
  bucket = var.bastion_users_bucket
}

data "aws_s3_bucket" "bastion_scripts_bucket" {
  bucket = var.bastion_scripts_bucket
}

resource "aws_s3_bucket_object" "sync_ssh_keys_script" {
  bucket = data.aws_s3_bucket.bastion_scripts_bucket.bucket
  key    = "sync_ssh_keys.sh"
  source = "${path.module}/files/sync_ssh_keys.sh"
  etag   = filemd5("${path.module}/files/sync_ssh_keys.sh")
}

resource "aws_s3_bucket_object" "disallow_shell_script" {
  bucket = data.aws_s3_bucket.bastion_scripts_bucket.bucket
  key    = "disallow_shell.sh"
  source = "${path.module}/files/disallow_shell.sh"
  etag   = filemd5("${path.module}/files/disallow_shell.sh")
}

resource "aws_s3_bucket_object" "bastion_cron" {
  bucket = data.aws_s3_bucket.bastion_scripts_bucket.bucket
  key    = "bastion_cron"
  source = "${path.module}/files/bastion_cron"
  etag   = filemd5("${path.module}/files/bastion_cron")
}
