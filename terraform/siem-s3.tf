
resource "aws_s3_bucket_policy" "S3BucketForLogPolicy546D5712" {
  bucket = aws_s3_bucket.S3BucketForLog20898FE4.id
  policy = data.aws_iam_policy_document.S3BucketForLogPolicy546D5712.json
}

data "aws_iam_policy_document" "S3BucketForLogPolicy546D5712" {
  statement {
    sid = "ELB Policy"
    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.ElbV2AccountId}:root"]
    }
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${local.account_id}/*",
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${var.MASTER_ORG_ID}/*",
    ]
  }
  statement {
    sid = "AWSLogDeliveryAclCheck For ALB NLB R53Resolver Flowlogs"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn,
    ]
  }
  statement {
    sid = "AWSLogDeliveryWrite For ALB NLB R53Resolver Flowlogs"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${local.account_id}/*",
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${var.MASTER_ORG_ID}/*",
    ]
  }
  statement {
    sid = "AWSLogDeliveryAclCheck For Cloudtrail"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn
    ]
  }
  statement {
    sid = "AWSLogDeliveryWrite For CloudTrail"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
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
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${local.account_id}/*",
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${var.MASTER_ORG_ID}/*",
    ]
  }
  statement {
    sid = "Allow GuardDuty to use the getBucketLocation operation"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketLocation"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn
    ]
  }
  statement {
    sid = "Allow GuardDuty to upload objects to the bucket"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/*",
    ]
  }
  statement {
    sid = "Deny non-HTTPS access"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    effect = "Deny"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
  statement {
    sid = "AWSConfig BucketPermissionsCheck and BucketExistenceCheck"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.S3BucketForLog20898FE4.arn,
    ]
  }
  statement {
    sid = "AWSConfigBucketDelivery"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
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
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${local.account_id}/Config/*",
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${var.MASTER_ORG_ID}/*/Config/*",
    ]
  }
  statement {
    sid = "AWSCloudTrailAclCheck20150319"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}",
    ]
  }
  statement {
    sid = "AWSCloudTrailWrite20150319"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${local.account_id}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForLog20898FE4.arn}/AWSLogs/${var.MASTER_ORG_ID}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}


resource "aws_s3_bucket" "S3BucketForLog20898FE4" {
  bucket = "aes-siem-${local.account_id}-log"
  depends_on = [
    aws_sns_topic.SnsTopic2C1570A4
  ]
}

resource "aws_s3_bucket_versioning" "S3BucketForLog20898FE4" {
  bucket = aws_s3_bucket.S3BucketForLog20898FE4.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "S3BucketForLog20898FE4" {
  bucket = aws_s3_bucket.S3BucketForLog20898FE4.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "S3BucketForLog20898FE4" {
  bucket = aws_s3_bucket.S3BucketForLog20898FE4.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_s3_bucket_policy" "S3BucketForGeoipPolicy854C0CB1" {
  bucket = aws_s3_bucket.S3BucketForGeoip04B5F171.id
  policy = data.aws_iam_policy_document.S3BucketForGeoipPolicy854C0CB1.json
}

data "aws_iam_policy_document" "S3BucketForGeoipPolicy854C0CB1" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
    effect = "Deny"
    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.S3BucketForGeoip04B5F171.arn,
      "${aws_s3_bucket.S3BucketForGeoip04B5F171.arn}/*",
    ]
  }
}


resource "aws_s3_bucket" "S3BucketForGeoip04B5F171" {
  bucket = "aes-siem-${local.account_id}-geo"
}
resource "aws_s3_bucket_lifecycle_configuration" "S3BucketForGeoip04B5F171" {
  bucket = aws_s3_bucket.S3BucketForGeoip04B5F171.id
  rule {
    id = "delete-ioc-temp-files"
    expiration {
      days                         = 7
      expired_object_delete_marker = false
    }
    filter {
      prefix = "IOC/tmp/"
    }
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "S3BucketForGeoip04B5F171" {
  bucket = aws_s3_bucket.S3BucketForGeoip04B5F171.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "S3BucketForGeoip04B5F171" {
  bucket = aws_s3_bucket.S3BucketForGeoip04B5F171.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "S3BucketForSnapshot40E67D36" {
  bucket = "aes-siem-${local.account_id}-snapshot"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "S3BucketForSnapshot40E67D36" {
  bucket = aws_s3_bucket.S3BucketForSnapshot40E67D36.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "S3BucketForSnapshot40E67D36" {
  bucket = aws_s3_bucket.S3BucketForSnapshot40E67D36.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "S3BucketForSnapshotPolicy3DEBD2C0" {
  bucket = aws_s3_bucket.S3BucketForSnapshot40E67D36.id
  policy = data.aws_iam_policy_document.S3BucketForSnapshotPolicy3DEBD2C0.json
}

data "aws_iam_policy_document" "S3BucketForSnapshotPolicy3DEBD2C0" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
    effect = "Deny"
    resources = [
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}",
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}/*",
    ]
  }
  statement {
    sid = "Allow ES to store snapshot"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.AesSiemSnapshotRoleF313ED39.arn]
    }
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.S3BucketForSnapshot40E67D36.arn}/*",
    ]
  }
}

