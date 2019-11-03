data "aws_availability_zones" "available" {}

// Subnets
resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                          = aws_vpc.network.id
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.network.cidr_block, 8, count.index)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.network.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.network.id
}
