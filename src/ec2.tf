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

data "template_file" "bastion_userdata" {
  template = file("${path.module}/files/userdata.template.sh")
  vars = {
    is_bastion = "true"
    bastion_users_bucket = var.bastion_users_bucket
    bastion_scripts_bucket = var.bastion_scripts_bucket
    disallow_shell_script_filename = aws_s3_bucket_object.disallow_shell_script.key
    sync_ssh_keys_script_filename = aws_s3_bucket_object.sync_ssh_keys_script.key
    bastion_cron_filename = aws_s3_bucket_object.bastion_cron.key
  }
}

data "template_file" "bastion_protected_userdata" {
  template = file("${path.module}/files/userdata.template.sh")
  vars = {
    is_bastion = "false"
    bastion_users_bucket = var.bastion_users_bucket
    bastion_scripts_bucket = var.bastion_scripts_bucket
    disallow_shell_script_filename = aws_s3_bucket_object.disallow_shell_script.key
    sync_ssh_keys_script_filename = aws_s3_bucket_object.sync_ssh_keys_script.key
    bastion_cron_filename = aws_s3_bucket_object.bastion_cron.key
  }
}

resource "aws_instance" "bastion_server" {
  count = 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #key_name      = var.ssh_key

  iam_instance_profile = aws_iam_instance_profile.read_bastion_buckets.name
  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
    aws_security_group.bastion.id,
  ]

  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  user_data = data.template_file.bastion_userdata.rendered

  tags = {
    Name = var.project_name
  }
}

resource "aws_instance" "execution_server" {
  count = 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #key_name      = var.ssh_key

  iam_instance_profile   = aws_iam_instance_profile.read_bastion_buckets.name
  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
  ]

  subnet_id = aws_subnet.private[count.index].id

  user_data = data.template_file.bastion_protected_userdata.rendered

  tags = {
    Name = var.project_name
  }
}
