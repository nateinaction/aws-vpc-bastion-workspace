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
  key_name      = var.ssh_key

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]

  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  tags = {
    Name = "worldpeace-network"
  }
}

resource "aws_instance" "execution_server" {
  count = 0

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.ssh_key

  vpc_security_group_ids = [
    aws_security_group.bastion_protected.id,
  ]

  subnet_id = aws_subnet.private[count.index]
  tags = {
    Name = "worldpeace-network"
  }
}
