variable "CI_ENVIRONMENT_NAME" {
  type = string
}
variable "CI_COMMIT_SHORT_SHA" {
  type = string
}
variable "SIEM_ALERT_EMAIL" {
  type = string
}

# variable "ONELOGIN_CLIENT_ID" {
#   type = string
# }

# variable "ONELOGIN_CLIENT_SECRET" {
#   type = string
# }

# TODO: build the DSM server as part of this pipeline
variable "dsm_server_ip" { #Can reuse this variable + main.tf for any other service you want to be available globally over privatelink
  type        = string
  default     = "10.0.0.10"
  description = "DeepSecurityManager IP"
}

variable "ReservedConcurrency" {
  description = "Reserved Concurrency for SIEM data load lambda"
  type        = number
  default     = 0
}

variable "opensearch_domain_name" {
  type    = string
  default = "aesdomain"
}

variable "staging_ou" {
  type        = string
  description = "OU used for testing of delegated security controls form this pipeline"
}

variable "guardrail_ou" {
  type        = string
  description = "OU to deploy delegated security controls to after succesful testing"
}

variable "PRODUCTION_ENVIRONMENT_NAME" {
  type    = string
  default = "production"
}

variable "STAGING_ENVIRONMENT_NAME" { # Not used yet, but reserving just in case.
  type    = string
  default = "staging"
}

variable "SIEM_INSTANCE_TYPE" {
  type    = string
  default = "m5.4xlarge.search"
}

variable "SIEM_INSTANCE_COUNT" {
  type    = string
  default = 3
}

variable "MASTER_ORG_ID" {
  type = string
}

variable "additional_log_buckets" {
  type = list(object({
    bucket_name     = string
    iam_assume_role = string
  }))
}

variable "SIEM_VOLUME_SIZE" {}

variable "SIEM_VOLUME_TYPE" {}

variable "COMPANY_NAME" {}

variable "otx_api_key" {
  default = null
  type    = string
}

variable "MAXMIND_GEOLITE_LICENSE_KEY" {}

variable "KIBANA_MASTER_USER_NAME" {}

variable "KIBANA_MASTER_USER_PASS" {}


#TODO: Add DNS config for privatelink

# variable "PrivateLinkHostname" {
#   Type    = string
#   Default = "secops"
# }

# variable "Route53PublicZone" {
#   type    = string
#   Default = ""
# }

# Trigger Deploy = Yes
