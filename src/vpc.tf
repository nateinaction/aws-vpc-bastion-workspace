// VPC
resource "aws_vpc" "worldpeace_network" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "worldpeace-network"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "worldpeace_network" {
  vpc_id = aws_vpc.worldpeace_network.id

  tags = {
    Name = "worldpeace-network"
  }
}

resource "aws_route_table" "worldpeace_network" {
  vpc_id = aws_vpc.worldpeace_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.worldpeace_network.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.worldpeace_network.id
  }

  tags = {
    Name = "worldpeace-network"
  }
}
