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
  })

  default = {
    control_plane_security_group_name = "nsse-production-control-plane-sg"
    worker_security_group_name        = "nsse-production-worker-sg"
    rds_security_group_name           = "nsse-production-rds-sg"
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
