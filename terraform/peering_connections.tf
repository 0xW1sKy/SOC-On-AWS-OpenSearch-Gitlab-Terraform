resource "aws_ec2_transit_gateway_peering_attachment" "source_useast1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_useast1.tgw.id
  provider                = aws.useast1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_useast1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_useast1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_useast1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_useast1.id
  transit_gateway_route_table_id = module.vpc_build_useast1.route_tables.transit[0].id
  provider                       = aws.useast1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_useast1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_useast1.id
  transit_gateway_route_table_id = module.vpc_build_useast1.route_tables.transit[0].id
  provider                       = aws.useast1
}

resource "aws_route" "route_useast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_useast1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_useast1.tgw.id
  provider               = aws.useast1
}

resource "aws_route" "route2_useast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_useast1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_useast1.tgw.id
  provider               = aws.useast1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_useast2" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_useast2.tgw.id
  provider                = aws.useast2
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_useast2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_useast2.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_useast2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_useast2.id
  transit_gateway_route_table_id = module.vpc_build_useast2.route_tables.transit[0].id
  provider                       = aws.useast2
}

resource "aws_ec2_transit_gateway_route" "tgw_route_useast2" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_useast2.id
  transit_gateway_route_table_id = module.vpc_build_useast2.route_tables.transit[0].id
  provider                       = aws.useast2
}

resource "aws_route" "route_useast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_useast2.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_useast2.tgw.id
  provider               = aws.useast2
}

resource "aws_route" "route2_useast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_useast2.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_useast2.tgw.id
  provider               = aws.useast2
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_uswest1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_uswest1.tgw.id
  provider                = aws.uswest1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_uswest1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_uswest1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_uswest1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_uswest1.id
  transit_gateway_route_table_id = module.vpc_build_uswest1.route_tables.transit[0].id
  provider                       = aws.uswest1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_uswest1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_uswest1.id
  transit_gateway_route_table_id = module.vpc_build_uswest1.route_tables.transit[0].id
  provider                       = aws.uswest1
}

resource "aws_route" "route_uswest1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_uswest1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_uswest1.tgw.id
  provider               = aws.uswest1
}

resource "aws_route" "route2_uswest1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_uswest1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_uswest1.tgw.id
  provider               = aws.uswest1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_eunorth1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_eunorth1.tgw.id
  provider                = aws.eunorth1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_eunorth1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_eunorth1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_eunorth1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_eunorth1.id
  transit_gateway_route_table_id = module.vpc_build_eunorth1.route_tables.transit[0].id
  provider                       = aws.eunorth1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_eunorth1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_eunorth1.id
  transit_gateway_route_table_id = module.vpc_build_eunorth1.route_tables.transit[0].id
  provider                       = aws.eunorth1
}

resource "aws_route" "route_eunorth1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_eunorth1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_eunorth1.tgw.id
  provider               = aws.eunorth1
}

resource "aws_route" "route2_eunorth1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_eunorth1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_eunorth1.tgw.id
  provider               = aws.eunorth1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apsouth1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apsouth1.tgw.id
  provider                = aws.apsouth1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apsouth1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apsouth1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apsouth1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsouth1.id
  transit_gateway_route_table_id = module.vpc_build_apsouth1.route_tables.transit[0].id
  provider                       = aws.apsouth1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apsouth1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsouth1.id
  transit_gateway_route_table_id = module.vpc_build_apsouth1.route_tables.transit[0].id
  provider                       = aws.apsouth1
}

resource "aws_route" "route_apsouth1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsouth1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apsouth1.tgw.id
  provider               = aws.apsouth1
}

resource "aws_route" "route2_apsouth1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsouth1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apsouth1.tgw.id
  provider               = aws.apsouth1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_euwest3" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_euwest3.tgw.id
  provider                = aws.euwest3
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_euwest3" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_euwest3.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_euwest3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest3.id
  transit_gateway_route_table_id = module.vpc_build_euwest3.route_tables.transit[0].id
  provider                       = aws.euwest3
}

resource "aws_ec2_transit_gateway_route" "tgw_route_euwest3" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest3.id
  transit_gateway_route_table_id = module.vpc_build_euwest3.route_tables.transit[0].id
  provider                       = aws.euwest3
}

resource "aws_route" "route_euwest3" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest3.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_euwest3.tgw.id
  provider               = aws.euwest3
}

resource "aws_route" "route2_euwest3" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest3.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_euwest3.tgw.id
  provider               = aws.euwest3
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_euwest2" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_euwest2.tgw.id
  provider                = aws.euwest2
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_euwest2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_euwest2.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_euwest2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest2.id
  transit_gateway_route_table_id = module.vpc_build_euwest2.route_tables.transit[0].id
  provider                       = aws.euwest2
}

resource "aws_ec2_transit_gateway_route" "tgw_route_euwest2" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest2.id
  transit_gateway_route_table_id = module.vpc_build_euwest2.route_tables.transit[0].id
  provider                       = aws.euwest2
}

resource "aws_route" "route_euwest2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest2.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_euwest2.tgw.id
  provider               = aws.euwest2
}

resource "aws_route" "route2_euwest2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest2.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_euwest2.tgw.id
  provider               = aws.euwest2
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_euwest1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_euwest1.tgw.id
  provider                = aws.euwest1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_euwest1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_euwest1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_euwest1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest1.id
  transit_gateway_route_table_id = module.vpc_build_euwest1.route_tables.transit[0].id
  provider                       = aws.euwest1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_euwest1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_euwest1.id
  transit_gateway_route_table_id = module.vpc_build_euwest1.route_tables.transit[0].id
  provider                       = aws.euwest1
}

resource "aws_route" "route_euwest1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_euwest1.tgw.id
  provider               = aws.euwest1
}

resource "aws_route" "route2_euwest1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_euwest1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_euwest1.tgw.id
  provider               = aws.euwest1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apnortheast3" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apnortheast3.tgw.id
  provider                = aws.apnortheast3
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apnortheast3" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apnortheast3.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apnortheast3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast3.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast3.route_tables.transit[0].id
  provider                       = aws.apnortheast3
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apnortheast3" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast3.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast3.route_tables.transit[0].id
  provider                       = aws.apnortheast3
}

resource "aws_route" "route_apnortheast3" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast3.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apnortheast3.tgw.id
  provider               = aws.apnortheast3
}

resource "aws_route" "route2_apnortheast3" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast3.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apnortheast3.tgw.id
  provider               = aws.apnortheast3
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apnortheast2" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apnortheast2.tgw.id
  provider                = aws.apnortheast2
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apnortheast2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apnortheast2.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apnortheast2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast2.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast2.route_tables.transit[0].id
  provider                       = aws.apnortheast2
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apnortheast2" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast2.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast2.route_tables.transit[0].id
  provider                       = aws.apnortheast2
}

resource "aws_route" "route_apnortheast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast2.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apnortheast2.tgw.id
  provider               = aws.apnortheast2
}

resource "aws_route" "route2_apnortheast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast2.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apnortheast2.tgw.id
  provider               = aws.apnortheast2
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apnortheast1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apnortheast1.tgw.id
  provider                = aws.apnortheast1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apnortheast1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apnortheast1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apnortheast1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast1.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast1.route_tables.transit[0].id
  provider                       = aws.apnortheast1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apnortheast1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apnortheast1.id
  transit_gateway_route_table_id = module.vpc_build_apnortheast1.route_tables.transit[0].id
  provider                       = aws.apnortheast1
}

resource "aws_route" "route_apnortheast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apnortheast1.tgw.id
  provider               = aws.apnortheast1
}

resource "aws_route" "route2_apnortheast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apnortheast1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apnortheast1.tgw.id
  provider               = aws.apnortheast1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_saeast1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_saeast1.tgw.id
  provider                = aws.saeast1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_saeast1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_saeast1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_saeast1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_saeast1.id
  transit_gateway_route_table_id = module.vpc_build_saeast1.route_tables.transit[0].id
  provider                       = aws.saeast1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_saeast1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_saeast1.id
  transit_gateway_route_table_id = module.vpc_build_saeast1.route_tables.transit[0].id
  provider                       = aws.saeast1
}

resource "aws_route" "route_saeast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_saeast1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_saeast1.tgw.id
  provider               = aws.saeast1
}

resource "aws_route" "route2_saeast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_saeast1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_saeast1.tgw.id
  provider               = aws.saeast1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_cacentral1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_cacentral1.tgw.id
  provider                = aws.cacentral1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_cacentral1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_cacentral1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_cacentral1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_cacentral1.id
  transit_gateway_route_table_id = module.vpc_build_cacentral1.route_tables.transit[0].id
  provider                       = aws.cacentral1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_cacentral1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_cacentral1.id
  transit_gateway_route_table_id = module.vpc_build_cacentral1.route_tables.transit[0].id
  provider                       = aws.cacentral1
}

resource "aws_route" "route_cacentral1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_cacentral1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_cacentral1.tgw.id
  provider               = aws.cacentral1
}

resource "aws_route" "route2_cacentral1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_cacentral1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_cacentral1.tgw.id
  provider               = aws.cacentral1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apsoutheast1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apsoutheast1.tgw.id
  provider                = aws.apsoutheast1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apsoutheast1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apsoutheast1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apsoutheast1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsoutheast1.id
  transit_gateway_route_table_id = module.vpc_build_apsoutheast1.route_tables.transit[0].id
  provider                       = aws.apsoutheast1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apsoutheast1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsoutheast1.id
  transit_gateway_route_table_id = module.vpc_build_apsoutheast1.route_tables.transit[0].id
  provider                       = aws.apsoutheast1
}

resource "aws_route" "route_apsoutheast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsoutheast1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apsoutheast1.tgw.id
  provider               = aws.apsoutheast1
}

resource "aws_route" "route2_apsoutheast1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsoutheast1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apsoutheast1.tgw.id
  provider               = aws.apsoutheast1
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_apsoutheast2" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_apsoutheast2.tgw.id
  provider                = aws.apsoutheast2
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_apsoutheast2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_apsoutheast2.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_apsoutheast2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsoutheast2.id
  transit_gateway_route_table_id = module.vpc_build_apsoutheast2.route_tables.transit[0].id
  provider                       = aws.apsoutheast2
}

resource "aws_ec2_transit_gateway_route" "tgw_route_apsoutheast2" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_apsoutheast2.id
  transit_gateway_route_table_id = module.vpc_build_apsoutheast2.route_tables.transit[0].id
  provider                       = aws.apsoutheast2
}

resource "aws_route" "route_apsoutheast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsoutheast2.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_apsoutheast2.tgw.id
  provider               = aws.apsoutheast2
}

resource "aws_route" "route2_apsoutheast2" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_apsoutheast2.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_apsoutheast2.tgw.id
  provider               = aws.apsoutheast2
}

resource "aws_ec2_transit_gateway_peering_attachment" "source_eucentral1" {
  peer_region             = module.vpc_build_aws.region
  peer_transit_gateway_id = module.vpc_build_aws.tgw.id
  transit_gateway_id      = module.vpc_build_eucentral1.tgw.id
  provider                = aws.eucentral1
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "destination_eucentral1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.source_eucentral1.id
}


resource "aws_ec2_transit_gateway_route_table_association" "tgw_rt_asct_eucentral1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_eucentral1.id
  transit_gateway_route_table_id = module.vpc_build_eucentral1.route_tables.transit[0].id
  provider                       = aws.eucentral1
}

resource "aws_ec2_transit_gateway_route" "tgw_route_eucentral1" {
  destination_cidr_block         = module.vpc_build_aws.aws_vpc_id.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.destination_eucentral1.id
  transit_gateway_route_table_id = module.vpc_build_eucentral1.route_tables.transit[0].id
  provider                       = aws.eucentral1
}

resource "aws_route" "route_eucentral1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_eucentral1.route_tables.private[0].id
  transit_gateway_id     = module.vpc_build_eucentral1.tgw.id
  provider               = aws.eucentral1
}

resource "aws_route" "route2_eucentral1" {
  destination_cidr_block = module.vpc_build_aws.aws_vpc_id.cidr_block
  route_table_id         = module.vpc_build_eucentral1.route_tables.private[1].id
  transit_gateway_id     = module.vpc_build_eucentral1.tgw.id
  provider               = aws.eucentral1
}
