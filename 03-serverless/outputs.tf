output "dlqueues_url" {
  value = aws_sqs_queue.dead_letter.*.id
}

output "queues_url" {
  value = aws_sqs_queue.nsse.*.id
}