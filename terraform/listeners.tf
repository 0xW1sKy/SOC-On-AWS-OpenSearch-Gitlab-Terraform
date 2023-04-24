module "listener_uswest2" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_aws.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_aws.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.uswest2
  }
}

module "listener_useast1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_useast1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_useast1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.useast1
  }
}

module "listener_useast2" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_useast2.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_useast2.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.useast2
  }
}

module "listener_uswest1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_uswest1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_uswest1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.uswest1
  }
}

module "listener_eunorth1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_eunorth1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_eunorth1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.eunorth1
  }
}

module "listener_apsouth1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apsouth1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apsouth1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apsouth1
  }
}

module "listener_euwest3" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_euwest3.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_euwest3.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.euwest3
  }
}

module "listener_euwest2" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_euwest2.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_euwest2.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.euwest2
  }
}

module "listener_euwest1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_euwest1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_euwest1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.euwest1
  }
}

module "listener_apnortheast3" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apnortheast3.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apnortheast3.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apnortheast3
  }
}

module "listener_apnortheast2" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apnortheast2.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apnortheast2.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apnortheast2
  }
}

module "listener_apnortheast1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apnortheast1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apnortheast1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apnortheast1
  }
}

module "listener_saeast1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_saeast1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_saeast1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.saeast1
  }
}

module "listener_cacentral1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_cacentral1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_cacentral1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.cacentral1
  }
}

module "listener_apsoutheast1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apsoutheast1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apsoutheast1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apsoutheast1
  }
}

module "listener_apsoutheast2" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_apsoutheast2.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_apsoutheast2.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.apsoutheast2
  }
}

module "listener_eucentral1" {
  source                  = "./privatelink"
  aws_vpc_id              = module.vpc_build_eucentral1.aws_vpc_id
  aws_subnet_ids          = module.vpc_build_eucentral1.aws_subnet_ids.private
  service_listener_config = local.all_service_listeners
  providers = {
    aws = aws.eucentral1
  }
}


