data "aws_availability_zones" "available" {}

// Subnets
resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                          = aws_vpc.worldpeace_network.id
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.worldpeace_network.cidr_block, 8, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.worldpeace_network.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "worldpeace-network"
  }
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.worldpeace_network.id
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                          = aws_vpc.worldpeace_network.id
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.worldpeace_network.cidr_block, 8, 100 + count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.worldpeace_network.ipv6_cidr_block, 8, 100 + count.index)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "worldpeace-network"
  }
}

resource "aws_route_table_association" "private" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.worldpeace_network.id
}
