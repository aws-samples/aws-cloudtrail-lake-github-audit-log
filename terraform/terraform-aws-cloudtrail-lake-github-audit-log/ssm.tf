resource "aws_ssm_parameter" "github_audit_allow_list" {
  #checkov:skip=CKV2_AWS_34:Not sensitive information
  name        = var.github_audit_allow_list_ssm
  description = "Allow list of GitHub Audit event for ingestion to CloudTrail Open Audit"
  data_type   = "text"
  type        = "StringList"
  tier        = "Intelligent-Tiering"
  value       = var.github_audit_allow_list

  tags = var.tags
}

resource "aws_ssm_parameter" "github_cloudtrail_channel" {
  #checkov:skip=CKV2_AWS_34:Not sensitive information
  name        = var.github_cloudtrail_channel_ssm
  description = "CloudTrail Lake Channel ARN for GitHub audit log integration"
  data_type   = "text"
  type        = "StringList"
  tier        = "Intelligent-Tiering"
  value       = var.cloudtrail_lake_channel_arn

  tags = var.tags
}
