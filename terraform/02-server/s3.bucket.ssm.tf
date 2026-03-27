resource "aws_s3_bucket" "ansible_ssm" {
  bucket = var.s3_ansible_bucket_name

  tags = var.tags
}
