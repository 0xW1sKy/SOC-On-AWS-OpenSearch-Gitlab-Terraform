resource "aws_kms_alias" "kms_alias_useast1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_useast1.key_id
  provider      = aws.useast1

}

resource "aws_kms_replica_key" "replica_key_useast1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.useast1
}


resource "aws_kms_alias" "kms_alias_useast2" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_useast2.key_id
  provider      = aws.useast2

}

resource "aws_kms_replica_key" "replica_key_useast2" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.useast2

}




resource "aws_kms_alias" "kms_alias_uswest1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_uswest1.key_id
  provider      = aws.uswest1

}
resource "aws_kms_replica_key" "replica_key_uswest1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.uswest1

}




resource "aws_kms_alias" "kms_alias_eunorth1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_eunorth1.key_id
  provider      = aws.eunorth1

}
resource "aws_kms_replica_key" "replica_key_eunorth1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.eunorth1

}




resource "aws_kms_alias" "kms_alias_apsouth1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apsouth1.key_id
  provider      = aws.apsouth1

}
resource "aws_kms_replica_key" "replica_key_apsouth1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apsouth1

}




resource "aws_kms_alias" "kms_alias_euwest3" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_euwest3.key_id
  provider      = aws.euwest3

}
resource "aws_kms_replica_key" "replica_key_euwest3" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.euwest3

}




resource "aws_kms_alias" "kms_alias_euwest2" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_euwest2.key_id
  provider      = aws.euwest2

}
resource "aws_kms_replica_key" "replica_key_euwest2" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.euwest2

}




resource "aws_kms_alias" "kms_alias_euwest1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_euwest1.key_id
  provider      = aws.euwest1

}
resource "aws_kms_replica_key" "replica_key_euwest1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.euwest1

}




resource "aws_kms_alias" "kms_alias_apnortheast3" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apnortheast3.key_id
  provider      = aws.apnortheast3

}
resource "aws_kms_replica_key" "replica_key_apnortheast3" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apnortheast3

}




resource "aws_kms_alias" "kms_alias_apnortheast2" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apnortheast2.key_id
  provider      = aws.apnortheast2

}
resource "aws_kms_replica_key" "replica_key_apnortheast2" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apnortheast2

}




resource "aws_kms_alias" "kms_alias_apnortheast1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apnortheast1.key_id
  provider      = aws.apnortheast1

}
resource "aws_kms_replica_key" "replica_key_apnortheast1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apnortheast1

}




resource "aws_kms_alias" "kms_alias_saeast1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_saeast1.key_id
  provider      = aws.saeast1

}
resource "aws_kms_replica_key" "replica_key_saeast1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.saeast1

}




resource "aws_kms_alias" "kms_alias_cacentral1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_cacentral1.key_id
  provider      = aws.cacentral1

}
resource "aws_kms_replica_key" "replica_key_cacentral1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.cacentral1

}




resource "aws_kms_alias" "kms_alias_apsoutheast1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apsoutheast1.key_id
  provider      = aws.apsoutheast1

}
resource "aws_kms_replica_key" "replica_key_apsoutheast1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apsoutheast1

}




resource "aws_kms_alias" "kms_alias_apsoutheast2" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_apsoutheast2.key_id
  provider      = aws.apsoutheast2

}
resource "aws_kms_replica_key" "replica_key_apsoutheast2" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.apsoutheast2

}




resource "aws_kms_alias" "kms_alias_eucentral1" {
  name_prefix   = "alias/aes-siem-key/"
  target_key_id = aws_kms_replica_key.replica_key_eucentral1.key_id
  provider      = aws.eucentral1

}
resource "aws_kms_replica_key" "replica_key_eucentral1" {
  policy          = data.aws_iam_policy_document.KmsAesSiemLog44B26597.json
  primary_key_arn = aws_kms_key.kmsAesSiemKey.arn
  provider        = aws.eucentral1

}





