## GitHub Audit Log to CloudTrail Lake Integration with SAM CLI

To use the SAM CLI, you need the following tools installed:
* SAM CLI - [Install the SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* [Python 3 installed](https://www.python.org/downloads/)
* Docker - [Install Docker community edition](https://hub.docker.com/search/?type=edition&offering=community)

Clone this repository to your workspace area. SAM CLI should be configured with AWS credentials from the AWS account where you plan to store CloudTrail Lake data store. Run the following in your shell:

```bash
cd SAM
sam build
sam deploy --guided
```

**Parameters:**
Enter the following parameters or use the default values:

- CloudTrailLakeChannelArn: Channel ARN that you setup from CloudTrail Lake integration for GitHub Audit Log.
- CreateS3Bucket: Set to Yes if you want CloudFormation to create a new bucket.
- S3OriginAccount: AWS account Id that own the S3 bucket, leave empty if the bucket is owned by this account.
- GitHubAuditLogS3Bucket: Source S3 bucket of GitHub Audit Log, enter existing or specify new bucket name.
- GitHubAuditAllowList: Comma delimited list of GitHub Audit Event to be allowed for ingestion to CloudTrail Open Audit. **Important:** The default value includes: `repo.*,org.*,enterprise.*,business.*,integration.*,git.*,secret_scanning.*,team.*,two_factor_authentication.*,user.*` , adjust this accordingly.
- FunctionLogLevel: Set Lambda function logging level, default to INFO

For full list of available GitHub audit log event, check the [GitHub documentation](https://docs.github.com/en/enterprise-server@3.4/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/audit-log-events-for-your-enterprise)
