data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_regions" "all" {}
data "aws_regions" "current" {
  all_regions = true

  filter {
    name   = "opt-in-status"
    values = ["opted-in", "opt-in-not-required"]
  }
}
locals {
  additional_log_buckets = [for i in var.additional_log_buckets : "arn:${local.partition}:s3:::${i.bucket_name}"]
  staging_ou             = var.staging_ou   # OU used for testing of delegated security controls form this pipeline
  guardrail_ou           = var.guardrail_ou # Primary OU with security controls applied
  sanitized_region       = replace(local.region, "-", "_")
  account_id             = data.aws_caller_identity.current.account_id
  CI_SERVICE_ACCOUNT_ARN = data.aws_caller_identity.current.arn
  partition              = data.aws_partition.current.partition
  region                 = data.aws_region.current.name
  regions                = toset(flatten([{ for k in data.aws_regions.current.names : "regions" => "logs.${k}.amazonaws.com"... }["regions"]]))
  ElbV2AccountIdMap = {
    # These are the accounts that AWS owns/operates for the ElasticLoadBalancing service.
    # We need to grant these accounts some level of access to write ELB access logs to our S3 Buckets.
    af-south-1     = "098369216593"
    ap-east-1      = "754344448648"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-northeast-3 = "383597477331"
    ap-south-1     = "718504428378"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ap-southeast-3 = "589379963580"
    ca-central-1   = "985666609251"
    cn-north-1     = "638102146993"
    cn-northwest-1 = "037604701340"
    eu-central-1   = "054676820928"
    eu-north-1     = "897822967062"
    eu-south-1     = "635631232127"
    eu-west-1      = "156460612806"
    eu-west-2      = "652711504416"
    eu-west-3      = "009996457667"
    me-south-1     = "076674570225"
    sa-east-1      = "507241528517"
    us-east-1      = "127311923021"
    us-east-2      = "033677994240"
    us-gov-east-1  = "190560391635"
    us-gov-west-1  = "048591011584"
    us-west-1      = "027434742980"
    us-west-2      = "797873946194"
  }
  LambdaArchMap = {
    af-south-1     = "x86_64"
    ap-east-1      = "x86_64"
    ap-northeast-1 = "x86_64"
    ap-northeast-2 = "x86_64"
    ap-northeast-3 = "x86_64"
    ap-south-1     = "x86_64"
    ap-southeast-1 = "x86_64"
    ap-southeast-2 = "x86_64"
    ap-southeast-3 = "x86_64"
    ca-central-1   = "x86_64"
    cn-north-1     = "x86_64"
    cn-northwest-1 = "x86_64"
    eu-central-1   = "x86_64"
    eu-north-1     = "x86_64"
    eu-south-1     = "x86_64"
    eu-west-1      = "x86_64"
    eu-west-2      = "x86_64"
    eu-west-3      = "x86_64"
    me-south-1     = "x86_64"
    sa-east-1      = "x86_64"
    us-east-1      = "x86_64"
    us-east-2      = "x86_64"
    us-gov-east-1  = "x86_64"
    us-gov-west-1  = "x86_64"
    us-west-1      = "x86_64"
    us-west-2      = "x86_64"
  }
  wrangler_layer = {
    ap-northeast-1 = "arn:aws:lambda:ap-northeast-1:336392948345:layer:AWSSDKPandas-Python38:1"
    ap-northeast-2 = "arn:aws:lambda:ap-northeast-2:336392948345:layer:AWSSDKPandas-Python38:1"
    ap-northeast-3 = "arn:aws:lambda:ap-northeast-3:336392948345:layer:AWSSDKPandas-Python38:1"
    ap-south-1     = "arn:aws:lambda:ap-south-1:336392948345:layer:AWSSDKPandas-Python38:1"
    ap-southeast-1 = "arn:aws:lambda:ap-southeast-1:336392948345:layer:AWSSDKPandas-Python38:1"
    ap-southeast-2 = "arn:aws:lambda:ap-southeast-2:336392948345:layer:AWSSDKPandas-Python38:1"
    ca-central-1   = "arn:aws:lambda:ca-central-1:336392948345:layer:AWSSDKPandas-Python38:1"
    eu-central-1   = "arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python38:1"
    eu-north-1     = "arn:aws:lambda:eu-north-1:336392948345:layer:AWSSDKPandas-Python38:1"
    eu-west-1      = "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python38:1"
    eu-west-2      = "arn:aws:lambda:eu-west-2:336392948345:layer:AWSSDKPandas-Python38:1"
    eu-west-3      = "arn:aws:lambda:eu-west-3:336392948345:layer:AWSSDKPandas-Python38:1"
    sa-east-1      = "arn:aws:lambda:sa-east-1:336392948345:layer:AWSSDKPandas-Python38:1"
    us-east-1      = "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python38:1"
    us-east-2      = "arn:aws:lambda:us-east-2:336392948345:layer:AWSSDKPandas-Python38:1"
    us-west-1      = "arn:aws:lambda:us-west-1:336392948345:layer:AWSSDKPandas-Python38:2"
    us-west-2      = "arn:aws:lambda:us-west-2:336392948345:layer:AWSSDKPandas-Python38:2"
  }
  LambdaArch     = local.LambdaArchMap[data.aws_region.current.name]
  ElbV2AccountId = local.ElbV2AccountIdMap[data.aws_region.current.name]

}
