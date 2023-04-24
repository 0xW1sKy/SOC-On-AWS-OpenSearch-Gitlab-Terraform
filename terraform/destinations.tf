data "aws_organizations_organization" "current" {}

locals {
  old_log_destination_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = ""
        Effect    = "Allow"
        Action    = "logs:PutSubscriptionFilter"
        Principal = "*",
        Resource  = "*"
      }
    ]
  })
  log_destination_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = ""
          Effect    = "Allow"
          Action    = "logs:PutSubscriptionFilter"
          Principal = "*"
          Resource  = "*"
          Condition = {
            StringEquals = {
              "aws:PrincipalOrgID" = ["${data.aws_organizations_organization.current.id}"]
            }
          }
        }
      ]
    }
  )
  raw_log_destination_policy_2 = <<POLICY
{
    "Version" : "2012-10-17",
    "Statement" : [
        {
            "Sid" : "",
            "Effect" : "Allow",
            "Principal" : "*",
            "Action" : "logs:PutSubscriptionFilter",
            "Resource" : "*",
            "Condition": {
               "StringEquals" : {
                   "aws:PrincipalOrgID" : ["${data.aws_organizations_organization.current.id}"]
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudwatch_log_destination" "eunorth1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-eu-north-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.eunorth1
}

resource "aws_cloudwatch_log_destination_policy" "eunorth1" {
  destination_name = aws_cloudwatch_log_destination.eunorth1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.eunorth1
}

resource "aws_cloudwatch_log_destination" "apsouth1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-south-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apsouth1
}

resource "aws_cloudwatch_log_destination_policy" "apsouth1" {
  destination_name = aws_cloudwatch_log_destination.apsouth1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apsouth1
}

resource "aws_cloudwatch_log_destination" "euwest3" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-eu-west-3"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.euwest3
}

resource "aws_cloudwatch_log_destination_policy" "euwest3" {
  destination_name = aws_cloudwatch_log_destination.euwest3.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.euwest3
}

resource "aws_cloudwatch_log_destination" "euwest2" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-eu-west-2"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.euwest2
}

resource "aws_cloudwatch_log_destination_policy" "euwest2" {
  destination_name = aws_cloudwatch_log_destination.euwest2.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.euwest2
}

resource "aws_cloudwatch_log_destination" "euwest1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-eu-west-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.euwest1
}

resource "aws_cloudwatch_log_destination_policy" "euwest1" {
  destination_name = aws_cloudwatch_log_destination.euwest1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.euwest1
}

resource "aws_cloudwatch_log_destination" "apnortheast3" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-northeast-3"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apnortheast3
}

resource "aws_cloudwatch_log_destination_policy" "apnortheast3" {
  destination_name = aws_cloudwatch_log_destination.apnortheast3.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apnortheast3
}

resource "aws_cloudwatch_log_destination" "apnortheast2" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-northeast-2"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apnortheast2
}

resource "aws_cloudwatch_log_destination_policy" "apnortheast2" {
  destination_name = aws_cloudwatch_log_destination.apnortheast2.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apnortheast2
}

resource "aws_cloudwatch_log_destination" "apnortheast1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-northeast-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apnortheast1
}

resource "aws_cloudwatch_log_destination_policy" "apnortheast1" {
  destination_name = aws_cloudwatch_log_destination.apnortheast1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apnortheast1
}

resource "aws_cloudwatch_log_destination" "saeast1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-sa-east-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.saeast1
}

resource "aws_cloudwatch_log_destination_policy" "saeast1" {
  destination_name = aws_cloudwatch_log_destination.saeast1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.saeast1
}

resource "aws_cloudwatch_log_destination" "cacentral1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ca-central-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.cacentral1
}

resource "aws_cloudwatch_log_destination_policy" "cacentral1" {
  destination_name = aws_cloudwatch_log_destination.cacentral1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.cacentral1
}

resource "aws_cloudwatch_log_destination" "apsoutheast1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-southeast-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apsoutheast1
}

resource "aws_cloudwatch_log_destination_policy" "apsoutheast1" {
  destination_name = aws_cloudwatch_log_destination.apsoutheast1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apsoutheast1
}

resource "aws_cloudwatch_log_destination" "apsoutheast2" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-ap-southeast-2"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.apsoutheast2
}

resource "aws_cloudwatch_log_destination_policy" "apsoutheast2" {
  destination_name = aws_cloudwatch_log_destination.apsoutheast2.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.apsoutheast2
}

resource "aws_cloudwatch_log_destination" "eucentral1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-eu-central-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.eucentral1
}

resource "aws_cloudwatch_log_destination_policy" "eucentral1" {
  destination_name = aws_cloudwatch_log_destination.eucentral1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.eucentral1
}

resource "aws_cloudwatch_log_destination" "useast1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-us-east-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.useast1
}

resource "aws_cloudwatch_log_destination_policy" "useast1" {
  destination_name = aws_cloudwatch_log_destination.useast1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.useast1
}

resource "aws_cloudwatch_log_destination" "useast2" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-us-east-2"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.useast2
}

resource "aws_cloudwatch_log_destination_policy" "useast2" {
  destination_name = aws_cloudwatch_log_destination.useast2.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.useast2
}

resource "aws_cloudwatch_log_destination" "uswest1" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-us-west-1"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.uswest1
}

resource "aws_cloudwatch_log_destination_policy" "uswest1" {
  destination_name = aws_cloudwatch_log_destination.uswest1.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.uswest1
}

resource "aws_cloudwatch_log_destination" "uswest2" {
  name       = "${var.CI_ENVIRONMENT_NAME}Destination-us-west-2"
  role_arn   = aws_iam_role.log_role.arn
  target_arn = aws_kinesis_stream.cloudwatch_receiver.arn
  provider   = aws.uswest2
}

resource "aws_cloudwatch_log_destination_policy" "uswest2" {
  destination_name = aws_cloudwatch_log_destination.uswest2.name
  force_update     = true
  access_policy    = local.log_destination_policy
  provider         = aws.uswest2
}