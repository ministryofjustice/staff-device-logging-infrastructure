resource "aws_ec2_transit_gateway_vpc_attachment" "transit_gateway_attachment" {
  subnet_ids                                      = var.subnets
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = var.tags
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit_gateway_attachment.id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit_gateway_attachment.id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}
