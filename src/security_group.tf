// Bastion Security Group
resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Security group for the internet to talk to the bastion servers"
  vpc_id      = aws_vpc.worldpeace_network.id

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

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
  }

  tags = {
    Name = var.project_name
  }
}
