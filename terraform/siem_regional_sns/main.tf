data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
locals {
  region                 = data.aws_region.current.name
  account_id             = data.aws_caller_identity.current.account_id
  partition              = data.aws_partition.current.partition
  sanitized_region       = replace(local.region, "-", "_")
  additional_log_buckets = var.additional_log_buckets
}

data "aws_kms_key" "kms_key" {
  key_id = var.kms_master_key_id
}

data "aws_iam_policy_document" "SnsTopic2" {
  policy_id = "__${local.sanitized_region}_policy_ID"
  statement {
    sid    = "__${local.sanitized_region}_statement_0"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
    actions = [
      "SNS:Publish"
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = local.additional_log_buckets
    }
  }
  statement {
    sid = "__${local.sanitized_region}_statement_allow_account"
    actions = [
      "SNS:Subscribe",
      "SNS:Publish",
      "SNS:GetTopicAttributes"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
    principals {
      type        = "AWS"
      identifiers = ["${local.account_id}"]
    }
  }
  statement {
    sid    = "__${local.sanitized_region}_statement_1"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
    actions = [
      "SNS:Publish"
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "${var.primary_log_bucket.arn}"
      ]
    }
  }
  statement {
    sid = "__${local.sanitized_region}_statement_org2"
    actions = [
      "SNS:Subscribe",
      "SNS:Publish",
      "SNS:GetTopicAttributes"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        var.MASTER_ORG_ID
      ]
    }
  }
  statement {
    sid = "__${local.sanitized_region}_statement_org"
    actions = [
      "SNS:Subscribe",
      "SNS:Publish",
      "SNS:GetTopicAttributes"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        var.MASTER_ORG_ID
      ]
    }
  }
  statement {
    sid = "__${local.sanitized_region}_statement_2"
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:sns:*:*:aes-siem-loader-${local.region}"
    ]
  }
}

resource "aws_sns_topic" "SnsTopic_siemloader" {
  display_name                     = "aes-siem-loader-${local.region}"
  kms_master_key_id                = data.aws_kms_key.kms_key.arn
  name                             = "aes-siem-loader-${local.region}"
  sqs_failure_feedback_role_arn    = var.sqs_failure_feedback_role_arn
  sqs_success_feedback_role_arn    = var.sqs_failure_feedback_role_arn
  sqs_success_feedback_sample_rate = 1
}

resource "aws_sns_topic_policy" "SnsTopic_siemloader" {
  arn    = aws_sns_topic.SnsTopic_siemloader.arn
  policy = data.aws_iam_policy_document.SnsTopic2.json
}

resource "aws_sns_topic_subscription" "sns_sqs_target" {
  topic_arn = aws_sns_topic.SnsTopic_siemloader.arn
  protocol  = "sqs"
  endpoint  = var.aws_sqs_queue.arn
}

