resource "aws_scheduler_schedule" "lambda_report_job" {
  name       = var.eventbridge_scheduler_lambda_report_job.schedule_name
  group_name = var.eventbridge_scheduler_lambda_report_job.schedule_group_name

  flexible_time_window {
    mode = var.eventbridge_scheduler_lambda_report_job.schedule_flexible_time_window
  }

  schedule_expression = var.eventbridge_scheduler_lambda_report_job.schedule_expression

  target {
    arn      = aws_lambda_function.report_job.arn
    role_arn = aws_iam_role.scheduler_excution_role.arn
  }
}
