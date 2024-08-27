resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "PublicRoutes"
    Stack = local.Stack
  }
}

resource "aws_route" "gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gtw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "PrivateRoutes"
    Stack = local.Stack
  }
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.subnetA.id
}

# Public Associations
resource "aws_route_table_association" "PublicSubnetA" {
  subnet_id      = aws_subnet.PublicSubnetA.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "PublicSubnetB" {
  subnet_id      = aws_subnet.PublicSubnetB.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "PublicSubnetC" {
  subnet_id      = aws_subnet.PublicSubnetC.id
  route_table_id = aws_route_table.public.id
}

# Private Associations
resource "aws_route_table_association" "PrivateSubnetA" {
  subnet_id      = aws_subnet.PrivateSubnetA.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "PrivateSubnetB" {
  subnet_id      = aws_subnet.PrivateSubnetB.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "PrivateSubnetC" {
  subnet_id      = aws_subnet.PrivateSubnetC.id
  route_table_id = aws_route_table.private.id
}