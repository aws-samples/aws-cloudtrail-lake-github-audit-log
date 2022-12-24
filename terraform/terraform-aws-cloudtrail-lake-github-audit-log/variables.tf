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
    condition = contains([true, false], var.create_github_auditlog_s3bucket)
    error_message = "Valid value for create_github_auditlog_s3bucket is true or false"
  }
}

variable "cloudtrail_lake_channel_arn" {
  type        = string
  description = "channel ARN that you setup from CloudTrail Lake integration for GitHub Audit Log"
}

variable "github_auditlog_s3bucket_origin_account" {
  type        = string
  description = "Account Id that owned the S3 bucket, leave empty if the bucket is owned by this account"
  default     = ""
  validation {
    condition     = (var.github_auditlog_s3bucket_origin_account == "" || can(regex("^\\d{12}$", var.github_auditlog_s3bucket_origin_account)))
    error_message = "Variable var: github_auditlog_s3bucket_origin_account is not valid."
  }
}

variable "github_audit_allow_list" {
  type        = string
  description = "Comma delimited list of GitHub Audit Event to be allowed for ingestion to CloudTrail Open Audit"
  default     = "repo.*,org.*,enterprise.*,business.*,integration.*,git.*,secret_scanning.*,team.*,two_factor_authentication.*,user.*"
}

variable "github_audit_allow_list_ssm" {
  type        = string
  description = "SSM parameter name for GitHub allow list"
  default     = "/github/GitHubAuditAllowList"
}

variable "github_cloudtrail_channel_ssm" {
  type        = string
  description = "SSM parameter name for GitHub CloudTrail channel"
  default     = "/github/GitHubCloudTrailChannel"
}

variable "lambda_function_name_s3_reader" {
  type        = string
  description = "GitHub S3 reader Lambda function name"
  default     = "GitHubS3ReaderFunction"
}

variable "lambda_function_name_cloudtrail_ingest" {
  type        = string
  description = "CloudTrail Ingest Lambda function name"
  default     = "GitHubIngestFunction"
}

variable "lambda_log_level" {
  type        = string
  description = "Set Lambda function logging level, default to INFO"
  default     = "INFO"
  validation {
    condition = contains(["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], var.lambda_log_level)
    error_message = "Valid log level is one of the following: DEBUG, INFO, WARNING, ERROR, CRITICAL"
  }
}

variable "lambda_source_path" {
  type = string
  description = "Path to the Lambda function source code, default to ./sources/lambda directory in the repository root. Modify this if you move the Terrform module working directory."
  default = "../../sources/lambda"
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

