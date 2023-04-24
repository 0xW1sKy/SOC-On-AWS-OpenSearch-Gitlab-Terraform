terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
    local = {
      version = "~> 2.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
    # onelogin = {
    #   source  = "onelogin/onelogin"
    #   version = "0.1.23"
    # }
  }
  backend "http" {}
}

# TODO: Make OneLogin Integration Modular.
# Uncomment the OneLogin Sections for setting up SSO when you create your Environment.
# provider "onelogin" {
#   client_id     = var.ONELOGIN_CLIENT_ID
#   client_secret = var.ONELOGIN_CLIENT_SECRET
# }

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "eunorth1"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "apsouth1"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "euwest3"
  region = "eu-west-3"
}

provider "aws" {
  alias  = "euwest2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "euwest1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "apnortheast3"
  region = "ap-northeast-3"
}

provider "aws" {
  alias  = "apnortheast2"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "apnortheast1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "saeast1"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "cacentral1"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "apsoutheast1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "apsoutheast2"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "eucentral1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "useast2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "uswest1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "uswest2"
  region = "us-west-2"
}
