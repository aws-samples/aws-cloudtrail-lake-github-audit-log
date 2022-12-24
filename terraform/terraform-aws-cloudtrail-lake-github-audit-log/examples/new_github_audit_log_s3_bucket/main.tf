data "aws_region" "current" {
}

module "github-cloudtrail-auditlog" {
  source                          = "../../"
  create_github_auditlog_s3bucket = var.create_github_auditlog_s3bucket
  github_auditlog_s3bucket        = var.github_auditlog_s3bucket
  cloudtrail_lake_channel_arn     = var.cloudtrail_lake_channel_arn
}
