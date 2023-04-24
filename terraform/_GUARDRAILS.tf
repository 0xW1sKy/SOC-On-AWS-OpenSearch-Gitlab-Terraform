module "example" {
  source                  = "./guardrails"                                                                                            # always leave this as ./guardrails
  organizational_unit_ids = ["${var.CI_ENVIRONMENT_NAME == var.PRODUCTION_ENVIRONMENT_NAME ? local.guardrail_ou : local.staging_ou}"] # This will auto target the staging OU or global depending on CI Environment
  template_body           = "./stacks/ci-pipeline-test-stack.yaml"                                                                    # path to your stackset that you want deployed to all AWS accounts
  ## Optional Variables
  # name_prefix = my-name-prefix # prefixes the stackset with something of your choice
  # parameters = {} # if your stackset needs parameters you can inject them here.
}
