resource "aws_iam_role" "github_s3_reader" {
  name        = "GitHubS3ReaderFunctionRole"
  description = "GitHub S3 Reader Lambda Function IAM Role"
  path        = "/"

  assume_role_policy = data.aws_iam_policy_document.github_s3_reader_function_assume_role.json

  inline_policy {
    name   = "github_s3_reader_policy"
    policy = data.aws_iam_policy_document.github_s3_reader_function_role.json
  }

  tags = var.tags
}

resource "aws_iam_role" "github_ingest" {
  name        = "GitHubIngestFunctionRole"
  description = "GitHub Ingest Lambda Function IAM Role"
  path        = "/"

  assume_role_policy = data.aws_iam_policy_document.github_ingest_function_assume_role.json

  inline_policy {
    name   = "github_ingest_function_policy"
    policy = data.aws_iam_policy_document.github_ingest_function_role.json
  }
  tags = var.tags
}