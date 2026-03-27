resource "aws_iam_role" "scheduler_excution_role" {
  name               = var.eventbridge_scheduler_lambda_report_job.role_name
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json
}

resource "aws_iam_policy" "invoke_lambda_policy" {
  name        = var.eventbridge_scheduler_lambda_report_job.policy_name
  description = "Policy for Invoke Lambda"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "lambda:InvokeFunction"
      ],
      Resource = ["*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_scheduler_lambda_invoke" {
  role       = aws_iam_role.scheduler_excution_role.name
  policy_arn = aws_iam_policy.invoke_lambda_policy.arn
}
