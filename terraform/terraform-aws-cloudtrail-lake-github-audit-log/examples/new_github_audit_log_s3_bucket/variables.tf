variable "github_auditlog_s3bucket" {
  type        = string
  description = "Source S3 bucket of GitHub Audit Log, enter existing or specify new bucket name"
  validation {
    condition     = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$", var.github_auditlog_s3bucket))
    error_message = "Invalid bucket name, please check https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html for more details."
  }
}

variable "create_github_auditlog_s3bucket" {
  type        = bool
  description = "If `true` the module will create the bucket github_auditlog_s3bucket."
  default     = false
  validation {
    condition     = contains([true, false], var.create_github_auditlog_s3bucket)
    error_message = "Valid value for create_github_auditlog_s3bucket is true or false"
  }
}

variable "cloudtrail_lake_channel_arn" {
  type        = string
  description = "channel ARN that you setup from CloudTrail Lake integration for GitHub Audit Log"
}