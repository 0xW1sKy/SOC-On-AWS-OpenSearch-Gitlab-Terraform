resource "aws_iam_role" "AesSiemSnapshotRoleF313ED39" {
  path               = "/siem/service/opensearch/snapshot/"
  name_prefix        = "aes-siem-os-snapshot-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "opensearchservice.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_policy" "AesSiemSnapshotRoleF313ED39" {
  policy = data.aws_iam_policy_document.AesSiemSnapshotRoleF313ED39.json
}
resource "aws_iam_role_policy_attachment" "AesSiemSnapshotRoleF313ED39" {
  role       = aws_iam_role.AesSiemSnapshotRoleF313ED39.name
  policy_arn = aws_iam_policy.AesSiemSnapshotRoleF313ED39.arn
}

data "aws_iam_policy_document" "AesSiemSnapshotRoleF313ED39" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.S3BucketForSnapshot40E67D36.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}/*"
    ]
  }
}


resource "aws_iam_role" "AesSiemSnsRole64262F46" {
  path               = "/siem/service/opensearch/sns/"
  name_prefix        = "aes-siem-os-sns-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "opensearchservice.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_policy" "AesSiemSnsRole64262F46" {
  policy = data.aws_iam_policy_document.AesSiemSnsRole64262F46.json
}
resource "aws_iam_role_policy_attachment" "AesSiemSnsRole64262F46" {
  role       = aws_iam_role.AesSiemSnsRole64262F46.name
  policy_arn = aws_iam_policy.AesSiemSnsRole64262F46.arn
}
resource "aws_iam_service_linked_role" "opensearchservice" {
  aws_service_name = "opensearchservice.amazonaws.com"
}

data "aws_iam_policy_document" "AesSiemSnsRole64262F46" {
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
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.SnsTopic2C1570A4.arn
    ]
  }
}


###########

resource "aws_iam_role" "LambdaEsLoaderServiceRoleFFD43869" {
  path               = "/siem/service/lambda/loader/"
  name               = "aes-siem-lambda-loader"
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

resource "aws_iam_role_policy_attachment" "LambdaEsLoaderServiceRoleFFD43869_2" {
  role       = aws_iam_role.LambdaEsLoaderServiceRoleFFD43869.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}


resource "aws_iam_policy" "LambdaEsLoaderServiceRoleFFD43869" {
  policy = data.aws_iam_policy_document.LambdaEsLoaderServiceRoleFFD43869.json
}
resource "aws_iam_role_policy_attachment" "LambdaEsLoaderServiceRoleFFD43869" {
  role       = aws_iam_role.LambdaEsLoaderServiceRoleFFD43869.name
  policy_arn = aws_iam_policy.LambdaEsLoaderServiceRoleFFD43869.arn
}

data "aws_iam_policy_document" "LambdaEsLoaderServiceRoleFFD43869" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [for i in var.additional_log_buckets : "${i.iam_assume_role}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.AesSiemDlq1CD8439D.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueUrl",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForGeoip04B5F171.arn,
      "${aws_s3_bucket.S3BucketForGeoip04B5F171.arn}/*"
    ]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"

    ]
    effect    = "Allow"
    resources = [for i in local.additional_log_buckets : "${i}"]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    effect    = "Allow"
    resources = [for i in local.additional_log_buckets : "${i}/*"]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn,
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "es:ESHttp*"
    ]
    resources = [
      "arn:${local.partition}:es:${local.region}:${local.account_id}:domain/${var.opensearch_domain_name}/*"
    ]
  }

}

######

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:${local.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
data "aws_iam_policy" "AmazonOpenSearchServiceFullAccess" {
  arn = "arn:${local.partition}:iam::aws:policy/AmazonOpenSearchServiceFullAccess"
}

resource "aws_iam_role" "AesSiemDeployRoleForLambda654D64F2" {
  path               = "/siem/service/lambda/deploy/"
  name_prefix        = "aes-siem-lambda-deploy-"
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
resource "aws_iam_role_policy_attachment" "AesSiemDeployRoleForLambda654D64F2_3" {
  role       = aws_iam_role.AesSiemDeployRoleForLambda654D64F2.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "AesSiemDeployRoleForLambda654D64F2_2" {
  role       = aws_iam_role.AesSiemDeployRoleForLambda654D64F2.name
  policy_arn = data.aws_iam_policy.AmazonOpenSearchServiceFullAccess.arn
}

resource "aws_iam_policy" "AesSiemDeployRoleForLambda654D64F2" {
  policy = data.aws_iam_policy_document.AesSiemDeployRoleForLambda654D64F2.json

}
resource "aws_iam_role_policy_attachment" "AesSiemDeployRoleForLambda654D64F2" {
  role       = aws_iam_role.AesSiemDeployRoleForLambda654D64F2.name
  policy_arn = aws_iam_policy.AesSiemDeployRoleForLambda654D64F2.arn
}

data "aws_iam_policy_document" "AesSiemDeployRoleForLambda654D64F2" {
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.AesSiemSnapshotRoleF313ED39.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}"
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutResourcePolicy",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:${local.partition}:logs:${data.aws_region.current.name}:${local.account_id}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:${local.partition}:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/aes/domains/aes-siem/*",
      "arn:${local.partition}:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/OpenSearchService/domains/aes-siem/*",
      "arn:${local.partition}:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/aes-siem-*"
    ]
  }
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "events:ListRules",
      "events:PutRule",
      "events:DeleteRule",
      "events:PutTargets",
      "events:RemoveTargets"
    ]
  }
}


resource "aws_iam_role" "LambdaEsLoaderStopperServiceRole83AABC1A" {
  path               = "/siem/service/lambda/stopper/"
  name_prefix        = "aes-siem-lambda-stopper-"
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

resource "aws_iam_role_policy_attachment" "LambdaEsLoaderStopperServiceRole83AABC1A_2" {
  role       = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_policy" "LambdaEsLoaderStopperServiceRole83AABC1A" {
  policy = data.aws_iam_policy_document.LambdaEsLoaderStopperServiceRole83AABC1A.json
}
resource "aws_iam_role_policy_attachment" "LambdaEsLoaderStopperServiceRole83AABC1A" {
  role       = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.name
  policy_arn = aws_iam_policy.LambdaEsLoaderStopperServiceRole83AABC1A.arn
}

data "aws_iam_policy_document" "LambdaEsLoaderStopperServiceRole83AABC1A" {
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.SnsTopic2C1570A4.id
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "lambda:PutFunctionConcurrency"
    ]
    resources = [
      aws_lambda_function.LambdaEsLoader4B1E2DD9.arn
    ]
  }

}


#########



resource "aws_iam_role" "LambdaMetricsExporterServiceRoleDDE0BD95" {
  path               = "/siem/service/lambda/metrics/"
  name_prefix        = "aes-siem-lambda-metrics-"
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
resource "aws_iam_role_policy_attachment" "LambdaMetricsExporterServiceRoleDDE0BD95_2" {
  role       = aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}
resource "aws_iam_policy" "LambdaMetricsExporterServiceRoleDDE0BD95" {
  policy = data.aws_iam_policy_document.LambdaMetricsExporterServiceRoleDDE0BD95.json
}
resource "aws_iam_role_policy_attachment" "LambdaMetricsExporterServiceRoleDDE0BD95" {
  role       = aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.name
  policy_arn = aws_iam_policy.LambdaMetricsExporterServiceRoleDDE0BD95.arn
}

data "aws_iam_policy_document" "LambdaMetricsExporterServiceRoleDDE0BD95" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = [
      data.aws_kms_key.KmsAesSiemLogAliasE0A4C571_by_alias.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject*",
      "s3:PutObject*",
      "s3:Abort*"
    ]
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn,
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/*"
    ]
  }
}



resource "aws_iam_policy" "aessiempolicytoloadentriestoesE6506021" {
  policy = data.aws_iam_policy_document.aessiempolicytoloadentriestoesE6506021.json
}

resource "aws_iam_role_policy_attachment" "aessiempolicytoloadentriestoesE6506021_metricsexporter" {
  role       = aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.name
  policy_arn = aws_iam_policy.aessiempolicytoloadentriestoesE6506021.arn
}

data "aws_iam_policy_document" "aessiempolicytoloadentriestoesE6506021" {
  statement {
    effect = "Allow"
    actions = [
      "es:ESHttp*"
    ]
    resources = [
      "arn:${local.partition}:es:${local.region}:${local.account_id}:domain/${var.opensearch_domain_name}/*"
    ]
  }


}



#########




resource "aws_iam_policy" "aessiempolicytostopesloader4304B8FC" {
  policy = data.aws_iam_policy_document.aessiempolicytostopesloader4304B8FC.json
}
resource "aws_iam_role_policy_attachment" "aessiempolicytostopesloader4304B8FC" {
  role       = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.name
  policy_arn = aws_iam_policy.aessiempolicytostopesloader4304B8FC.arn
}

data "aws_iam_policy_document" "aessiempolicytostopesloader4304B8FC" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:PutFunctionConcurrency"
    ]
    resources = [
      aws_lambda_function.LambdaEsLoader4B1E2DD9.arn
    ]
  }


}



#########


resource "aws_iam_role" "SNS_SERVICE_ROLE" {
  path               = "/siem/service/sns/forwarder/"
  name_prefix        = "aes-siem-sns-forwarder-"
  assume_role_policy = <<AssumeRolePolicyDocument
{
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "sns.amazonaws.com"
        }
    }
    ],
    "Version": "2012-10-17"
}
AssumeRolePolicyDocument
}
resource "aws_iam_role_policy_attachment" "SNS_SERVICE_ROLE_2" {
  role       = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.name
  policy_arn = data.aws_iam_policy.SNS_SERVICE_ROLE.arn
}
resource "aws_iam_policy" "SNS_SERVICE_ROLE" {
  policy = data.aws_iam_policy_document.LambdaEsLoaderStopperServiceRole83AABC1A.json
}
resource "aws_iam_role_policy_attachment" "SNS_SERVICE_ROLE" {
  role       = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.name
  policy_arn = aws_iam_policy.LambdaEsLoaderStopperServiceRole83AABC1A.arn
}

data "aws_iam_policy" "SNS_SERVICE_ROLE" {
  arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonSNSRole"
}

data "aws_iam_policy_document" "SNS_SERVICE_ROLE" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id
      ]
    }
  }
}



#####################


resource "aws_iam_role" "LambdaGeoipDownloaderServiceRoleE37FB908" {
  path               = "/siem/service/lambda/geoip/"
  name_prefix        = "aes-siem-lambda-geoip-"
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
resource "aws_iam_role_policy_attachment" "LambdaGeoipDownloaderServiceRoleE37FB908_3" {
  role       = aws_iam_role.LambdaGeoipDownloaderServiceRoleE37FB908.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_policy" "LambdaGeoipDownloaderServiceRoleE37FB908" {
  policy = data.aws_iam_policy_document.LambdaGeoipDownloaderServiceRoleE37FB908.json

}
resource "aws_iam_role_policy_attachment" "LambdaGeoipDownloaderServiceRoleE37FB908" {
  role       = aws_iam_role.LambdaGeoipDownloaderServiceRoleE37FB908.name
  policy_arn = aws_iam_policy.LambdaGeoipDownloaderServiceRoleE37FB908.arn
}

data "aws_iam_policy_document" "LambdaGeoipDownloaderServiceRoleE37FB908" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*",
      "s3:DeleteObject*",
      "s3:PutObject*",
      "s3:Abort*"
    ]
    resources = [
      "${aws_s3_bucket.S3BucketForGeoip04B5F171.arn}",
      "${aws_s3_bucket.S3BucketForGeoip04B5F171.arn}/*"
    ]
  }
}
