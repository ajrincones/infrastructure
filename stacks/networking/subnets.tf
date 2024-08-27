resource "aws_subnet" "PrivateSubnetA" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_a_cidr
  availability_zone       = var.private_a_az
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "private-subnet-a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}

resource "aws_subnet" "PublicSubnetA" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_a_cidr
  availability_zone       = var.public_a_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "public-subnet-a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}

resource "aws_subnet" "PrivateSubnetB" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_b_cidr
  availability_zone       = var.private_b_az
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "private-subnet-b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}

resource "aws_subnet" "PublicSubnetB" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_b_cidr
  availability_zone       = var.public_b_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "public-subnet-b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}

resource "aws_subnet" "PrivateSubnetC" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_c_cidr
  availability_zone       = var.private_c_az
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "private-subnet-c (NO INTERNET)"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}

resource "aws_subnet" "PublicSubnetC" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_c_cidr
  availability_zone       = var.public_c_az
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "public-subnet-c"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Stack                                       = local.Stack
  }
}