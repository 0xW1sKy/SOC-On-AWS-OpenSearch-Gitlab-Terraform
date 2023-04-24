locals {
  destination_transit_gateway        = var.destination_transit_gateway_id.id
  destination_transit_gateway_region = var.destination_vpc_region
  destination_vpc_cidr               = var.destination_vpc_cidr
  source_transit_gateway_id          = var.source_transit_gateway_id.id
  source_route_tables                = var.source_route_tables
}

resource "aws_ec2_transit_gateway_peering_attachment" "source" {
  peer_region             = local.destination_transit_gateway_region
  peer_transit_gateway_id = local.destination_transit_gateway
  transit_gateway_id      = local.source_transit_gateway_id
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source.id
  provider                      = aws.dst
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination.id
  transit_gateway_route_table_id = local.source_route_tables.transit[0].id
}

resource "aws_ec2_transit_gateway_route" "tgw_route" {
  destination_cidr_block         = local.destination_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination.id
  transit_gateway_route_table_id = local.source_route_tables.transit[0].id
}

resource "aws_route" "route" {
  destination_cidr_block = local.destination_vpc_cidr
  route_table_id         = local.source_route_tables.private[0].id
  transit_gateway_id     = local.source_transit_gateway_id
}

resource "aws_route" "route2" {
  destination_cidr_block = local.destination_vpc_cidr
  route_table_id         = local.source_route_tables.private[1].id
  transit_gateway_id     = local.source_transit_gateway_id
}

output "aws_route" {
  value = [aws_route.route, aws_route.route2]
}

output "aws_ec2_transit_gateway_route" {
  value = aws_ec2_transit_gateway_route.tgw_route
}

output "aws_ec2_transit_gateway_route_table_association" {
  value = aws_ec2_transit_gateway_route_table_association.tgw_rt_asct
}

output "aws_ec2_transit_gateway_peering_attachment" {
 value = aws_ec2_transit_gateway_peering_attachment.source
}

output "aws_ec2_transit_gateway_peering_attachment_accepter" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.destination
}