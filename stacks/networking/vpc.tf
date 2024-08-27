resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.vpc_dns_hostnames
  enable_dns_support   = var.vpc_dns_support

  tags = {
    Name  = "main"
    Stack = local.Stack
  }
}

resource "aws_main_route_table_association" "main_tables" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}