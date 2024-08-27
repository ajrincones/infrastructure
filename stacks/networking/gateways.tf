# Create Internet Gateway
resource "aws_internet_gateway" "gtw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "main"
    Stack = local.Stack
  }
}

# Create the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  count  = 2

  tags = {
    Name  = "NAT Gateways"
    Stack = local.Stack
  }
}

resource "aws_nat_gateway" "subnetA" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.PublicSubnetA.id


  tags = {
    Name  = "PublicSubnetA"
    Stack = local.Stack
  }
}

resource "aws_nat_gateway" "subnetB" {
  allocation_id = aws_eip.nat[1].id
  subnet_id     = aws_subnet.PublicSubnetB.id


  tags = {
    Name  = "PublicSubnetB"
    Stack = local.Stack
  }
}
