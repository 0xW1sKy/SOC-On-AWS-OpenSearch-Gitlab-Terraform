
locals {
  account_id        = data.aws_caller_identity.current.account_id
  service_listeners = toset([for sl in var.service_listener_config : "${join(",", [sl.service_port, sl.protocol, sl.destination_ip])}"])
}

# TODO: How to define which target ips??

data "aws_vpc" "imported" {
  id = var.aws_vpc_id.id
}

module "listener" {
  for_each = local.service_listeners
  source   = "./service-listener"
  service_listener_config = {
    aws_vpc_id              = data.aws_vpc.imported.id
    network_lb_id           = aws_lb.privatelink.id
    loadbalancer_target_ips = [split(",", each.value)[2]]
    service_port            = split(",", each.value)[0]
    protocol                = split(",", each.value)[1]
    target_type             = "ip"
  }
}
locals {
  imported_subnets = toset([for s in var.aws_subnet_ids : s.id])
}
data "aws_subnet" "imported" {
  for_each = local.imported_subnets
  id       = each.value
}

resource "aws_lb" "privatelink" {
  internal           = true
  load_balancer_type = "network"
  ip_address_type    = "ipv4"
  subnets            = [for s in data.aws_subnet.imported : s.id]
}

resource "aws_vpc_endpoint_service" "VPCEndpointService" {
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.privatelink.arn]
}

resource "aws_vpc_endpoint_service_allowed_principal" "allow" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.VPCEndpointService.id
  principal_arn           = "*"
}

resource "aws_sns_topic" "VPCEndpointSNSTopic" {
}

resource "aws_sns_topic_policy" "VPCEndpointSNSTopic" {
  arn = aws_sns_topic.VPCEndpointSNSTopic.arn

  policy = data.aws_iam_policy_document.VPCEndpointSNSTopic.json
}



data "aws_iam_policy_document" "VPCEndpointSNSTopic" {
  policy_id = "__default_policy_ID"
  statement {
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
      aws_sns_topic.VPCEndpointSNSTopic.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_vpc_endpoint_connection_notification" "foo" {
  vpc_endpoint_service_id     = aws_vpc_endpoint_service.VPCEndpointService.id
  connection_notification_arn = aws_sns_topic.VPCEndpointSNSTopic.arn
  connection_events           = ["Connect"]
}


data "aws_caller_identity" "current" {}


resource "aws_sns_topic_subscription" "VPCEndpointConnectionSubscription" {
  topic_arn = aws_sns_topic.VPCEndpointSNSTopic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.VPCEndpointAcceptanceLambda.arn
}


resource "aws_iam_role" "LambdaExecutionRole" {
  path                = "/privatelink/service/lambda/vpcendpointaccepter/"
  name_prefix         = "privatelink-"
  assume_role_policy  = data.aws_iam_policy_document.PrivateLinkLambdaAssumeRolePolicy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  inline_policy {
    policy = data.aws_iam_policy_document.PrivateLinkLambda.json
  }
}

data "aws_iam_policy_document" "PrivateLinkLambda" {
  statement {
    effect    = "Allow"
    actions   = ["organizations:ListAccounts", "ec2:DescribeVpcEndpointConnections", "ec2:AcceptVpcEndpointConnections"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "PrivateLinkLambdaAssumeRolePolicy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// Dummy resource to ensure archive is created at apply stage
resource "null_resource" "dummy_trigger" {
  triggers = {
    timestamp = timestamp()
  }
}

# Create zip file for lambda using TF
data "archive_file" "VPCEndpointAcceptanceLambda" {
  type        = "zip"
  output_path = "${path.module}/lambda_zip_file_VPCEndpointAcceptanceLambda.zip"
  source_dir  = "${path.module}/lambda/"
  depends_on = [
    // Makes sure archive is created in apply stage
    null_resource.dummy_trigger
  ]
}

# Actual Lambda Function
resource "aws_lambda_function" "VPCEndpointAcceptanceLambda" {
  filename         = data.archive_file.VPCEndpointAcceptanceLambda.output_path
  source_code_hash = data.archive_file.VPCEndpointAcceptanceLambda.output_base64sha256
  handler          = "index.lambda_handler"
  function_name    = "VPCEndpointAcceptanceLambda"
  runtime          = "python3.8"
  role             = aws_iam_role.LambdaExecutionRole.arn
  timeout          = 25
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.VPCEndpointAcceptanceLambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.VPCEndpointSNSTopic.arn
}
