<!-- BEGIN_TF_DOCS -->
# New GitHub Audit Log S3 Bucket

The example deploy the integration of GitHub Audit Log to AWS CloudTrail Lake with a new S3 bucket for GitHub audit log. After the module is deployed, use the module output S3 bucket name to configure GitHub audit log. Check the guide [Setting up streaming to Amazon S3](https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/streaming-the-audit-log-for-your-enterprise#setting-up-streaming-to-amazon-s3).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github-cloudtrail-auditlog"></a> [github-cloudtrail-auditlog](#module\_github-cloudtrail-auditlog) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudtrail_lake_channel_arn"></a> [cloudtrail\_lake\_channel\_arn](#input\_cloudtrail\_lake\_channel\_arn) | channel ARN that you setup from CloudTrail Lake integration for GitHub Audit Log | `string` | n/a | yes |
| <a name="input_github_auditlog_s3bucket"></a> [github\_auditlog\_s3bucket](#input\_github\_auditlog\_s3bucket) | Source S3 bucket of GitHub Audit Log, enter existing or specify new bucket name | `string` | n/a | yes |
| <a name="input_create_github_auditlog_s3bucket"></a> [create\_github\_auditlog\_s3bucket](#input\_create\_github\_auditlog\_s3bucket) | If `true` the module will create the bucket github\_auditlog\_s3bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_auditlog_s3bucket"></a> [github\_auditlog\_s3bucket](#output\_github\_auditlog\_s3bucket) | n/a |
| <a name="output_github_s3_reader_function"></a> [github\_s3\_reader\_function](#output\_github\_s3\_reader\_function) | n/a |
<!-- END_TF_DOCS -->