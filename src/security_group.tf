// Bastion Security Group
resource "aws_security_group" "bastion" {
  name        = "bastion-worldpeace-network"
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

  egress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

    cidr_blocks = aws_subnet.private[*].cidr_block
  }

  tags = {
    Name = "worldpeace-network"
  }
}

// Bastion Protected Security Group
resource "aws_security_group" "bastion_protected" {
  name        = "bastion-protected-worldpeace-network"
  description = "Security group for bastion servers to talk to items in the private subnets"
  vpc_id      = aws_vpc.worldpeace_network.id

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

    cidr_blocks = aws_subnet.public[*].cidr_block
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "worldpeace-network"
  }
}
