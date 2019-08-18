data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  name_regex  = "amzn2-ami-hvm-.*-x86_64-ebs"

  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion_server" {
  count = 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #key_name      = var.ssh_key

  iam_instance_profile = aws_iam_instance_profile.bastion.name
  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
    aws_security_group.bastion.id,
  ]

  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  user_data = <<USERDATA
#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Add vars to local env
echo "PUBLIC_KEY_BUCKET=${var.bastion_users_bucket}" >> /etc/environment

# Sync scripts to local filesystem
BIN_DIR='/usr/local/bin'
SCRIPTS_DIR='scripts'
aws s3 sync "s3://${var.bastion_scripts_bucket}" "$SCRIPTS_DIR"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.disallow_shell_script.key}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.sync_ssh_keys_script.key}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.bastion_cron.key}" /etc/cron.d/

# Ensure correct perms
chmod +x "$BIN_DIR/${aws_s3_bucket_object.disallow_shell_script.key}"
chmod +x "$BIN_DIR/${aws_s3_bucket_object.sync_ssh_keys_script.key}"

/usr/local/bin/${aws_s3_bucket_object.sync_ssh_keys_script.key} "${var.bastion_users_bucket}"
USERDATA

  tags = {
    Name = var.project_name
  }
}

resource "aws_instance" "execution_server" {
  count = 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #key_name      = var.ssh_key

  iam_instance_profile   = aws_iam_instance_profile.bastion.name
  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
  ]

  subnet_id = aws_subnet.private[count.index].id

  # TODO Don't duplicate userdata between ec2 instances
  user_data = <<USERDATA
#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

# Add vars to local env
echo "PUBLIC_KEY_BUCKET=${var.bastion_users_bucket}" >> /etc/environment

# Sync scripts to local filesystem
BIN_DIR='/usr/local/bin'
SCRIPTS_DIR='scripts'
aws s3 sync "s3://${var.bastion_scripts_bucket}" "$SCRIPTS_DIR"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.disallow_shell_script.key}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.sync_ssh_keys_script.key}" "$BIN_DIR/"
rsync "$SCRIPTS_DIR/${aws_s3_bucket_object.bastion_cron.key}" /etc/cron.d/

# Ensure correct perms
chmod +x "$BIN_DIR/${aws_s3_bucket_object.disallow_shell_script.key}"
chmod +x "$BIN_DIR/${aws_s3_bucket_object.sync_ssh_keys_script.key}"

/usr/local/bin/${aws_s3_bucket_object.sync_ssh_keys_script.key} "${var.bastion_users_bucket}"
USERDATA

  tags = {
    Name = var.project_name
  }
}
