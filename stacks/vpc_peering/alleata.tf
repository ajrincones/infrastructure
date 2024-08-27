resource "aws_vpc_peering_connection" "alleata_dev" {
  peer_owner_id = var.alleata_dev_account_id
  peer_vpc_id   = var.alleata_dev_vpc_id
  vpc_id        = var.shared_vpc_id

  tags = {
    Name  = "Shared:Alleata-dev"
    Stack = local.Stack
  }
}

resource "aws_vpc_peering_connection_accepter" "alleata_dev" {
  provider                  = aws.alleata_dev
  vpc_peering_connection_id = aws_vpc_peering_connection.alleata_dev.id
  auto_accept               = true

  tags = {
    Name  = "Shared:Alleata-dev"
    Stack = local.Stack
  }

  depends_on = [
    aws_vpc_peering_connection.alleata_dev
  ]
}

resource "aws_vpc_peering_connection_options" "alleata_dev" {
  vpc_peering_connection_id = aws_vpc_peering_connection.alleata_dev.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.alleata_dev
  ]
}

resource "aws_vpc_peering_connection_options" "alleata_dev_provider" {
  provider                  = aws.alleata_dev
  vpc_peering_connection_id = aws_vpc_peering_connection.alleata_dev.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.alleata_dev
  ]
}

resource "aws_route53_vpc_association_authorization" "alleata_dev" {
  vpc_id  = var.alleata_dev_vpc_id
  zone_id = var.r53_zone_id_private

  depends_on = [
    aws_vpc_peering_connection_options.alleata_dev
  ]
}

resource "aws_route53_zone_association" "alleata_dev" {
  provider = aws.alleata_dev

  vpc_id  = var.alleata_dev_vpc_id
  zone_id = var.r53_zone_id_private

  depends_on = [
    aws_route53_vpc_association_authorization.alleata_dev
  ]
}