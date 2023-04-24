COMPANY_NAME                = "YourCompanyName"
SIEM_ALERT_EMAIL            = "alerts@companyname.invalid"
opensearch_domain_name      = "aesdomain"
staging_ou                  = "ou-XXXX-XXXXXXXX" # This is used for applying ControlTower SecurityControls, etc globally
guardrail_ou                = "ou-XXXX-XXXXXXXX" # This is used for applying ControlTower SecurityControls, etc globally
PRODUCTION_ENVIRONMENT_NAME = "PROD"
STAGING_ENVIRONMENT_NAME    = "STAGE"
SIEM_INSTANCE_TYPE          = "m5.2xlarge.search"
additional_log_buckets = [ # You can tell OpenSearch to grab data from additional buckets if it helps for migration from legacy systems
  {
    bucket_name     = "my-s3-bucket"
    iam_assume_role = "arn:aws:iam::123456789012:role/My-Assumable-Role-To-Access-The-S3-Bucket"
  }
]
MASTER_ORG_ID               = "o-XXXXXXXXXX" # The Organization ID of your AWS Org
SIEM_VOLUME_SIZE            = "3000"
SIEM_VOLUME_TYPE            = "gp3"
otx_api_key                 = "XXXXXXXXXXXXXXXXXXXXXXXXX"
MAXMIND_GEOLITE_LICENSE_KEY = "XXXXXXXXXXXXXXXXXXXXXXXXX"

KIBANA_MASTER_USER_NAME = "kibanaadmin" # Recommend commenting these out, as well as commenting out the master user config in siem-opensearch.tf
KIBANA_MASTER_USER_PASS = "kibanapass"  # Use SSO role assumption instead. If you use onelogin, uncomment sections in providers.tf and siem-sso.tf
