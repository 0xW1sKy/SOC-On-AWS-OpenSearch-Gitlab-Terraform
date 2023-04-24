# * The provider below is an 'example' we should have one module for each region we want to deploy to.

locals {
  server_ip = var.dsm_server_ip


  TrendMicro1 = {
    service_port   = 443
    protocol       = "TCP"
    destination_ip = var.dsm_server_ip # * IP Address of the server you want things routed to
    home_region    = local.region
  }

  TrendMicro2 = {
    service_port   = 4120
    protocol       = "TCP"
    destination_ip = var.dsm_server_ip
    home_region    = local.region
  }

  TrendMicro3 = {
    service_port   = 4122
    protocol       = "TCP"
    destination_ip = var.dsm_server_ip
    home_region    = local.region
  }

  DSMRelay = {
    service_port   = 80
    protocol       = "TCP"
    destination_ip = var.dsm_server_ip
    home_region    = local.region
  }

  all_service_listeners = [
    local.TrendMicro1,
    local.TrendMicro2,
    local.TrendMicro3,
    local.DSMRelay,
  ]
  all_module_listeners = [
    module.listener_uswest2,
    module.listener_useast1,
    module.listener_useast2,
    module.listener_uswest1,
    module.listener_eunorth1,
    module.listener_apsouth1,
    module.listener_euwest3,
    module.listener_euwest2,
    module.listener_euwest1,
    module.listener_apnortheast3,
    module.listener_apnortheast2,
    module.listener_apnortheast1,
    module.listener_saeast1,
    module.listener_cacentral1,
    module.listener_apsoutheast1,
    module.listener_apsoutheast2,
    module.listener_eucentral1
  ]
  all_vpc_builds = [
    module.vpc_build_aws,
    module.vpc_build_useast1,
    module.vpc_build_useast2,
    module.vpc_build_apnortheast1,
    module.vpc_build_apnortheast2,
    module.vpc_build_apnortheast3,
    module.vpc_build_apsouth1,
    module.vpc_build_apsoutheast1,
    module.vpc_build_apsoutheast2,
    module.vpc_build_cacentral1,
    module.vpc_build_eucentral1,
    module.vpc_build_eunorth1,
    module.vpc_build_euwest1,
    module.vpc_build_euwest2,
    module.vpc_build_euwest3,
    module.vpc_build_saeast1,
    module.vpc_build_uswest1
  ]
}

