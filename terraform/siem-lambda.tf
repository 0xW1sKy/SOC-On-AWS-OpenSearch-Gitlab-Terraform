locals {
  folders                 = [for x in fileset("${path.root}/siem-lambda/*", "*.py") : replace(dirname(x), "../", "")]
  regional_wrangler_layer = local.wrangler_layer[local.region]
  regional_architecture   = local.LambdaArchMap[local.region]
}

// Dummy resource to ensure archive is created at apply stage
resource "null_resource" "dummy_trigger" {
  triggers = {
    timestamp = timestamp()
  }
}

# Create zip file for lambda using TF
data "archive_file" "lambda_zips" {
  for_each    = toset(local.folders)
  type        = "zip"
  output_path = "${path.root}/${each.value}.zip"
  source_dir  = "${path.root}/siem-lambda/${each.value}"
  depends_on = [
    // Makes sure archive is created in apply stage
    null_resource.dummy_trigger
  ]
}

resource "aws_lambda_permission" "S3BucketForLogAllowBucketNotificationsToaessiemLambdaEsLoaderEBF3B9FB7766EAA3" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.LambdaEsLoader4B1E2DD9.arn
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.S3BucketForLog20898FE4.arn
  source_account = local.account_id
}

resource "aws_lambda_function" "LambdaEsLoader4B1E2DD9" {
  function_name    = "aes-siem-es-loader"
  handler          = "index.lambda_handler"
  filename         = data.archive_file.lambda_zips["es_loader"].output_path
  source_code_hash = data.archive_file.lambda_zips["es_loader"].output_base64sha256
  role             = aws_iam_role.LambdaEsLoaderServiceRoleFFD43869.arn
  runtime          = "python3.8"
  description      = "SIEM on Amazon OpenSearch Service v2.8.0c / es-loader"
  dead_letter_config {
    target_arn = aws_sqs_queue.AesSiemDlq1CD8439D.arn
  }
  environment {
    variables = {
      ES_ENDPOINT                  = "${aws_opensearch_domain.aesdomain.endpoint}"
      GEOIP_BUCKET                 = aws_s3_bucket.S3BucketForGeoip04B5F171.id
      LOG_LEVEL                    = "info"
      POWERTOOLS_LOGGER_LOG_EVENT  = "false"
      POWERTOOLS_METRICS_NAMESPACE = "SIEM"
      POWERTOOLS_SERVICE_NAME      = "es-loader"
      SQS_SPLITTED_LOGS_URL        = aws_sqs_queue.AesSiemSqsSplitLogs0191F431.id
      external_buckets             = jsonencode(var.additional_log_buckets)
    }
  }
  timeout                        = 600
  memory_size                    = 2048
  reserved_concurrent_executions = var.ReservedConcurrency
  layers = [
    "${local.regional_wrangler_layer}",
    "arn:aws:lambda:${local.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:14", # Amazon owned/operated
    aws_lambda_layer_version.lambda_layer.arn
  ]
  architectures = [
    "${local.regional_architecture}"
  ]
}

resource "aws_lambda_event_source_mapping" "LambdaEsLoaderSqsEventSourceaessiemAesSiemSqsSplitLogs506AFFA6A7D8B2E9" {
  event_source_arn = aws_sqs_queue.AesSiemSqsSplitLogs0191F431.arn
  function_name    = aws_lambda_function.LambdaEsLoader4B1E2DD9.arn
}



resource "aws_lambda_function" "LambdaEsLoaderStopper35C1D57B" {
  filename         = data.archive_file.lambda_zips["es_loader_stopper"].output_path
  source_code_hash = data.archive_file.lambda_zips["es_loader_stopper"].output_base64sha256
  role             = aws_iam_role.LambdaEsLoaderStopperServiceRole83AABC1A.arn
  description      = "SIEM on Amazon OpenSearch Service v2.8.0c / es-loader-stopper"
  environment {
    variables = {
      AES_SIEM_ALERT_TOPIC_ARN       = aws_sns_topic.SnsTopic2C1570A4.id
      ES_LOADER_FUNCTION_ARN         = aws_lambda_function.LambdaEsLoader4B1E2DD9.arn
      ES_LOADER_RESERVED_CONCURRENCY = var.ReservedConcurrency
    }
  }
  function_name = "aes-siem-es-loader-stopper"
  handler       = "index.lambda_handler"
  memory_size   = 128
  runtime       = "python3.8"
  timeout       = 300

}

resource "aws_lambda_permission" "EsLoaderStopperRuleAllowEventRuleaessiemLambdaEsLoaderStopper325F7AA593386C47" {
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.LambdaEsLoaderStopper35C1D57B.arn
  principal      = "events.amazonaws.com"
  source_arn     = aws_cloudwatch_event_rule.EsLoaderStopperRule2C1D9F30.arn
  source_account = local.account_id
}


resource "aws_lambda_function" "LambdaMetricsExporter2737F589" {
  filename         = data.archive_file.lambda_zips["index_metrics_exporter"].output_path
  source_code_hash = data.archive_file.lambda_zips["index_metrics_exporter"].output_base64sha256
  role             = aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.arn
  description      = "SIEM on Amazon OpenSearch Service v2.8.0c / index-metrics-exporter"
  environment {
    variables = {
      ES_ENDPOINT = "${aws_opensearch_domain.aesdomain.endpoint}"
      LOG_BUCKET  = aws_s3_bucket.S3BucketForLog20898FE4.id
      PERIOD_HOUR = 1
    }
  }
  function_name = "aes-siem-index-metrics-exporter"
  handler       = "index.lambda_handler"
  memory_size   = 256
  runtime       = "python3.8"
  timeout       = 300
  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
  ]
}
resource "aws_lambda_layer_version" "lambda_layer" {
  filename         = "${path.root}/lambda_layer.zip"
  layer_name       = "lambda_layer"
  source_code_hash = filebase64sha256("${path.root}/lambda_layer.zip")
}

resource "aws_lambda_permission" "EventBridgeRuleLambdaMetricsExporterAllowEventRuleaessiemLambdaMetricsExporterCD618C3523DA2D6A" {
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.LambdaMetricsExporter2737F589.arn
  principal      = "events.amazonaws.com"
  source_arn     = aws_cloudwatch_event_rule.EventBridgeRuleLambdaMetricsExporterE956E7F2.arn
  source_account = local.account_id
}


resource "aws_lambda_function" "LambdaDeployAES636B5079" {
  filename         = data.archive_file.lambda_zips["deploy_es"].output_path
  source_code_hash = data.archive_file.lambda_zips["deploy_es"].output_base64sha256
  role             = aws_iam_role.AesSiemDeployRoleForLambda654D64F2.arn
  description      = "SIEM on Amazon OpenSearch Service v2.8.0c / opensearch domain deployment"
  environment {
    variables = {
      aes_admin_role = "${aws_iam_role.AesSiemDeployRoleForLambda654D64F2.arn}"
      s3_snapshot    = "${aws_s3_bucket.S3BucketForSnapshot40E67D36.id}"
      es_loader_role        = "${aws_iam_role.LambdaEsLoaderServiceRoleFFD43869.arn}"
      metrics_exporter_role = "${aws_iam_role.LambdaMetricsExporterServiceRoleDDE0BD95.arn}"
      es_endpoint           = "${aws_opensearch_domain.aesdomain.endpoint}"
    }
  }
  function_name = "aes-siem-deploy-aes"
  handler       = "index.lambda_handler"
  memory_size   = 256
  runtime       = "python3.8"
  timeout       = 300
  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
    "${local.regional_wrangler_layer}",
    "arn:aws:lambda:${local.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:14", # Amazon owned/operated
  ]
}

resource "aws_lambda_invocation" "UpdateOpenSearchConfigFromFile" {
  function_name = aws_lambda_function.LambdaDeployAES636B5079.function_name
  triggers = {
    redeployment = sha1(jsonencode([
      aws_lambda_function.LambdaDeployAES636B5079,
      sha1(file("${path.root}/open_search_config.ini"))
    ]))
  }
  input = jsonencode({
    configfile = base64encode(file("${path.root}/open_search_config.ini"))
  })
  depends_on = [
    aws_lambda_layer_version.lambda_layer
  ]
}

resource "aws_lambda_function" "LambdaGeoipDownloaderA5EFF97E" {
  function_name    = "aes-siem-geoip-downloader"
  handler          = "index.lambda_handler"
  filename         = data.archive_file.lambda_zips["geoip_downloader"].output_path
  source_code_hash = data.archive_file.lambda_zips["geoip_downloader"].output_base64sha256
  role             = aws_iam_role.LambdaGeoipDownloaderServiceRoleE37FB908.arn
  runtime          = "python3.8"
  description      = "SIEM on Amazon OpenSearch Service v2.8.0c / es-loader"
  environment {
    variables = {
      license_key   = "${var.MAXMIND_GEOLITE_LICENSE_KEY}"
      s3bucket_name = "${aws_s3_bucket.S3BucketForGeoip04B5F171.id}"
      LOG_LEVEL     = "info"
    }
  }
  timeout     = 300
  memory_size = 320
  layers = [
    "${local.regional_wrangler_layer}",
    "arn:aws:lambda:${local.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:14", # Amazon owned/operated
    aws_lambda_layer_version.lambda_layer.arn
  ]
  architectures = [
    "${local.regional_architecture}"
  ]
}
