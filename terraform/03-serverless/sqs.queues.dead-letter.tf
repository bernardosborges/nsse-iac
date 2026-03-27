resource "aws_sqs_queue" "dead_letter" {
  count = length(var.dl_queues)

  name                      = var.dl_queues[count.index].name
  delay_seconds             = var.dl_queues[count.index].delay_seconds
  max_message_size          = var.dl_queues[count.index].max_message_size
  message_retention_seconds = var.dl_queues[count.index].message_retention_seconds
  receive_wait_time_seconds = var.dl_queues[count.index].receive_wait_time_seconds
  sqs_managed_sse_enabled   = var.dl_queues[count.index].sqs_managed_sse_enabled
  policy                    = data.aws_iam_policy_document.sqs_policy.json
  tags                      = var.tags
}

resource "aws_sqs_queue_redrive_allow_policy" "dead_letter" {
  count = length(aws_sqs_queue.dead_letter)

  queue_url = aws_sqs_queue.dead_letter[count.index].id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns = [one([
      for queue in aws_sqs_queue.nsse : queue.arn
      if startswith(aws_sqs_queue.dead_letter[count.index].name, queue.name)
    ])]
  })
}