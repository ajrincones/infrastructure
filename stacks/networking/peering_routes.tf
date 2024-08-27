data "aws_vpc_peering_connection" "alleata_dev" {
  vpc_id          = aws_vpc.main.id
  peer_cidr_block = var.alleata_dev_cidr
}

resource "aws_route" "alleata_dev" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.alleata_dev_cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.alleata_dev.id
}

resource "aws_route" "alleata_dev_public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.alleata_dev_cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.alleata_dev.id
}