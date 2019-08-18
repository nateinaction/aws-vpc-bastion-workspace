// VPC
resource "aws_vpc" "network" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.project_name
  }
}

// Internet Gateway
resource "aws_internet_gateway" "network" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table" "network" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.network.id
  }

  tags = {
    Name = var.project_name
  }
}
