output "github_auditlog_s3bucket" {
  value = var.github_auditlog_s3bucket
}

output "github_s3_reader_function" {
  value = aws_lambda_function.github_s3_reader.arn
}