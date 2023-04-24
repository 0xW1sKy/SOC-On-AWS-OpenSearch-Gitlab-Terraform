resource "aws_opensearch_domain_policy" "main" {
  domain_name = aws_opensearch_domain.aesdomain.domain_name

  access_policies = data.aws_iam_policy_document.opensearch_access_policy.json
}


data "aws_iam_policy_document" "opensearch_access_policy" {
  statement {
    sid    = "AllowAccessFromInternet"
    effect = "Allow"
    actions = [
      "es:ESHttp*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["arn:${local.partition}:es:${data.aws_region.current.name}:${local.account_id}:domain/${aws_opensearch_domain.aesdomain.domain_name}/*"]
  }
  statement {
    sid    = "AllowAccessFromAccount"
    effect = "Allow"
    actions = [
      "es:ESHttp*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
    }
    resources = ["arn:${local.partition}:es:${data.aws_region.current.name}:${local.account_id}:domain/${aws_opensearch_domain.aesdomain.domain_name}/*"]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      "/aws/OpenSearchService/domains/${var.opensearch_domain_name}:*",
      "/aws/OpenSearchService/domains/${var.opensearch_domain_name}/*"
    ]
  }

}

resource "aws_opensearch_domain" "aesdomain" {
  domain_name    = var.opensearch_domain_name
  engine_version = "OpenSearch_2.3"
  cluster_config {
    instance_type            = var.SIEM_INSTANCE_TYPE
    instance_count           = var.SIEM_INSTANCE_COUNT
    dedicated_master_enabled = true
    dedicated_master_count   = 3
    dedicated_master_type    = "r5.large.search"
    zone_awareness_enabled   = false
    warm_enabled             = true
    warm_count               = 2
    warm_type                = "ultrawarm1.medium.search"

  }
  ebs_options {
    ebs_enabled = true
    volume_type = "gp3"
    throughput  = 250
    volume_size = var.SIEM_VOLUME_SIZE
    iops        = var.SIEM_VOLUME_SIZE * 3

  }
  encrypt_at_rest {
    enabled = true

  }
  node_to_node_encryption {
    enabled = true
  }


  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.application-logs.arn
    enabled                  = true
    log_type                 = "ES_APPLICATION_LOGS"
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = false
    master_user_options {
      master_user_arn = aws_iam_role.AesSiemDeployRoleForLambda654D64F2.arn
      ##########
      master_user_name = var.KIBANA_MASTER_USER_NAME
      #comment master_user_name out if you're using SSO
      master_user_password = var.KIBANA_MASTER_USER_PASS
      #comment master_user_pass out if you're using SSO
    }
  }


}

