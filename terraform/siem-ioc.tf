
resource "aws_iam_role" "LambdaIocPlanServiceRole6CDE7C5D" {
  path               = "/siem/service/ioc/lambda/"
  name_prefix        = "aes-siem-ioc-lambda-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_policy" "LambdaIocPlanServiceRole6CDE7C5D" {
  policy = data.aws_iam_policy_document.LambdaIocPlanServiceRole6CDE7C5D.json
}
resource "aws_iam_role_policy_attachment" "LambdaIocPlanServiceRole6CDE7C5D" {
  role       = aws_iam_role.LambdaIocPlanServiceRole6CDE7C5D.name
  policy_arn = aws_iam_policy.LambdaIocPlanServiceRole6CDE7C5D.arn
}

resource "aws_iam_role_policy_attachment" "LambdaIocPlanServiceRole6CDE7C5D_2" {
  role       = aws_iam_role.LambdaIocPlanServiceRole6CDE7C5D.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

data "aws_iam_policy_document" "LambdaIocPlanServiceRole6CDE7C5D" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    effect = "Allow"
    resources = [
      data.aws_kms_key.KmsAesSiemLogAliasE0A4C571_by_alias.arn
    ]
  }
  statement {
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*",
      "s3:DeleteObject*",
      "s3:PutObject*",
      "s3:Abort*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForGeoip04B5F171.arn,
      "${aws_s3_bucket.S3BucketForGeoip04B5F171.arn}/*"
    ]
  }
}

resource "aws_lambda_function" "LambdaIocPlan6E369BFB" {
  architectures = [
    "${local.regional_architecture}"
  ]
  description      = "Siem on Amazon OpenSearch Service v2.8.0c / ioc-plan"
  filename         = data.archive_file.lambda_zips["ioc_database"].output_path
  source_code_hash = data.archive_file.lambda_zips["ioc_database"].output_base64sha256
  function_name    = "aes-siem-ioc-plan"
  handler          = "lambda_function.plan"
  role             = aws_iam_role.LambdaIocPlanServiceRole6CDE7C5D.arn
  runtime          = "python3.8"
  timeout          = 300
  memory_size      = 128
  environment {
    variables = {
      ABUSE_CH     = "False"
      GEOIP_BUCKET = aws_s3_bucket.S3BucketForGeoip04B5F171.id
      LOG_LEVEL    = "WARNING"
      OTX_API_KEY  = var.otx_api_key
      TOR          = "False"

    }
  }
}


resource "aws_lambda_function" "LambdaIocCreatedb04F35777" {
  architectures = [
    "${local.regional_architecture}"
  ]
  description      = "Siem on Amazon OpenSearch Service v2.8.0c / ioc-plan"
  filename         = data.archive_file.lambda_zips["ioc_database"].output_path
  source_code_hash = data.archive_file.lambda_zips["ioc_database"].output_base64sha256
  function_name    = "aes-siem-ioc-createdb"
  handler          = "lambda_function.createdb"
  role             = aws_iam_role.LambdaIocPlanServiceRole6CDE7C5D.arn
  runtime          = "python3.8"
  timeout          = 900
  memory_size      = 192
  environment {
    variables = {
      ABUSE_CH     = "False"
      GEOIP_BUCKET = aws_s3_bucket.S3BucketForGeoip04B5F171.id
      LOG_LEVEL    = "WARNING"
      OTX_API_KEY  = var.otx_api_key
      TOR          = "False"

    }
  }
}



resource "aws_lambda_function" "LambdaIocDownload5519716E" {
  architectures = [
    "${local.regional_architecture}"
  ]
  description      = "Siem on Amazon OpenSearch Service v2.8.0c / ioc-plan"
  filename         = data.archive_file.lambda_zips["ioc_database"].output_path
  source_code_hash = data.archive_file.lambda_zips["ioc_database"].output_base64sha256
  function_name    = "aes-siem-ioc-download"
  handler          = "lambda_function.download"
  role             = aws_iam_role.LambdaIocPlanServiceRole6CDE7C5D.arn
  runtime          = "python3.8"
  timeout          = 900
  memory_size      = 384
  environment {
    variables = {
      ABUSE_CH     = "False"
      GEOIP_BUCKET = aws_s3_bucket.S3BucketForGeoip04B5F171.id
      LOG_LEVEL    = "WARNING"
      OTX_API_KEY  = var.otx_api_key
      TOR          = "False"

    }
  }
}

resource "aws_cloudwatch_log_group" "IocStateMachineLogGroupC1AB417E" {
  name              = "/aws/vendedlogs/states/aes-siem-ioc-logs"
  retention_in_days = 30
  skip_destroy      = true

}






resource "aws_iam_role" "IocStateMachineRole095AC46F" {
  path               = "/siem/service/ioc/states/"
  name_prefix        = "aes-siem-ioc-states-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "states.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_policy" "IocStateMachineRole095AC46F" {
  policy = data.aws_iam_policy_document.IocStateMachineRole095AC46F.json
}
resource "aws_iam_role_policy_attachment" "IocStateMachineRole095AC46F" {
  role       = aws_iam_role.IocStateMachineRole095AC46F.name
  policy_arn = aws_iam_policy.IocStateMachineRole095AC46F.arn
}

data "aws_iam_policy_document" "IocStateMachineRole095AC46F" {
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    effect = "Allow"
    resources = [
      aws_lambda_function.LambdaIocPlan6E369BFB.arn,
      aws_lambda_function.LambdaIocCreatedb04F35777.arn,
      aws_lambda_function.LambdaIocDownload5519716E.arn
    ]
  }
}



resource "aws_sfn_state_machine" "IocStateMachine01BE6E56" {
  name_prefix = "aes-siem-ioc-state-"
  role_arn    = aws_iam_role.IocStateMachineRole095AC46F.arn
  definition  = <<EOF
{
    "StartAt": "IocPlan",
    "States": {
        "IocPlan": {
            "Next": "MapDownload",
            "Retry": [{
                "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
            }],
            "Type": "Task",
            "OutputPath": "$.Payload",
            "Resource": "arn:${local.partition}:states:::lambda:invoke",
            "Parameters": {
                "FunctionName": "${aws_lambda_function.LambdaIocPlan6E369BFB.arn}",
                "Payload": ""
            }
        },
        "MapDownload": {
            "Type": "Map",
            "Next": "IocCreatedb",
            "Parameters": {
                "mapped.$": "$$.Map.Item.Value"
            },
            "Iterator": {
                "StartAt": "IocDownload",
                "States": {
                    "IocDownload": {
                        "End": true,
                        "Retry": [{
                            "ErrorEquals": [
                                "Lambda.ServiceException",
                                "Lambda.AWSLambdaException",
                                "Lambda.SdkClientException"
                            ],
                            "IntervalSeconds": 2,
                            "MaxAttempts": 6,
                            "BackoffRate": 2
                        }],
                        "Type": "Task",
                        "OutputPath": "$.Payload",
                        "Resource": "arn:${local.partition}:states:::lambda:invoke",
                        "Parameters": {
                            "FunctionName": "${aws_lambda_function.LambdaIocDownload5519716E.arn}",
                            "Payload.$": "$"
                        }
                    }
                }
            },
            "ItemsPath": "$.mapped",
            "MaxConcurrency": 6
        },
        "IocCreatedb": {
            "End": true,
            "Retry": [{
                "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException"
                ],
                "IntervalSeconds": 2,
                "MaxAttempts": 6,
                "BackoffRate": 2
            }],
            "Type": "Task",
            "Resource": "arn:${local.partition}:states:::lambda:invoke",
            "Parameters": {
                "FunctionName": "${aws_lambda_function.LambdaIocCreatedb04F35777.arn}",
                "Payload.$": "$"
            }
        }
    },
    "TimeoutSeconds": 3600
}
EOF
  logging_configuration {
    level           = "ALL"
    log_destination = "${aws_cloudwatch_log_group.IocStateMachineLogGroupC1AB417E.arn}:*"
  }
}




resource "aws_iam_role" "IocStateMachineEventsRoleC1BF1919" {
  path               = "/siem/service/ioc/events/"
  name_prefix        = "aes-siem-ioc-events-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "events.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_policy" "IocStateMachineEventsRoleC1BF1919" {
  policy = data.aws_iam_policy_document.IocStateMachineEventsRoleC1BF1919.json
}
resource "aws_iam_role_policy_attachment" "IocStateMachineEventsRoleC1BF1919" {
  role       = aws_iam_role.IocStateMachineEventsRoleC1BF1919.name
  policy_arn = aws_iam_policy.IocStateMachineEventsRoleC1BF1919.arn
}


data "aws_iam_policy_document" "IocStateMachineEventsRoleC1BF1919" {
  statement {
    actions = [
      "states:StartExecution",
    ]
    effect = "Allow"
    resources = [
      aws_sfn_state_machine.IocStateMachine01BE6E56.arn
    ]
  }
}


### CloudWatch Event Rule & Pattern to watch for
resource "aws_cloudwatch_event_rule" "IOCTrigger" {
  description         = "IOCTrigger"
  schedule_expression = "rate(5 minutes)"
  is_enabled          = true
}


resource "aws_cloudwatch_event_target" "controltowerlambda" {
  rule     = aws_cloudwatch_event_rule.IOCTrigger.name
  arn      = aws_sfn_state_machine.IocStateMachine01BE6E56.arn
  role_arn = aws_iam_role.IocStateMachineEventsRoleC1BF1919.arn
}








