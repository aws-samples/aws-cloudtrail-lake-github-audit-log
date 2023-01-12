resource "aws_lambda_function" "github_ingest" {
  #checkov:skip=CKV_AWS_173:No sensitive information stored in Lambda environment variables
  #checkov:skip=CKV_AWS_117:This Lambda doesn't need VPC
  #checkov:skip=CKV_AWS_116:Queue it self has DLQ so Lambda fail should redrive to DLQ
  #checkov:skip=CKV_AWS_272:Doesn't need code signing
  function_name = var.lambda_function_name_cloudtrail_ingest
  description   = "Read GitHub Audit log events, transform and push it to CloudTrail Open Audit"

  role    = aws_iam_role.github_ingest.arn
  runtime = local.lambda_runtime
  timeout = local.lambda_timeout

  handler          = "cloudtrail-ingest.lambda_handler"
  package_type     = "Zip"
  filename         = data.archive_file.github_ingest_function.output_path
  source_code_hash = data.archive_file.github_ingest_function.output_base64sha256

  reserved_concurrent_executions = 10

  tracing_config {
    mode = "PassThrough"
  }

  environment {
    variables = {
      log_level                 = var.lambda_log_level
      github_transform_dlq      = aws_sqs_queue.github_transform_dlq.url
      github_cloudtrail_channel = split("parameter", aws_ssm_parameter.github_cloudtrail_channel.arn)[1]
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "github_s3_reader" {
  #checkov:skip=CKV_AWS_173:No sensitive information stored in Lambda environment variables
  #checkov:skip=CKV_AWS_117:This Lambda doesn't need VPC
  #checkov:skip=CKV_AWS_116:Queue it self has DLQ so Lambda fail should redrive to DLQ
  #checkov:skip=CKV_AWS_272:Doesn't need code signing
  function_name = var.lambda_function_name_s3_reader
  description   = "Read S3 bucket containing GitHub Audit Log and filter and send result to SQS for batch update to CloudTrail"

  role    = aws_iam_role.github_s3_reader.arn
  runtime = local.lambda_runtime
  timeout = local.lambda_timeout

  handler          = "s3-reader.lambda_handler"
  package_type     = "Zip"
  filename         = data.archive_file.github_s3_reader_function.output_path
  source_code_hash = data.archive_file.github_s3_reader_function.output_base64sha256

  reserved_concurrent_executions = 10

  tracing_config {
    mode = "PassThrough"
  }

  environment {
    variables = {
      log_level               = var.lambda_log_level
      github_event_allow_list = split("parameter", aws_ssm_parameter.github_audit_allow_list.arn)[1]
      gh_ingest_queue         = aws_sqs_queue.github_s3_reader_queue.url
    }
  }

  tags = var.tags
}

resource "aws_lambda_event_source_mapping" "github_s3_reader_queue_to_lambda" {
  batch_size                         = 10
  enabled                            = true
  maximum_batching_window_in_seconds = 30
  event_source_arn                   = aws_sqs_queue.github_s3_reader_queue.arn
  function_name                      = aws_lambda_function.github_ingest.function_name
}

resource "aws_lambda_permission" "github_s3_reader_function_event" {
  statement_id   = "GitHubS3ReaderFunctionEvent"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.github_s3_reader.arn
  principal      = "s3.amazonaws.com"
  source_account = local.s3_origin_account
  source_arn     = "arn:${local.context.aws_partition_id}:s3:::${var.github_auditlog_s3bucket}"
}

resource "aws_lambda_permission" "github_ingest_function_event" {
  statement_id   = "GitHubIngestFunctionEvent"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.github_ingest.arn
  principal      = "s3.amazonaws.com"
  source_account = local.s3_origin_account
  source_arn     = "arn:${local.context.aws_partition_id}:s3:::${var.github_auditlog_s3bucket}"
}

## Lambda CloudWatch Logs

resource "aws_cloudwatch_log_group" "github_s3_reader_loggroup" {
  name              = "/aws/lambda/${var.lambda_function_name_s3_reader}"
  retention_in_days = 120
  kms_key_id        = aws_kms_key.github_encryption_key.arn

  depends_on = [aws_kms_key.github_encryption_key]

}

resource "aws_cloudwatch_log_group" "github_ingest_loggroup" {
  name              = "/aws/lambda/${var.lambda_function_name_cloudtrail_ingest}"
  retention_in_days = 120
  kms_key_id        = aws_kms_key.github_encryption_key.arn

  depends_on = [aws_kms_key.github_encryption_key]
}