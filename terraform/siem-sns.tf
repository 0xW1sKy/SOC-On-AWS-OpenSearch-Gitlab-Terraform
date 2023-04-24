resource "aws_sns_topic" "SnsTopic2C1570A4" {
  display_name                     = "AES SIEM"
  kms_master_key_id                = aws_kms_key.kmsAesSiemKey.key_id
  name                             = "aes-siem-alert"
  sqs_failure_feedback_role_arn    = aws_iam_role.SNS_SERVICE_ROLE.arn
  sqs_success_feedback_role_arn    = aws_iam_role.SNS_SERVICE_ROLE.arn
  sqs_success_feedback_sample_rate = 1
}

resource "aws_sns_topic_subscription" "SnsTopicTokenSubscription1D5A46B4F" {
  topic_arn = aws_sns_topic.SnsTopic2C1570A4.arn
  protocol  = "email"
  endpoint  = var.SIEM_ALERT_EMAIL
  depends_on = [
    aws_sns_topic_policy.SnsTopicPolicy
  ]
}

resource "aws_sns_topic_policy" "SnsTopicPolicy" {
  arn = aws_sns_topic.SnsTopic2C1570A4.arn

  policy = data.aws_iam_policy_document.SnsTopicPolicy.json
}



data "aws_iam_policy_document" "SnsTopicPolicy" {
  policy_id = "__SnsTopic2C1570A4_sns_topic_policy"
  statement {
    sid    = "__SnsTopic2C1570A4_policy_statement_0"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      "arn:aws:sns:*:*:s3-event-notification-topic"
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
    sid    = "__SnsTopic2C1570A4_policy_statement_1"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      "arn:aws:sns:*:*:s3-event-notification-topic"
    ]
    actions = [
      "SNS:Publish"
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "${aws_s3_bucket.S3BucketForLog20898FE4.arn}"
      ]
    }
  }
  statement {
    sid = "__SnsTopic2C1570A4_policy_statement_org"
    actions = [
      "SNS:Subscribe",
      "SNS:Publish",
      "SNS:GetTopicAttributes"
    ]
    effect    = "Allow"
    resources = ["*"]
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
    sid = "__SnsTopic2C1570A4_policy_statement_2"
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
      aws_sns_topic.SnsTopic2C1570A4.arn,
    ]

  }
}


data "aws_iam_policy_document" "SnsTopic_loader" {
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
        "${aws_s3_bucket.S3BucketForLog20898FE4.arn}"
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
}

resource "aws_sns_topic" "SnsTopic_siemloader" {
  display_name                     = "aes-siem-loader-${local.region}"
  kms_master_key_id                = aws_kms_key.kmsAesSiemKey.key_id
  name                             = "aes-siem-loader-${local.region}"
  sqs_failure_feedback_role_arn    = aws_iam_role.SNS_SERVICE_ROLE.arn
  sqs_success_feedback_role_arn    = aws_iam_role.SNS_SERVICE_ROLE.arn
  sqs_success_feedback_sample_rate = 1
}

resource "aws_sns_topic_policy" "SnsTopic_siemloader" {
  arn    = aws_sns_topic.SnsTopic_siemloader.arn
  policy = data.aws_iam_policy_document.SnsTopic_loader.json
}

resource "aws_sns_topic_subscription" "sns_sqs_target" {
  topic_arn = aws_sns_topic.SnsTopic_siemloader.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.AesSiemSqsSplitLogs0191F431.arn
}
