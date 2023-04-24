
data "aws_kms_key" "KmsAesSiemLogAliasE0A4C571_by_alias" {
  key_id = aws_kms_alias.KmsAesSiemLogAliasE0A4C571.id
  depends_on = [
    # added to account for a race condition in updating the
    # associated IAM policy on an account where the kms alias
    # has already been deployed and exists within the state file.
    aws_kms_key.kmsAesSiemKey
  ]
}

resource "aws_kms_alias" "KmsAesSiemLogAliasE0A4C571" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_key.kmsAesSiemKey.key_id
  depends_on = [
    # added to account for a race condition in updating the
    # associated IAM policy on an account where the kms alias
    # has already been deployed and exists within the state file.
    aws_kms_key.kmsAesSiemKey
  ]
}


resource "aws_kms_key" "kmsAesSiemKey" {
  description             = "CMK for SIEM solution"
  policy                  = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  multi_region            = true
  is_enabled              = true
  enable_key_rotation     = true
  deletion_window_in_days = 7

}

data "aws_iam_policy_document" "KmsAesSiemLog44B26597" {
  statement {
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:ReplicateKey",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:GenerateDataKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:ReplicateKey",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:GenerateDataKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.CI_SERVICE_ACCOUNT_ARN]
    }
    resources = ["*"]
  }
  statement {
    sid = "Allow GuardDuty to use the key"
    actions = [
      "kms:GenerateDataKey"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    resources = ["*"]
  }
  statement {
    sid = "Allow VPC Flow Logs to use the key"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    sid = "Allow SNS to use the key"
    actions = [

      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:ReplicateKey",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:GenerateDataKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ReEncryptFrom",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    sid = "Allow SQS to use the key"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:ReplicateKey",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:GenerateDataKey",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ReEncryptFrom",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    sid = "Allow principals in the account to decrypt log files"
    actions = [
      "kms:DescribeKey",
      "kms:ReEncryptFrom"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    sid = "Allow Athena to query s3 objects with this key"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values = [
        "athena.amazonaws.com"
      ]
    }
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
    }
  }
  statement {
    sid = "Allow CloudTrail to describe key"
    actions = [
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.AesSiemSnsRole64262F46.arn}"]
    }
  }
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.LambdaEsLoaderServiceRoleFFD43869.arn}"]
    }
  }
  # statement {
  #   actions = [
  #     "kms:Decrypt"
  #   ]
  #   effect    = "Allow"
  #   resources = ["*"]
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["${aws_iam_role.AesSiemEsLoaderEC2RoleFE3F9F00.arn}"]
  #   }
  # }
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = ["${aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.arn}",
      "${aws_iam_role.SNS_SERVICE_ROLE.arn}"]
    }
  }
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
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
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
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
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
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
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}



