<!-- BEGIN_TF_DOCS -->
# GitHub Audit Log to CloudTrail Lake Module

This module can be used to integrate GitHub Audit Log to AWS CloudTrail Lake. This solution uses GitHub Audit Log streaming to S3 as the data source, transform and send the events to CloudTrail Lake data store. Refer to the [solution readme](../../README.md) for more details.

## Usage

You must complete the [general prerequisites](../../README.md#general-prerequisites) as referenced in the solution README before deploying this module.

Build the lambda by running the following command
```
make all
```

The example below will deploy the module with a new S3 bucket for GitHub audit log.

```
module "github-cloudtrail-auditlog" {
  source                          = "../../"
  create_github_auditlog_s3bucket = true
  github_auditlog_s3bucket        = "my_new_github_auditlog_s3bucket" # bucket name must be unique
  cloudtrail_lake_channel_arn     = "arn:aws:cloudtrail:us-east-1:204034886740:channel/0dec681b-ff12-499a-a7ba-7866086b2a86" # complete the prerequisite to get channel ARN
}
```

After the module is deployed, use the module output S3 bucket name to configure GitHub audit log. Check the guide [Setting up streaming to Amazon S3](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise#setting-up-streaming-to-amazon-s3). Refer to the [examples](./examples/) for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.github_ingest_loggroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.github_s3_reader_loggroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.github_ingest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_s3_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_alias.github_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.github_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_event_source_mapping.github_s3_reader_queue_to_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.github_ingest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.github_s3_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.github_ingest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.github_ingest_function_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.github_s3_reader_function_event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.github_audit_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sqs_queue.github_s3_reader_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.github_s3_reader_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.github_transform_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.github_s3_reader_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.github_s3_reader_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.github_transform_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_ssm_parameter.github_audit_allow_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.github_cloudtrail_channel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [archive_file.github_ingest_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.github_s3_reader_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_ingest_function_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_ingest_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_s3_reader_function_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_s3_reader_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_s3_reader_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_s3_reader_queue_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_transform_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_lake_channel_arn"></a> [cloudtrail\_lake\_channel\_arn](#input\_cloudtrail\_lake\_channel\_arn) | channel ARN that you setup from CloudTrail Lake integration for GitHub Audit Log | `string` | n/a | yes |
| <a name="input_github_auditlog_s3bucket"></a> [github\_auditlog\_s3bucket](#input\_github\_auditlog\_s3bucket) | Source S3 bucket of GitHub Audit Log, enter existing or specify new bucket name | `string` | n/a | yes |
| <a name="input_create_github_auditlog_s3bucket"></a> [create\_github\_auditlog\_s3bucket](#input\_create\_github\_auditlog\_s3bucket) | If `true` the module will create the bucket github\_auditlog\_s3bucket. | `bool` | `false` | no |
| <a name="input_github_audit_allow_list"></a> [github\_audit\_allow\_list](#input\_github\_audit\_allow\_list) | Comma delimited list of GitHub Audit Event to be allowed for ingestion to CloudTrail Open Audit | `string` | `"repo.*,org.*,enterprise.*,business.*,integration.*,git.*,secret_scanning.*,team.*,two_factor_authentication.*,user.*"` | no |
| <a name="input_github_audit_allow_list_ssm"></a> [github\_audit\_allow\_list\_ssm](#input\_github\_audit\_allow\_list\_ssm) | SSM parameter name for GitHub allow list | `string` | `"/github/GitHubAuditAllowList"` | no |
| <a name="input_github_auditlog_s3bucket_origin_account"></a> [github\_auditlog\_s3bucket\_origin\_account](#input\_github\_auditlog\_s3bucket\_origin\_account) | Account Id that owned the S3 bucket, leave empty if the bucket is owned by this account | `string` | `""` | no |
| <a name="input_github_cloudtrail_channel_ssm"></a> [github\_cloudtrail\_channel\_ssm](#input\_github\_cloudtrail\_channel\_ssm) | SSM parameter name for GitHub CloudTrail channel | `string` | `"/github/GitHubCloudTrailChannel"` | no |
| <a name="input_lambda_function_name_cloudtrail_ingest"></a> [lambda\_function\_name\_cloudtrail\_ingest](#input\_lambda\_function\_name\_cloudtrail\_ingest) | CloudTrail Ingest Lambda function name | `string` | `"GitHubIngestFunction"` | no |
| <a name="input_lambda_function_name_s3_reader"></a> [lambda\_function\_name\_s3\_reader](#input\_lambda\_function\_name\_s3\_reader) | GitHub S3 reader Lambda function name | `string` | `"GitHubS3ReaderFunction"` | no |
| <a name="input_lambda_log_level"></a> [lambda\_log\_level](#input\_lambda\_log\_level) | Set Lambda function logging level, default to INFO | `string` | `"INFO"` | no |
| <a name="input_lambda_source_path"></a> [lambda\_source\_path](#input\_lambda\_source\_path) | Path to the Lambda function source code, default to ./sources/lambda directory in the repository root. Modify this if you move the Terrform module working directory. | `string` | `"../../sources/lambda"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_auditlog_s3bucket"></a> [github\_auditlog\_s3bucket](#output\_github\_auditlog\_s3bucket) | n/a |
| <a name="output_github_s3_reader_function"></a> [github\_s3\_reader\_function](#output\_github\_s3\_reader\_function) | n/a |
<!-- END_TF_DOCS -->