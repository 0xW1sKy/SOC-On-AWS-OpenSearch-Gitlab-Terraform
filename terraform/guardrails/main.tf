

variable "organizational_unit_ids" {}
variable "template_body" {}
variable "name_prefix" {
  type    = string
  default = "terraform-"
}
variable "parameters" {
  type    = map(any)
  default = {}
}
resource "random_id" "resource_id" {
  prefix = var.name_prefix
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    template_body           = sha256(jsonencode(var.template_body))
    organizational_unit_ids = sha256(jsonencode(var.organizational_unit_ids))
    parameters              = sha256(jsonencode(var.parameters))
    name_prefix             = sha256(tostring(var.name_prefix))
  }
  byte_length = 16
}

resource "aws_cloudformation_stack_set_instance" "Stack" {
  deployment_targets {
    organizational_unit_ids = var.organizational_unit_ids
  }
  stack_set_name = aws_cloudformation_stack_set.Stack.name
  call_as        = "DELEGATED_ADMIN"
  region         = "us-east-1"
  operation_preferences {
    failure_tolerance_count = 99
    max_concurrent_count    = 99
    region_concurrency_type = "PARALLEL"
  }
}

resource "aws_cloudformation_stack_set" "Stack" {
  name = random_id.resource_id.hex
  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }
  permission_model = "SERVICE_MANAGED"
  call_as          = "DELEGATED_ADMIN"

  operation_preferences {
    failure_tolerance_count = 99
    max_concurrent_count    = 99
    region_concurrency_type = "PARALLEL"
  }
  capabilities = [
    "CAPABILITY_IAM",
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND"
  ]
  template_body = var.template_body
  parameters    = var.parameters

  depends_on = [
    random_id.resource_id
  ]
}
