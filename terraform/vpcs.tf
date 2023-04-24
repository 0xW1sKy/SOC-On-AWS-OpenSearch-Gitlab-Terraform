
module "vpc_build_aws" {
  source = "./secops-vpc"
  providers = {
    aws = aws
  }
}

module "vpc_build_useast1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.useast1
  }
}

module "vpc_build_useast2" {
  source = "./secops-vpc"
  providers = {
    aws = aws.useast2
  }
}

module "vpc_build_uswest1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.uswest1
  }
}

module "vpc_build_eunorth1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.eunorth1
  }
}

module "vpc_build_apsouth1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apsouth1
  }
}

module "vpc_build_euwest3" {
  source = "./secops-vpc"
  providers = {
    aws = aws.euwest3
  }
}

module "vpc_build_euwest2" {
  source = "./secops-vpc"
  providers = {
    aws = aws.euwest2
  }
}

module "vpc_build_euwest1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.euwest1
  }
}

module "vpc_build_apnortheast3" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apnortheast3
  }
}

module "vpc_build_apnortheast2" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apnortheast2
  }
}

module "vpc_build_apnortheast1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apnortheast1
  }
}

module "vpc_build_saeast1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.saeast1
  }
}

module "vpc_build_cacentral1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.cacentral1
  }
}

module "vpc_build_apsoutheast1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apsoutheast1
  }
}

module "vpc_build_apsoutheast2" {
  source = "./secops-vpc"
  providers = {
    aws = aws.apsoutheast2
  }
}

module "vpc_build_eucentral1" {
  source = "./secops-vpc"
  providers = {
    aws = aws.eucentral1
  }
}

