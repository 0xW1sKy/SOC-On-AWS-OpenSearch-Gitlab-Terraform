resource "aws_cloudwatch_log_group" "application-logs" {
  name              = "/aws/OpenSearchService/domains/${var.opensearch_domain_name}/application-logs"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_group" "aes-siem-configure-aes" {
  name              = "/aws/lambda/aes-siem-configure-aes"
  retention_in_days = 90
}
resource "aws_cloudwatch_log_group" "aes-siem-deploy-aes" {
  name              = "/aws/lambda/aes-siem-deploy-aes"
  retention_in_days = 90
}
resource "aws_cloudwatch_log_group" "aes-siem-es-loader" {
  name              = "/aws/lambda/aes-siem-es-loader"
  retention_in_days = 90
}
resource "aws_cloudwatch_log_group" "aes-siem-geoip-downloader" {
  name              = "/aws/lambda/aes-siem-geoip-downloader"
  retention_in_days = 90
}

data "aws_iam_policy_document" "opensearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:${local.partition}:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "openearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.opensearch-log-publishing-policy.json
  policy_name     = "opensearch-log-publishing-policy"
}

data "aws_iam_policy_document" "route53-query-logging-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${local.partition}:logs:*:*:log-group:/aws/route53/*"]

    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53-query-logging-policy" {
  policy_document = data.aws_iam_policy_document.route53-query-logging-policy.json
  policy_name     = "route53-query-logging-policy"
}

resource "aws_cloudwatch_metric_alarm" "TotalFreeStorageSpaceRemainsLowAlarm3888040E" {
  alarm_name          = "TotalFreeStorageSpaceRemainsLowAlarm3888040E"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 30
  period              = 60
  alarm_description   = "Triggered when total free space for the cluster remains less 200MB for 30 minutes."
  dimensions = {
    ClientId   = "${local.account_id}"
    DomainName = "${var.opensearch_domain_name}"
  }
  metric_name = "FreeStorageSpace"
  namespace   = "AWS/ES"
  statistic   = "Sum"
  threshold   = 200
}

resource "aws_cloudwatch_dashboard" "SIEMDashboard35199390" {
  dashboard_name = "SIEM"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "text",
            "width": 24,
            "height": 1,
            "x": 0,
            "y": 0,
            "properties": {
                "markdown": "# CloudWatch Alarm"
            }
        },
        {
            "type": "metric",
            "width": 6,
            "height": 6,
            "x": 0,
            "y": 1,
            "properties": {
                "view": "timeSeries",
                "title": "${aws_cloudwatch_metric_alarm.TotalFreeStorageSpaceRemainsLowAlarm3888040E.id}",
                "region": "${local.region}",
                "annotations": {
                    "alarms": [
                        "${aws_cloudwatch_metric_alarm.TotalFreeStorageSpaceRemainsLowAlarm3888040E.arn}"
                    ]
                },
                "yAxis": {}
            }
        },
        {
            "type": "text",
            "width": 24,
            "height": 1,
            "x": 0,
            "y": 7,
            "properties": {
                "markdown": "# Lambda Function: ${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}"
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 8,
            "properties": {
                "view": "timeSeries",
                "title": "Error count and success rate (%)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/Lambda",
                        "Errors",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "color": "#d13212",
                            "label": "Errors (Count)",
                            "stat": "Sum",
                            "id": "errors"
                        }
                    ],
                    [
                        {
                            "label": "Success rate (%)",
                            "color": "#2ca02c",
                            "expression": "100 - 100 * errors / MAX([errors, invocations])",
                            "yAxis": "right"
                        }
                    ],
                    [
                        "AWS/Lambda",
                        "Invocations",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Sum",
                            "visible": false,
                            "id": "invocations"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "max": 100,
                        "showUnits": false
                    }
                },
                "period": 60
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 8,
            "properties": {
                "view": "timeSeries",
                "title": "Invocations (Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/Lambda",
                        "Invocations",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Sum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                },
                "period": 60
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 12,
            "properties": {
                "view": "timeSeries",
                "title": "Duration (Milliseconds)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/Lambda",
                        "Duration",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Minimum"
                        }
                    ],
                    [
                        "AWS/Lambda",
                        "Duration",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}"
                    ],
                    [
                        "AWS/Lambda",
                        "Duration",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Maximum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "period": 60
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 12,
            "properties": {
                "view": "timeSeries",
                "title": "Throttles (Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/Lambda",
                        "Throttles",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Sum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                },
                "period": 60
            }
        },
        {
            "type": "log",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 16,
            "properties": {
                "view": "table",
                "title": "Longest 5 invocations",
                "region": "${local.region}",
                "query": "SOURCE '/aws/lambda/${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}' | fields @timestamp, @duration, @requestId\n                | sort @duration desc\n                | head 5"
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 16,
            "properties": {
                "view": "timeSeries",
                "title": "ConcurrentExecutions (Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/Lambda",
                        "ConcurrentExecutions",
                        "FunctionName",
                        "${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}",
                        {
                            "stat": "Maximum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                },
                "period": 60
            }
        },
        {
            "type": "text",
            "width": 24,
            "height": 1,
            "x": 0,
            "y": 20,
            "properties": {
                "markdown": "# OpenSearch Service: ${var.opensearch_domain_name} domain"
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 21,
            "properties": {
                "view": "timeSeries",
                "title": "Data Node CPUUtilization (Cluster Max Percentage)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "CPUUtilization",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Maximum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "max": 100,
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 21,
            "properties": {
                "view": "timeSeries",
                "title": "Data Node JVMMemoryPressure (Cluster Max Percentage)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "JVMMemoryPressure",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "yAxis": {
                    "left": {
                        "max": 100,
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 25,
            "properties": {
                "view": "timeSeries",
                "title": "HTTP requests by error response code (Cluster Total Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "4xx",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ],
                    [
                        "AWS/ES",
                        "5xx",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 25,
            "properties": {
                "view": "timeSeries",
                "title": "Active Shards Count",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "Shards.active",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ],
                    [
                        "AWS/ES",
                        "Shards.activePrimary",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 29,
            "properties": {
                "view": "timeSeries",
                "title": "Cluster DiskThroughputThrottle",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ThroughputThrottle",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "Cluster Disk ThroughputThrottle",
                            "stat": "Maximum"
                        }
                    ]
                ],
                "annotations": {
                    "horizontal": [
                        {
                            "value": 1,
                            "yAxis": "left"
                        }
                    ]
                },
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 29,
            "properties": {
                "view": "timeSeries",
                "title": "ClusterIndexWritesBlocked (Cluster Max Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ClusterIndexWritesBlocked",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "text",
            "width": 12,
            "height": 1,
            "x": 0,
            "y": 33,
            "properties": {
                "markdown": "# Read / Search"
            }
        },
        {
            "type": "text",
            "width": 12,
            "height": 1,
            "x": 12,
            "y": 33,
            "properties": {
                "markdown": "# Write / Indexing"
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 34,
            "properties": {
                "view": "timeSeries",
                "title": "EBS Read Throughput / IOPS",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ReadThroughput",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "ReadThroughput (Bytes/Second)",
                            "stat": "Maximum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "ReadIOPS",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "ReadIOPS (Count/Second)",
                            "stat": "Maximum",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 34,
            "properties": {
                "view": "timeSeries",
                "title": "EBS Write Throughput / IOPS",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "WriteThroughput",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "WriteThroughput (Bytes/Second)",
                            "stat": "Maximum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "WriteIOPS",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "WriteIOPS (Count/Second)",
                            "stat": "Maximum",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 38,
            "properties": {
                "view": "timeSeries",
                "title": "EBS Read Latency / Disk Queue",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ReadLatency",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "ReadLatency (Seconds)",
                            "stat": "Maximum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "DiskQueueDepth",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "DiskQueueDepth (Count)",
                            "stat": "Maximum",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 38,
            "properties": {
                "view": "timeSeries",
                "title": "EBS Write Latency / Disk Queue",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "WriteLatency",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "WriteLatency (Seconds)",
                            "stat": "Maximum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "DiskQueueDepth",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "DiskQueueDepth (Count)",
                            "stat": "Maximum",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 42,
            "properties": {
                "view": "timeSeries",
                "title": "Search Rate / Latency (Node Average)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "SearchRate",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "SearchRate (Count)"
                        }
                    ],
                    [
                        "AWS/ES",
                        "SearchLatency",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "SearchLatency (Milliseconds)",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 42,
            "properties": {
                "view": "timeSeries",
                "title": "Indexing Rate / Latency (Node Average)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "IndexingRate",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "IndexingRate (Count)"
                        }
                    ],
                    [
                        "AWS/ES",
                        "IndexingLatency",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "label": "IndexingLatency (Milliseconds)",
                            "yAxis": "right"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 46,
            "properties": {
                "view": "timeSeries",
                "title": "ThreadpoolReadQueue (Node Average Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ThreadpoolSearchQueue",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "annotations": {
                    "horizontal": [
                        {
                            "value": 1000,
                            "yAxis": "left"
                        }
                    ]
                },
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 46,
            "properties": {
                "view": "timeSeries",
                "title": "ThreadpoolWriteQueue (Node Average Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ThreadpoolWriteQueue",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}"
                    ]
                ],
                "annotations": {
                    "horizontal": [
                        {
                            "value": 10000,
                            "yAxis": "left"
                        }
                    ]
                },
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 50,
            "properties": {
                "view": "timeSeries",
                "title": "Threadpool Search Rejected Count (Node Total Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ThreadpoolSearchRejected",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Sum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 50,
            "properties": {
                "view": "timeSeries",
                "title": "Threadpool Indexing Rejected Count (Node Total Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/ES",
                        "ThreadpoolWriteRejected",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Sum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "CoordinatingWriteRejected",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Sum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "PrimaryWriteRejected",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Sum"
                        }
                    ],
                    [
                        "AWS/ES",
                        "ReplicaWriteRejected",
                        "ClientId",
                        "${local.account_id}",
                        "DomainName",
                        "${var.opensearch_domain_name}",
                        {
                            "stat": "Sum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "text",
            "width": 24,
            "height": 1,
            "x": 0,
            "y": 54,
            "properties": {
                "markdown": "# SQS"
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 0,
            "y": 55,
            "properties": {
                "view": "timeSeries",
                "title": "${aws_sqs_queue.AesSiemSqsSplitLogs0191F431.name}: NumberOfMessagesReceived (Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/SQS",
                        "NumberOfMessagesReceived",
                        "QueueName",
                        "${aws_sqs_queue.AesSiemSqsSplitLogs0191F431.name}",
                        {
                            "stat": "Sum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "width": 12,
            "height": 4,
            "x": 12,
            "y": 55,
            "properties": {
                "view": "timeSeries",
                "title": "${aws_sqs_queue.AesSiemDlq1CD8439D.name}: ApproximateNumberOfMessagesVisible (Count)",
                "region": "${local.region}",
                "metrics": [
                    [
                        "AWS/SQS",
                        "ApproximateNumberOfMessagesVisible",
                        "QueueName",
                        "${aws_sqs_queue.AesSiemDlq1CD8439D.name}",
                        {
                            "stat": "Maximum"
                        }
                    ]
                ],
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "text",
            "width": 24,
            "height": 1,
            "x": 0,
            "y": 59,
            "properties": {
                "markdown": "# Lambda Function Logs: ${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}"
            }
        },
        {
            "type": "log",
            "width": 24,
            "height": 6,
            "x": 0,
            "y": 60,
            "properties": {
                "view": "table",
                "title": "CRITICAL Logs",
                "region": "${local.region}",
                "query": "SOURCE '/aws/lambda/${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}' | fields @timestamp, message, s3_key\n                | filter level == \"CRITICAL\"\n                | sort @timestamp desc\n                | limit 100"
            }
        },
        {
            "type": "log",
            "width": 24,
            "height": 6,
            "x": 0,
            "y": 66,
            "properties": {
                "view": "table",
                "title": "ERROR Logs",
                "region": "${local.region}",
                "query": "SOURCE '/aws/lambda/${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}' | fields @timestamp, message, s3_key\n                | filter level == \"ERROR\"\n                | sort @timestamp desc\n                | limit 100"
            }
        },
        {
            "type": "text",
            "width": 12,
            "height": 3,
            "x": 0,
            "y": 72,
            "properties": {
                "markdown": "## Sample query\nTo investigate critical/error log with CloudWatch Logs Insights\n\n```\nfields @timestamp, @message\n| filter s3_key == \"copy s3_key and paste here\"\nOR @requestId == \"copy function_request_id and paste here\"```"
            }
        },
        {
            "type": "log",
            "width": 24,
            "height": 6,
            "x": 0,
            "y": 75,
            "properties": {
                "view": "table",
                "title": "Exception Logs",
                "region": "${local.region}",
                "query": "SOURCE '/aws/lambda/${aws_lambda_function.LambdaEsLoader4B1E2DD9.function_name}' | fields @timestamp, @message\n                | filter @message =~ /^\\\\[ERROR]/\n                | filter @message not like /No active exception to reraise/\n                # exclude raise without Exception\n                | sort @timestamp desc\n                | limit 100"
            }
        }
    ]
}
EOF
}