resource "aws_route53_zone" "public" {
  name    = "conexa.ai"
  comment = "Public Conexa Zone"

  tags = {
    Stack = local.Stack
  }
}

resource "aws_route53_zone" "private" {
  name    = "conexa.ai"
  comment = "Private Conexa Zone"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  vpc {
    vpc_id = var.alleata_dev_vpc_id
  }

  tags = {
    Stack = local.Stack
  }
}