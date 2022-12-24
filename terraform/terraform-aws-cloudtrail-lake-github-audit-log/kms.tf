resource "aws_kms_key" "github_encryption_key" {
  description         = "KMS key to encrypt all content in the SQS for GitHub Lambda function integration"
  policy              = data.aws_iam_policy_document.github_encryption_key.json
  enable_key_rotation = true
  tags                = var.tags
}

# Assign an alias to the key
resource "aws_kms_alias" "github_encryption_key" {
  name          = "alias/GitHubCloudTrailOpenEvent"
  target_key_id = aws_kms_key.github_encryption_key.key_id
}
