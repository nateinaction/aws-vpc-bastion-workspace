// Bastion Security Group
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Security group for the internet to talk to the bastion servers"
  vpc_id      = aws_vpc.network.id

  # ssh
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  # mosh
  ingress {
    from_port = "60000"
    to_port   = "61000"
    protocol  = "udp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  # TODO remove internet access from bastion
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]

    ipv6_cidr_blocks = [
      "::/0"
    ]
  }

  tags = {
    Name = var.project_name
  }
}
