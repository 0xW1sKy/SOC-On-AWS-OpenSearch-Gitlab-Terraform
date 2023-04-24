resource "aws_cloudwatch_event_rule" "EventBridgeRuleLambdaMetricsExporterE956E7F2" {
  description         = "EventBridgeRuleLambdaMetricsExporterE956E7F2"
  schedule_expression = "rate(1 hour)"
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "EventBridgeRuleLambdaMetricsExporterE956E7F2" {
  target_id = "Target0"
  rule      = aws_cloudwatch_event_rule.EventBridgeRuleLambdaMetricsExporterE956E7F2.name
  arn       = aws_lambda_function.LambdaMetricsExporter2737F589.arn
}

resource "aws_cloudwatch_event_rule" "EsLoaderStopperRule2C1D9F30" {
  event_pattern = jsonencode({
    detail-type = ["CloudWatch Alarm State Change"]
    resources = [
      "${aws_cloudwatch_metric_alarm.TotalFreeStorageSpaceRemainsLowAlarm3888040E.arn}"
    ]
    source = [
      "aws.cloudwatch"
    ]
  })
  is_enabled = true
}
resource "aws_cloudwatch_event_target" "EsLoaderStopperRule2C1D9F30" {
  target_id = "Target0"
  rule      = aws_cloudwatch_event_rule.EsLoaderStopperRule2C1D9F30.name
  arn       = aws_lambda_function.LambdaEsLoaderStopper35C1D57B.arn
}