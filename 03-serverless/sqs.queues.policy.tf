data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["583933848805"]
    }

    actions   = ["sqs:*"]
    resources = ["*"]
  }
}