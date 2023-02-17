locals {

  context = {
    aws_region_name = data.aws_region.current.name

    aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
    aws_caller_identity_arn        = data.aws_caller_identity.current.arn

    aws_partition_id         = data.aws_partition.current.id
    aws_partition_dns_suffix = data.aws_partition.current.dns_suffix
  }

  s3_origin_account = length(var.github_auditlog_s3bucket_origin_account) != 0 ? var.github_auditlog_s3bucket_origin_account : data.aws_caller_identity.current.account_id

  lambda_timeout = 30
  lambda_runtime = "python3.8"

  lambda_source_path_s3reader = "${path.module}/${var.lambda_source_path}/s3-reader/site-packages/"
  lambda_output_path_s3reader = "${path.module}/${var.lambda_source_path}/s3-reader.zip"

  lambda_source_path_ingest = "${path.module}/${var.lambda_source_path}/cloudtrail-ingest/site-packages/"
  lambda_output_path_ingest = "${path.module}/${var.lambda_source_path}/cloudtrail-ingest.zip"

  sqs_retention = 1209600
}