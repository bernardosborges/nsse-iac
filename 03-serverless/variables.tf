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
