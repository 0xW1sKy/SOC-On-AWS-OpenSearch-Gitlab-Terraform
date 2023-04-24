<!-- markdownlint-disable-file MD026 MD033 MD007 MD004 -->
[Original Inspiration](https://github.com/aws-samples/siem-on-amazon-opensearch-service)

## Design Considerations

This projects is being designed such that it could by copy-pasted to a new environment and everything should 'just work' only changes would be to update environment variables to point at a different Production and Staging account in AWS.

## Required CI Variables (gitlab)

- AWS_ACCESS_KEY_ID
- - scope Production
- AWS_ACCESS_KEY_ID
- - scope Staging
- AWS_SECRET_ACCESS_KEY_ID
- - scope Production
- AWS_SECRET_ACCESS_KEY_ID
- - scope Staging

## Naming Conventions for Logs

**Note `S3_Key` needs to match `s3_key` in the user.ini file**

### S3 Log Bucket Folder Format

`/AWSLogs/${OrgID}/${AccountID}/${S3_Key}/${AWS_REGION}/${YEAR}/${MONTH}/${DAY}/${AccountID}_${S3_Key}_${AWS_REGION}_${TIMESTAMP}_${HASH}.json.gz`

### CloudWatch Log Group Naming Convention

#### Aws Auto-Generated Format

`${S3_Key}/${AWS_REGION}/${AccountID}/${Resource_Name}[/${Log_Type}]?`
> Note that Log_Type is optional

Examples:
`sns/us-east-1/${AccountID}/aes-siem-loader-us-east-1`
`sns/us-east-1/${AccountID}/aes-siem-loader-us-east-1/Failure`

#### Log Groups Created By Us

##### AWS Resources

`/AWSLogs/${OrgID}/${AccountID}/${S3_Key}/${AWS_REGION}/${Resource_Name}[/${Log_Type}]?`
> Note that Log_Type is optional

Examples:
`/AWSLogs/${OrgID}/${AccountID}/vpc-flow-logs/us-east-1/vpc-XXXXXXXXXXXXXX`

##### Third Party

`/ThirdParty/${OrgID}/${AccountID OR Global}/${Vendor}/${S3_Key}/${AWS_Region or Global}/${Resource_Name/ID}/log_file.extension`

## SIEM on Amazon OpenSearch Service
<!-- markdownlint-disable-file MD026 MD033 -->

SIEM on Amazon OpenSearch Service is a solution for collecting multiple types of logs from multiple AWS accounts, correlating and visualizing the logs to help investigate security incidents. Deployment is easily done with the help of AWS CloudFormation or AWS Cloud Development Kit (AWS CDK), taking only about 30 minutes to complete. As soon as AWS services logs are put into a specified Amazon Simple Storage Service (Amazon S3) bucket, a purpose-built AWS Lambda function automatically loads those logs into SIEM on OpenSearch Service, enabling you to view visualized logs in the dashboard and correlate multiple logs to investigate security incidents.

## Supported Log Types

SIEM on OpenSearch Service can load and correlate the following log types.

|       |AWS Service|Log|
|-------|-----------|---|
|Security, Identity, & Compliance|AWS CloudHSM|HSM audit logs|
|Security, Identity, & Compliance|Amazon GuardDuty|GuardDuty findings|
|Security, Identity, & Compliance|Amazon Inspector|Inspector findings|
|Security, Identity, & Compliance|AWS Directory Service|Microsoft AD|
|Security, Identity, & Compliance|AWS WAF|AWS WAF Web ACL traffic information<br>AWS WAF Classic Web ACL traffic information|
|Security, Identity, & Compliance|AWS Security Hub|Security Hub findings<br>GuardDuty findings<br>Amazon Macie findings<br>Amazon Inspector findings<br>AWS IAM Access Analyzer findings|
|Security, Identity, & Compliance|AWS Network Firewall|Flow logs<br>Alert logs|
|Management & Governance|AWS CloudTrail|CloudTrail Log Event<br>CloudTrail Insight Event|
|Management & Governance|AWS Config|Configuration History<br>Configuration Snapshot<br>Config Rules|
|Management & Governance|AWS Trusted Advisor|Trusted Advisor Check Result|
|Networking & Content Delivery|Amazon CloudFront|Standard access log<br>Real-time log|
|Networking & Content Delivery|Amazon Route 53 Resolver|VPC DNS query log|
|Networking & Content Delivery|Amazon Virtual Private Cloud (Amazon VPC)|VPC Flow Logs (Version5)|
|Networking & Content Delivery|Elastic Load Balancing|Application Load Balancer access logs<br>Network Load Balancer access logs<br>Classic Load Balancer access logs|
|Networking & Content Delivery|AWS Client VPN|connection log|
|Storage|Amazon FSx for Windows File Server|audit log|
|Storage|Amazon Simple Storage Service (Amazon S3)|access log|
|Database|Amazon Relational Database Service (Amazon RDS)<br>(**Experimental Support**)|Amazon Aurora(MySQL)<br>Amazon Aurora(PostgreSQL)<br>Amazon RDS for MariaDB<br>Amazon RDS for MySQL<br>Amazon RDS for PostgreSQL|
|Database|Amazon ElastiCache|ElastiCache for Redis SLOWLOG|
|Analytics|Amazon OpenSearch Service|Audit logs|
|Analytics|Amazon Managed Streaming for Apache Kafka (Amazon MSK)|Broker log|
|Compute|Linux OS<br>via CloudWatch Logs|/var/log/messages<br>/var/log/secure|
|Compute|Windows Server 2012/2016/2019<br>via CloudWatch Logs|System event log<br>Security event log|
|Containers|Amazon Elastic Container Service (Amazon ECS)<br>via FireLens|Framework only|
|End User Computing|Amazon WorkSpaces|Event log<br>Inventory|

Experimental Support: We may change field type, normalization and something in the future.

Supported logs are normalized in accordance with the [Elastic Common Schema](https://www.elastic.co/guide/en/ecs/current/index.html). Click [here](docs/supported_log_type.md) to see the correspondence table of the original and normalized field names for the logs.


## Getting Started

You can add country information as well as latitude/longitude location information to each IP address. To get location information, SIEM on OpenSearch Service downloads and uses GeoLite2 Free by [MaxMind](https://www.maxmind.com). If you want to add location information, get your free license from MaxMind.

Threat information can be enriched based on IP addresses and domain names (EXPERIMANTAL). Threat information sources include your own IoCs (Indicators of compromise) in TXT and STIX 2.x formats, [Tor Project](https://www.torproject.org), [Abuse.ch Feodo Tracker]( https://feodotracker.abuse.ch), [AlienVault OTX](https://otx.alienvault.com/). If there are many IoCs, the processing time of Lambda will increase, so please select IoCs carefully. If you want to use the IoC on AlienVault OTX, please get your API key at [AlienVault OTX](https://otx.alienvault.com/#signup). See [Threat Information Enrichment by IoC](docs/configure_siem.md#threat-information-enrichment-by-ioc) for more details.

> **_Note:_** The CloudFormation template will deploy OpenSearch Service with **a t3.medium.search instance. It's not the AWS Free Tier. Change it to an instance type that can deliver higher performance than t3 when using SIEM in the production environment as it requires higher processing power when aggregating many logs.** Use the AWS Management Console to change the instance type, extend the volume, or use UltraWarm. This is because the CloudFormation template for SIEM on OpenSearch Service is designed for the initial deployment purpose only, and cannot be used for management purposes like changing/deleting nodes.

### 1. Quick Start

TODO: Update this later.

### 2. Configuring OpenSearch Dashboards

It will take about 30 mins for the deployment of SIEM on OpenSearch Service to complete. You can then continue to configure OpenSearch Dashboards.

1. Navigate to the AWS CloudFormation console, choose the stack that you've just created, and then choose "Outputs" from the tab menu at the top right. You can find your username, password, and URL for OpenSearch Dashboards. Log into OpenSearch Dashboards using the credentials.
1. When you login for the first time, [Select your tenant] is displayed. Select [**Global**]. You can use the prepared dashboard etc.
1. You can also select [**Private**] instead of [Global] in [Select your tenant] and customize configuration and dashboard etc. for each user. The following is the procedure for each user. If you select Global, you do not need to set it.
    1. To import OpenSearch Dashboards' configuration files such as dashboard, download [saved_objects.zip](https://aes-siem.s3.amazonaws.com/assets/saved_objects.zip). Then unzip the file.
    1. Navigate to the OpenSearch Dashboards console. Click on "Stack Management" in the left pane, then choose "Saved Objects" --> "Import" --> "Import". Choose dashboard.ndjson which is contained in the unzipped folder. Then log out and log in again so that the imported configurations take effect.

### 3. Loading logs into OpenSearch Service

All you need to do to load logs into SIEM on OpenSearch Service is PUT logs to the S3 Bucket named **aes-siem-<YOUR_AWS_ACCOUNT>-log**. Then the logs will be automatically loaded into SIEM on OpenSearch Service. See [this](docs/configure_aws_service.md) for detailed instructions on how to output AWS services logs to the S3 bucket.

## Workshop

We have published the workshop, [SIEM on Amazon OpenSearch Service Workshop](https://security-log-analysis-platform.workshop.aws/en/). In this workshop, we will build the SIEM, ingest AWS resource logs, learn OpenSearch Dashboards, investigate security incident, create dashboard, configure alerts and ingest logs of Apache HTTPD server.

## Updating SIEM

If you want to update "SIEM on OpenSearch Service/SIEM on Amazon ES" to the latest version, upgrade the OpenSearch / Elasticsearch domain and then update it in the same way as you did for the initial setup (using CloudFormation or AWS CDK.) You can view the changelog of SIEM [here.](CHANGELOG.md)

> **_Note_: When you update SIEM, Global tenant settings, dashboards, etc. will be overwritten automatically. The configuration files and dashboards used before the update will be backed up to aes-siem-[AWS_Account]-snapshot/saved_objects/ in the S3 bucket, so restore them manually if you want to restore the original settings.**

## Changing Configurations

### Changing the OpenSearch Service domain resources after deployment

If you want to make changes to the OpenSearch Service domain itself such as changing the access policy of OpenSearch Service, changing the instance type, changing the Availability Zone or adding a new one, or changing to UltraWarm, perform the change from the [OpenSearch Service console](https://console.aws.amazon.com/es/home?) of AWS Management Console.

### Managing the index and customizing SIEM

SIEM on OpenSearch Service saves logs in the index and rotates it once a month. If you want to change this interval or load logs from non-AWS services, see [this.](docs/configure_siem.md)

## Near-real-time logs loading from non-SIEM-managed S3 buckets

If you have an S3 bucket in the same account and region as the SIEM, you can load logs into OpenSearch Service. Please refer [Near-real-time loading from other S3 buckets](docs/configure_siem.md#near-real-time-loading-from-other-s3-buckets) for the setting method.

## Loading stored logs through batch processing

You can execute es-loader, which is a python script, in the local environment to load past logs stored in the S3 bucket into SIEM on OpenSearch Service. See [Loading past data stored in the S3 bucket](docs/configure_siem.md#loading-past-data-stored-in-the-s3-bucket) for details.

## Throttling of es-loader in an emergency

To avoid unnecessary invocation of es-loader, throttle es-loader under the following conditions

* If total free space for the OpenSearch Service cluster remains less than 200MB for 30 minutes and `aes-siem-TotalFreeStorageSpaceRemainsLowAlarm` is triggered.
  * The OpenSearch cluster is running out of storage space. More free space is needed for recovery. To learn more, see [Lack of available storage space](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/handling-errors.html#handling-errors-watermark).

If you want to resume loading logs, set the reserved concurrency of the Lambda function `aes-siem-es-loader` back to 10 from the AWS Management Console or AWS CLI.
You can also load messages from the dead-letter queue (aes-siem-dlq) by referring to [Loading data from SQS Dead Letter Queue](docs/configure_siem.md#loading-data-from-sqs-dead-letter-queue).

## Cleanup

`terraform destroy`

## License

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.

This product includes GeoLite2 data created by MaxMind, and licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/), available from [https://www.maxmind.com](https://www.maxmind.com).

This product uses Tor exit list created by The Tor Project, Inc and licensed under [CC BY 3.0 US](https://creativecommons.org/licenses/by/3.0/us/), available from [https://www.torproject.org](https://www.torproject.org)
