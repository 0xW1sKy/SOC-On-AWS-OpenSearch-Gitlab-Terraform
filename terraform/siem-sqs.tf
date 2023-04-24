resource "aws_sqs_queue" "AesSiemSqsSplitLogs0191F431" {
  kms_data_key_reuse_period_seconds = 86400
  kms_master_key_id                 = aws_kms_alias.KmsAesSiemLogAliasE0A4C571.arn
  message_retention_seconds         = 1209600
  name                              = "aes-siem-sqs-splitted-logs"
  visibility_timeout_seconds        = 600
}

resource "aws_sqs_queue" "AesSiemDlq1CD8439D" {
  kms_data_key_reuse_period_seconds = 86400
  kms_master_key_id                 = aws_kms_alias.KmsAesSiemLogAliasE0A4C571.arn
  message_retention_seconds         = 1209600
  name                              = "aes-siem-dlq"
}



resource "aws_sqs_queue_redrive_policy" "AesSiemSqsSplitLogs0191F431" {
  queue_url = aws_sqs_queue.AesSiemSqsSplitLogs0191F431.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.AesSiemDlq1CD8439D.arn}"
    maxReceiveCount     = 2
  })
}


resource "aws_sqs_queue_redrive_allow_policy" "AesSiemDlq1CD8439D" {
  queue_url = aws_sqs_queue.AesSiemDlq1CD8439D.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.AesSiemSqsSplitLogs0191F431.arn]
  })
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.AesSiemSqsSplitLogs0191F431.id

  policy = <<POLICY
  {
  "Version": "2008-10-17",
  "Id": "MYID",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:*:${local.account_id}:aes-siem-sqs-splitted-logs"
    },
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.AesSiemSqsSplitLogs0191F431.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:*:${local.account_id}:aes-siem-loader-*"
        }
      }
    }
  ]
}

POLICY
}
