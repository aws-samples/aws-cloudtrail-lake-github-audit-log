resource "aws_sqs_queue" "github_s3_reader_dlq" {
  name                      = "GitHubS3ReaderDLQ"
  message_retention_seconds = local.sqs_retention
  kms_master_key_id         = aws_kms_key.github_encryption_key.key_id
  tags                      = var.tags
}

resource "aws_sqs_queue" "github_s3_reader_queue" {
  name                      = "GitHubS3ReaderQueue"
  message_retention_seconds = local.sqs_retention
  kms_master_key_id         = aws_kms_key.github_encryption_key.key_id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.github_s3_reader_dlq.arn
    maxReceiveCount     = 3
  })
  tags = var.tags
}

resource "aws_sqs_queue" "github_transform_dlq" {
  name                      = "githubTransformDLQ.fifo"
  fifo_queue                = true
  message_retention_seconds = local.sqs_retention
  kms_master_key_id         = aws_kms_key.github_encryption_key.key_id
  tags                      = var.tags
}

resource "aws_sqs_queue_policy" "github_s3_reader_queue" {
  queue_url = aws_sqs_queue.github_s3_reader_queue.url
  policy    = data.aws_iam_policy_document.github_s3_reader_queue.json
}

resource "aws_sqs_queue_policy" "github_s3_reader_dlq" {
  queue_url = aws_sqs_queue.github_s3_reader_dlq.url
  policy    = data.aws_iam_policy_document.github_s3_reader_queue_dlq.json
}

resource "aws_sqs_queue_policy" "github_transform_dlq" {
  queue_url = aws_sqs_queue.github_transform_dlq.id
  policy    = data.aws_iam_policy_document.github_transform_dlq.json
}

