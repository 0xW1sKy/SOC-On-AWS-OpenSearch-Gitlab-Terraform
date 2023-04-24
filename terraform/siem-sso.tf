# resource "aws_opensearch_domain_saml_options" "aesdomain" {
#   domain_name = aws_opensearch_domain.aesdomain.domain_name
#   saml_options {
#     enabled                 = true
#     master_backend_role     = "Admin"
#     roles_key               = "role"
#     session_timeout_minutes = 1440
#     idp {
#       entity_id        = onelogin_saml_apps.app.sso.metadata_url
#       metadata_content = data.http.saml_metadata.response_body
#     }
#     #master_user_name - (Optional) This username from the SAML IdP receives full permissions to the cluster, equivalent to a new master user.
#     #session_timeout_minutes - (Optional) Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440.
#     #subject_key - (Optional) Element of the SAML assertion to use for username. Default is NameID.
#   }
# }

# resource "onelogin_saml_apps" "app" {
#   name                 = "SIEM - Dashboard - ${var.CI_ENVIRONMENT_NAME}"
#   connector_id         = 110016
#   visible              = true
#   allow_assumed_signin = true
#   description          = "AWS OpenSearch Dashbaord - ${var.CI_ENVIRONMENT_NAME}"
#   parameters {
#     param_key_name             = "role"
#     include_in_saml_assertion  = true
#     values                     = ""
#     skip_if_blank              = false
#     attributes_transformations = ""
#     user_attribute_mappings    = "_macro_"
#     label                      = "role"
#     user_attribute_macros      = "Admin"
#     provisioned_entitlements   = false
#     default_values             = ""
#   }
#   parameters {
#     param_key_name             = "saml_username"
#     values                     = null
#     skip_if_blank              = false
#     attributes_transformations = null
#     user_attribute_mappings    = "email"
#     label                      = "NameID value"
#     user_attribute_macros      = ""
#     provisioned_entitlements   = false
#     default_values             = null
#   }
#   configuration = {
#     recipient           = "https://${aws_opensearch_domain.aesdomain.endpoint}/_dashboards/_opendistro/_security/saml/acs/idpinitiated"
#     audience            = "https://${aws_opensearch_domain.aesdomain.endpoint}"
#     signature_algorithm = "SHA-1"
#     validator           = "^https:\\/\\/${aws_opensearch_domain.aesdomain.endpoint}\\/_dashboards\\/_opendistro\\/_security\\/saml\\/acs\\/idpinitiated$"
#     consumer_url        = "https://${aws_opensearch_domain.aesdomain.endpoint}/_dashboards/_opendistro/_security/saml/acs/idpinitiated"
#   }
# }
# data "http" "saml_metadata" {
#   url = onelogin_saml_apps.app.sso.metadata_url

#   # Optional request headers
# }

# resource "onelogin_roles" "admin_role" {
#   name   = "SIEM - ${var.CI_ENVIRONMENT_NAME} - Admin"
#   apps   = ["${onelogin_saml_apps.app.id}"]
#   users  = []
#   admins = []
# }

