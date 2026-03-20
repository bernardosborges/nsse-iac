output "dlqueues_url" {
  value = aws_sqs_queue.dead_letter.*.id
}

output "queues_url" {
  value = aws_sqs_queue.nsse.*.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.order_confirmed_topic.id
}
