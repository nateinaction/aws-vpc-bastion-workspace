data "aws_ami" "ubuntu" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["worldpeace-aws-ubuntu-*"]
  }
}

data "template_file" "bastion_userdata" {
  template = file("${path.module}/files/userdata.template.sh")
  vars = {
    is_bastion           = "true"
    bastion_users_bucket = var.bastion_users_bucket
  }
}

data "template_file" "bastion_protected_userdata" {
  template = file("${path.module}/files/userdata.template.sh")
  vars = {
    is_bastion           = "false"
    bastion_users_bucket = var.bastion_users_bucket
  }
}

resource "aws_instance" "bastion_server" {
  count = var.number_of_instances

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.bastion_instance_type
  iam_instance_profile = aws_iam_instance_profile.read_bastion_buckets.name

  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
    aws_security_group.bastion.id,
  ]
  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  ebs_optimized = true
  root_block_device {
    encrypted = true
  }
  user_data = data.template_file.bastion_userdata.rendered

  tags = {
    Name = var.project_name
  }
}

resource "aws_instance" "execution_server" {
  count = var.number_of_instances

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.execution_instance_type
  iam_instance_profile = aws_iam_instance_profile.read_bastion_buckets.name

  vpc_security_group_ids = [
    aws_vpc.network.default_security_group_id,
  ]
  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  ebs_optimized = true
  root_block_device {
    encrypted = true
  }
  user_data = data.template_file.bastion_protected_userdata.rendered

  tags = {
    Name = var.project_name
  }
}
