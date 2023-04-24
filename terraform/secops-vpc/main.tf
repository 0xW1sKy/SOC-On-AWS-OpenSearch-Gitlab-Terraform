locals {
  CidrMap = {
    us-east-1      = 0
    us-east-2      = 1
    us-west-1      = 2
    us-west-2      = 3
    af-south-1     = 4
    ap-east-1      = 5
    ap-south-1     = 6
    ap-northeast-1 = 7
    ap-northeast-2 = 8
    ap-southeast-1 = 9
    ap-southeast-2 = 10
    ca-central-1   = 11
    eu-central-1   = 12
    eu-west-1      = 13
    eu-west-2      = 14
    eu-west-3      = 15
    eu-south-1     = 16
    eu-north-1     = 17
    me-south-1     = 18
    sa-east-1      = 19
    ap-northeast-3 = 20
  }
  region  = data.aws_region.current.name
  vpccidr = cidrsubnets(var.AccountCidr, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5)
  subnets = cidrsubnets(local.vpccidr[local.CidrMap[local.region]], 3, 3, 3, 3)
  aws_availability_zones = {
    primary   = data.aws_availability_zones.available.names[0]
    secondary = data.aws_availability_zones.available.names[1]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_region" "current" {

}



resource "aws_vpc" "main" {
  cidr_block           = local.vpccidr[local.CidrMap[local.region]]
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_route_table" "RouteTablePublic" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public Route Table"
  }
}
# module.vpc_build_useast2.aws_route_table.Private2
# module.vpc_build_useast2.aws_route_table.RouteTablePrivate1
# module.vpc_build_useast2.aws_route_table.RouteTablePublic
resource "aws_route" "PublicIgw" {
  route_table_id         = aws_route_table.RouteTablePublic.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Igw.id
}

resource "aws_route_table_association" "Public1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.RouteTablePublic.id
}

resource "aws_route_table_association" "Public2" {
  subnet_id      = aws_subnet.Public2.id
  route_table_id = aws_route_table.RouteTablePublic.id
}



resource "aws_route_table" "RouteTablePrivate1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "Private1" {
  route_table_id         = aws_route_table.RouteTablePrivate1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGw1.id
}

resource "aws_route_table_association" "Private1" {
  subnet_id      = aws_subnet.Private1.id
  route_table_id = aws_route_table.RouteTablePrivate1.id
}



resource "aws_route_table" "Private2" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "Private2" {
  route_table_id         = aws_route_table.Private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NatGw2.id
}

resource "aws_route_table_association" "Private2" {
  subnet_id      = aws_subnet.Private2.id
  route_table_id = aws_route_table.Private2.id
}



resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "EipForNatGw1" {
}

resource "aws_nat_gateway" "NatGw1" {
  allocation_id = aws_eip.EipForNatGw1.id
  subnet_id     = aws_subnet.Public1.id

}

resource "aws_eip" "EipForNatGw2" {
}

resource "aws_nat_gateway" "NatGw2" {
  allocation_id = aws_eip.EipForNatGw2.id
  subnet_id     = aws_subnet.Public2.id

}



resource "aws_subnet" "Private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnets[0]
  availability_zone       = local.aws_availability_zones.primary
  map_public_ip_on_launch = false
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnets[2]
  availability_zone       = local.aws_availability_zones.primary
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnets[1]
  availability_zone       = local.aws_availability_zones.secondary
  map_public_ip_on_launch = false
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnets[3]
  availability_zone       = local.aws_availability_zones.secondary
  map_public_ip_on_launch = true
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["127.0.0.1/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["127.0.0.1/32"]
  }
}


resource "aws_security_group" "AllowAccessToVPCEndpoints" {
  name        = "AllowAccessToVPCEndpoints"
  description = "Traffic From EC2 To VPC Endpoint"
  vpc_id      = aws_vpc.main.id
}


resource "aws_security_group" "SecurityGroupForVPCEndpoint" {
  name        = "SecurityGroupForVPCEndpoint"
  description = "Attach to VPC Endpoint to Allow It To Receive Traffic from AllowAccesstoVPCEndpoints SG"
  vpc_id      = aws_vpc.main.id

}

resource "aws_security_group_rule" "EC2VPCEndpointRule" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.SecurityGroupForVPCEndpoint.id
  security_group_id        = aws_security_group.AllowAccessToVPCEndpoints.id
}


resource "aws_security_group_rule" "VPCEndpointEC2Rule" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  security_group_id        = aws_security_group.SecurityGroupForVPCEndpoint.id
  source_security_group_id = aws_security_group.AllowAccessToVPCEndpoints.id
}


resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "TGW Route Integration"
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc" {
  subnet_ids                                      = [aws_subnet.Private1.id, aws_subnet.Private2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = aws_vpc.main.id
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rt_prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route" "tgw_route" {
  destination_cidr_block         = aws_vpc.main.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}
