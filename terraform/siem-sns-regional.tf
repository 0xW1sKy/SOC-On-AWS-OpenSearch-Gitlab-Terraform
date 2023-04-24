# This creates global SNS endpoints to allow for full cross-region coverage.

# This section commented out as US-West-2 is the primary region.
# module "Regional_SNS_Lambda_uswest2" {
#   sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
#   source = "./siem_regional_sns"
#   kms_master_key_id      =   aws_kms_key.KmsAesSiemKey
#   additional_log_buckets = local.additional_log_buckets
#   primary_log_bucket     = aws_s3_bucket.S3BucketForLog20898FE4
#   aws_sqs_queue          = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
#   MASTER_ORG_ID = var.MASTER_ORG_ID
#   providers = {
#     aws = aws.uswest2
#   }
# }



module "Regional_SNS_Lambda_useast1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_useast1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.useast1
  }
}




module "Regional_SNS_Lambda_useast2" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_useast2.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.useast2
  }

}




module "Regional_SNS_Lambda_uswest1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_uswest1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.uswest1
  }

}




module "Regional_SNS_Lambda_eunorth1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_eunorth1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.eunorth1
  }

}




module "Regional_SNS_Lambda_apsouth1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apsouth1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apsouth1
  }

}




module "Regional_SNS_Lambda_euwest3" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_euwest3.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.euwest3
  }

}




module "Regional_SNS_Lambda_euwest2" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_euwest2.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.euwest2
  }

}




module "Regional_SNS_Lambda_euwest1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_euwest1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.euwest1
  }

}




module "Regional_SNS_Lambda_apnortheast3" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apnortheast3.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apnortheast3
  }

}




module "Regional_SNS_Lambda_apnortheast2" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apnortheast2.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apnortheast2
  }

}




module "Regional_SNS_Lambda_apnortheast1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apnortheast1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apnortheast1
  }

}




module "Regional_SNS_Lambda_saeast1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_saeast1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.saeast1
  }

}




module "Regional_SNS_Lambda_cacentral1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_cacentral1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.cacentral1
  }

}




module "Regional_SNS_Lambda_apsoutheast1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apsoutheast1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apsoutheast1
  }

}




module "Regional_SNS_Lambda_apsoutheast2" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_apsoutheast2.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.apsoutheast2
  }

}




module "Regional_SNS_Lambda_eucentral1" {
  sqs_failure_feedback_role_arn = aws_iam_role.SNS_SERVICE_ROLE.arn
  source                        = "./siem_regional_sns"
  kms_master_key_id             = aws_kms_replica_key.replica_key_eucentral1.arn
  additional_log_buckets        = local.additional_log_buckets
  primary_log_bucket            = aws_s3_bucket.S3BucketForLog20898FE4
  aws_sqs_queue                 = aws_sqs_queue.AesSiemSqsSplitLogs0191F431
  MASTER_ORG_ID                 = var.MASTER_ORG_ID
  providers = {
    aws = aws.eucentral1
  }

}





