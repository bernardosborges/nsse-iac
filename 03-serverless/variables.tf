variable "region" {
  type    = string
  default = "us-east-1"
}

variable "assume_role" {
  type = object({
    role_arn    = string
    external_id = string
  })

  default = {
    role_arn    = "arn:aws:iam::583933848805:role/terraform-role"
    external_id = "38fcec02-aedd-4633-9cca-1972705927b3"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "nsse"
  }
}

variable "queues" {
  type = list(object({
    name                      = string
    delay_seconds             = number
    max_message_size          = number
    message_retention_seconds = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled   = bool
  }))

  default = [
    {
      name                      = "EmailNotificationQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    },
    {
      name                      = "ProductStockQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    },
    {
      name                      = "InvoiceQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    }
  ]
}

variable "dl_queues" {
  type = list(object({
    name                      = string
    delay_seconds             = number
    max_message_size          = number
    message_retention_seconds = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled   = bool
  }))

  default = [
    {
      name                      = "EmailNotificationQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    },
    {
      name                      = "ProductStockQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    },
    {
      name                      = "InvoiceQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    }
  ]
}

variable "order_confirmed_topic" {
  type = object({
    name                             = string
    role_name                        = string
    sqs_success_feedback_sample_rate = number
    subscriptions                    = list(string)
  })

  default = {
    name                             = "OrderConfirmedTopic"
    role_name                        = "SnsTopicRole"
    sqs_success_feedback_sample_rate = 100
    subscriptions                    = ["InvoiceQueue", "ProductStockQueue"]
  }
}

variable "s3_application_bucket_name" {
  type    = string
  default = "nsse-application-bucket-bsb"
}

variable "vpc" {
  type = object({
    name = string
  })

  default = {
    name = "nsse-vpc"
  }
}

variable "db_subnet_group_name" {
  type    = string
  default = "nsse-production-db-subnet-group"
}

variable "security_groups" {
  type = object({
    control_plane_security_group_name = string
    worker_security_group_name        = string
    rds_security_group_name           = string
    documentdb_security_group_name    = string
  })

  default = {
    control_plane_security_group_name = "nsse-production-control-plane-sg"
    worker_security_group_name        = "nsse-production-worker-sg"
    rds_security_group_name           = "nsse-production-rds-sg"
    documentdb_security_group_name    = "nsse-production-documentdb-sg"
  }
}

variable "rds_aurora_cluster" {
  type = object({
    cluster_identifier           = string
    final_snapshot_identifier    = string
    engine                       = string
    engine_mode                  = string
    database_name                = string
    master_username              = string
    preferred_maintenance_window = string
    availability_zones           = list(string)
    manage_master_user_password  = bool
    storage_encrypted            = bool
    deletion_protection          = bool
    skip_final_snapshot          = bool
    instances = list(object({
      instance_class    = string
      identifier        = string
      availability_zone = string
    }))
    serverless_scaling_configuration = object({
      max_capacity             = number
      min_capacity             = number
      seconds_until_auto_pause = number
    })
  })

  default = {
    cluster_identifier           = "nsse-aurora-serverless-cluster"
    final_snapshot_identifier    = "nsse-aurora-serverless-cluster-final-snapshot"
    engine                       = "aurora-postgresql"
    engine_mode                  = "provisioned"
    database_name                = "notSoSimpleEcommerce"
    master_username              = "nsseAdmin"
    preferred_maintenance_window = "sun:05:00-sun:06:00"
    availability_zones           = ["us-east-1a", "us-east-1b"]
    manage_master_user_password  = true
    storage_encrypted            = true
    deletion_protection          = false # true in production
    skip_final_snapshot          = true  # false in production
    instances = [{
      instance_class    = "db.serverless"
      identifier        = "nsse-instance-us-east-1a"
      availability_zone = "us-east-1a"
      },
      {
        instance_class    = "db.serverless"
        identifier        = "nsse-instance-us-east-1b"
        availability_zone = "us-east-1b"
    }]
    serverless_scaling_configuration = {
      max_capacity             = 1.0
      min_capacity             = 0.5
      seconds_until_auto_pause = 3600
    }
  }
}

variable "rds_proxy" {
  type = object({
    name                = string
    debug_logging       = bool
    engine_family       = string
    idle_client_timeout = number
    require_tls         = bool
    auth = object({
      auth_scheme = string
      iam_auth    = string
    })
    role_name          = string
    policy_name        = string
    read_only_endpoint = string
  })

  default = {
    name                = "nsse-aurora-serverless-cluster-proxy"
    debug_logging       = false
    engine_family       = "POSTGRESQL"
    idle_client_timeout = 300
    require_tls         = true
    auth = {
      auth_scheme = "SECRETS"
      iam_auth    = "DISABLED"
    }
    role_name          = "nsse-production-rds-proxy-role"
    policy_name        = "nsse-production-rds-proxy-policy"
    read_only_endpoint = "nsse-aurora-serverless-cluster-proxy-readonly"
  }
}

variable "lambda_order_confirmed" {
  type = object({
    package_type  = string
    source_dir    = string
    output_path   = string
    function_name = string
    handler       = string
    runtime       = string
    role_name     = string
    policy_name   = string
  })
  default = {
    package_type  = "zip"
    source_dir    = "lambdas/order-confirmed/build"
    output_path   = "lambdas/order-confirmed/outputs/package.zip"
    function_name = "orderConfirmedLambdaFunction"
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    role_name     = "nsse-production-order-confirmed-lambda-role"
    policy_name   = "nsse-production-order-confirmed-lambda-policy"
  }
}

variable "lambda_layer_node_modules" {
  type = object({
    package_type        = string
    source_dir          = string
    output_path         = string
    layer_name          = string
    compatible_runtimes = list(string)
  })
  default = {
    package_type        = "zip"
    source_dir          = "lambdas/layers/dependencies"
    output_path         = "lambdas/layers/outputs/node_modules_layer.zip"
    layer_name          = "node_modules"
    compatible_runtimes = ["nodejs20.x"]
  }
}

variable "lambda_report_job" {
  type = object({
    timeout       = number
    package_type  = string
    source_dir    = string
    output_path   = string
    function_name = string
    handler       = string
    runtime       = string
    role_name     = string
    policy_name   = string
  })
  default = {
    timeout       = 30
    package_type  = "zip"
    source_dir    = "lambdas/report-job/build"
    output_path   = "lambdas/report-job/outputs/package.zip"
    function_name = "reportJobLambdaFunction"
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    role_name     = "nsse-production-report-job-lambda-role"
    policy_name   = "nsse-production-report-job-lambda-policy"
  }
}

variable "domain" {
  type    = string
  default = "relistapi.xyz"
}

variable "documentdb_cluster" {
  type = object({
    cluster_identifier              = string
    final_snapshot_identifier       = string
    engine                          = string
    database_name                   = string
    s3_certificate_path             = string
    master_username                 = string
    backup_retention_period         = number
    preferred_backup_window         = string
    preferred_maintenance_window    = string
    availability_zones              = list(string)
    storage_encrypted               = bool
    enabled_cloudwatch_logs_exports = list(string)
    skip_final_snapshot             = bool
    subnet_group_name               = string
    secret_name                     = string
    parameter_group = object({
      family     = string
      name       = string
      audit_logs = string
      profiler   = string
    })
    instance = object({
      identifier = string
      class      = string
    })
  })

  default = {
    cluster_identifier              = "nsse-production-documentdb-cluster"
    final_snapshot_identifier       = "nsse-production-documentdb-cluster-final-snapshot"
    engine                          = "docdb"
    database_name                   = "notSoSimpleEcommerce"
    s3_certificate_path             = "app/documentdb-ca.pem"
    master_username                 = "nsse"
    backup_retention_period         = 7
    preferred_backup_window         = "01:00-02:00"
    preferred_maintenance_window    = "sun:03:00-sun:04:00"
    availability_zones              = ["us-east-1a", "us-east-1b"]
    storage_encrypted               = true
    enabled_cloudwatch_logs_exports = ["audit", "profiler"]
    skip_final_snapshot             = true # false in production
    subnet_group_name               = "nsse-production-documentdb-subnet-group"
    secret_name                     = "nsse-production-documentdb-secret"
    parameter_group = {
      family     = "docdb5.0"
      name       = "nsse-production-documentdb-parameter-group"
      audit_logs = "enabled"
      profiler   = "enabled"
    }
    instance = {
      identifier = "nsse-production-documentdb-single-instance"
      class      = "db.t3.medium"
    }
  }
}
