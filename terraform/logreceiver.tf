

data "aws_iam_policy_document" "logs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.regions
    }
  }
}

resource "aws_iam_role" "log_role" {
  assume_role_policy  = data.aws_iam_policy_document.logs_assume_role_policy.json
  path                = "/beacon/logrole/"
  managed_policy_arns = [aws_iam_policy.cloudwatch_receiver_logpolicy.arn]
}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_kms_key" "kmskey" {
  description             = "Beacon Kinesis Key"
  is_enabled              = true
  enable_key_rotation     = true
  deletion_window_in_days = 7
  multi_region            = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json

}


resource "aws_kms_alias" "kmskey" {
  name          = "alias/beacon_cloudwatch"
  target_key_id = aws_kms_key.kmskey.key_id
}

resource "aws_kinesis_stream" "cloudwatch_receiver" {
  name             = "${var.CI_ENVIRONMENT_NAME}-DataStream-${data.aws_region.current.name}"
  shard_count      = 1
  retention_period = 48
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_alias.kmskey.arn
}

data "aws_iam_policy_document" "kinesispolicy" {
  statement {

    actions = [
      "kinesis:PutRecord"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      "${aws_kms_alias.kmskey.arn}"
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }
}


resource "aws_iam_policy" "cloudwatch_receiver_logpolicy" {
  policy = data.aws_iam_policy_document.kinesispolicy.json
}

resource "aws_cloudwatch_log_group" "kinesis-logs" {
  name              = "/aws/kinesisfirehose/${var.CI_ENVIRONMENT_NAME}-DeliveryStream-${local.region}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "kinesis-log-stream" {
  name           = "${var.CI_ENVIRONMENT_NAME}-DeliveryStream-${local.region}"
  log_group_name = aws_cloudwatch_log_group.kinesis-logs.name
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.CI_ENVIRONMENT_NAME}-DeliveryStream-${data.aws_region.current.name}"
  destination = "extended_s3"
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.cloudwatch_receiver.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }




  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.bucket.arn
    buffer_size        = 50
    buffer_interval    = 60
    compression_format = "UNCOMPRESSED"
    kms_key_arn        = aws_kms_alias.kmskey.arn

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis-logs.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis-log-stream.name
    }

    processing_configuration {
      enabled = "false"
    }
  }
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "aws/s3"
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  acl    = "private"
}

resource "aws_s3_bucket" "access_logs" {
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "s3/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.kmskey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "bucket" {
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket                  = aws_s3_bucket.access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "firehose_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

  }
}

resource "aws_iam_role" "firehose_role" {
  assume_role_policy  = data.aws_iam_policy_document.firehose_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.firehose_policy.arn]
  path                = "/beacon/firehoserole/"
}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

data "aws_kms_key" "by_alias" {
  key_id = data.aws_kms_alias.s3.id
}


resource "aws_iam_policy" "firehose_policy" {
  policy = data.aws_iam_policy_document.firehose_policy.json
}

data "aws_iam_policy_document" "firehose_policy" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = ["${aws_s3_bucket.bucket.arn}"]
  }

  statement {
    actions = [
      "glue:GetTableVersions"
    ]

    resources = ["*"]
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
      "arn:${local.partition}:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/kinesisfirehose/${var.CI_ENVIRONMENT_NAME}-DeliveryStream-*",
    ]
  }

  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      variable = "kms:RequestAlias"
      values = [
        "alias/aws/s3"
      ]
    }
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [
      "${aws_kms_alias.kmskey.arn}"
    ]
  }
}



data "aws_iam_policy_document" "log_destination_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["var.trusted_role_arn"]
    }

    actions = [
      "logs:PutSubscriptionFilter"
    ]

    resources = [
      "${aws_cloudwatch_log_destination.uswest2.arn}"
    ]
  }
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}",
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    sid = "FirehoseDeliveryStreamWriteForS3"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}",
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    sid = "FirehoseDeliveryStreamWrite For S3"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "beacon" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
