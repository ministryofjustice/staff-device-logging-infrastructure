resource "aws_vpc_peering_connection" "this" {
  count = var.enabled ? 1 : 0

  peer_owner_id = var.target_aws_account_id
  peer_vpc_id   = var.target_vpc_id
  vpc_id        = var.source_vpc_id

  tags = var.tags
}

resource "aws_route" "peering_route" {
  count = var.enabled ? length(var.source_route_table_ids) : 0

  route_table_id = var.source_route_table_ids[count.index]

  destination_cidr_block    = var.target_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
  depends_on                = [aws_vpc_peering_connection.this]
}
