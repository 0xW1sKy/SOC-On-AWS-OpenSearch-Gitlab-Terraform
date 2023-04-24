output "aws_vpc_id" {
  value = aws_vpc.main
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "aws_subnet_ids" {
  value = {
    private = [
      aws_subnet.Private1,
      aws_subnet.Private2,
    ]
    public = [
      aws_subnet.Public1,
      aws_subnet.Public2,
    ]
  }
}

output "tgw" {
  value = aws_ec2_transit_gateway.tgw
}


output "route_tables" {
  value = {
    private = [
      aws_route_table.RouteTablePrivate1,
      aws_route_table.Private2,
    ]
    public = [
      aws_route_table.RouteTablePublic,
    ]
    transit = [
      aws_ec2_transit_gateway_route_table.tgw_rt
    ]
  }
}

output "region" {
  value = data.aws_region.current.name
}
