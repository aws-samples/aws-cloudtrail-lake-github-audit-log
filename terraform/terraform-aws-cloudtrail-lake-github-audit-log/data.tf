data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:${local.context.aws_partition_id}:s3:::${var.github_auditlog_s3bucket}/*",
      "arn:${local.context.aws_partition_id}:s3:::${var.github_auditlog_s3bucket}"
    ]
    principals {
      type = "*"
      identifiers = [
        "*"
      ]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "github_encryption_key" {
  #checkov:skip=CKV_AWS_109:Skip
  #checkov:skip=CKV_AWS_111:Skip
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:root"
      ]
    }
  }
  statement {
    sid    = "Allow Service CloudWatchLogGroup"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:Describe",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]

    principals {
      type = "Service"
      identifiers = [
        "logs.${local.context.aws_region_name}.amazonaws.com"
      ]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:${local.context.aws_partition_id}:logs:${local.context.aws_region_name}:${local.context.aws_caller_identity_account_id}:log-group:/aws/lambda/${var.lambda_function_name_s3_reader}",
        "arn:${local.context.aws_partition_id}:logs:${local.context.aws_region_name}:${local.context.aws_caller_identity_account_id}:log-group:/aws/lambda/${var.lambda_function_name_cloudtrail_ingest}"
      ]
    }
  }
}

data "aws_iam_policy_document" "github_s3_reader_queue_dlq" {
  statement {
    sid    = "AllowOwner"
    effect = "Allow"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_s3_reader_dlq.arn]

    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:root"
      ]
    }
  }

  statement {
    sid    = "DenyNonHTTPS"
    effect = "Deny"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_s3_reader_dlq.arn]

    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

}

data "aws_iam_policy_document" "github_s3_reader_queue" {
  statement {
    sid    = "AllowOwner"
    effect = "Allow"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_s3_reader_queue.arn]

    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:root"
      ]
    }
  }

  statement {
    sid    = "DenyNonHTTPS"
    effect = "Deny"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_s3_reader_queue.arn]

    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

}

data "aws_iam_policy_document" "github_transform_dlq" {
  statement {
    sid    = "AllowOwner"
    effect = "Allow"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_transform_dlq.arn]

    principals {
      type = "AWS"
      identifiers = [
        "arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:root"
      ]
    }
  }

  statement {
    sid    = "DenyNonHTTPS"
    effect = "Deny"
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.github_transform_dlq.arn]

    principals {
      type = "AWS"
      identifiers = [
        "*"
      ]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

}

data "aws_iam_policy_document" "github_s3_reader_function_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "github_s3_reader_function_role" {


  statement {
    sid    = "AllowReadS3Bucket"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:${local.context.aws_partition_id}:s3:::${var.github_auditlog_s3bucket}/*"]

  }

  statement {
    sid    = "AllowKMSToEncryptSQSMessage"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"

    ]
    resources = [aws_kms_key.github_encryption_key.arn]

  }
  statement {
    sid    = "AllowSQSSendMessage"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes"

    ]
    resources = [aws_sqs_queue.github_s3_reader_queue.arn]

  }
  statement {
    sid    = "AllowSSMParameterAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"

    ]
    resources = [aws_ssm_parameter.github_audit_allow_list.arn]

  }
  statement {
    sid    = "AllowToWriteCloudWatchLog"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"

    ]
    resources = ["arn:${local.context.aws_partition_id}:logs:${local.context.aws_region_name}:${local.context.aws_caller_identity_account_id}:log-group:/aws/lambda/${var.lambda_function_name_s3_reader}:*:*"]

  }
}

data "aws_iam_policy_document" "github_ingest_function_assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "github_ingest_function_role" {

  statement {
    sid    = "AllowKMSToEncryptSQSMessage"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.github_encryption_key.arn]
  }
  statement {
    sid    = "AllowSQSReceiveMessage"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.github_s3_reader_queue.arn]
  }
  statement {
    sid    = "AllowSQSSendMessage"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.github_transform_dlq.arn]
  }
  statement {
    sid    = "AllowCloudTrailPutAudit"
    effect = "Allow"
    actions = [
      "cloudtrail-data:PutAuditEvents"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowToWriteCloudWatchLog"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:${local.context.aws_partition_id}:logs:${local.context.aws_region_name}:${local.context.aws_caller_identity_account_id}:log-group:/aws/lambda/${var.lambda_function_name_cloudtrail_ingest}:*:*"]
  }
  statement {
    sid    = "AllowSSMParameterAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [aws_ssm_parameter.github_cloudtrail_channel.arn]
  }
}

data "archive_file" "github_s3_reader_function" {
  type        = "zip"
  source_dir  = local.lambda_source_path_s3reader
  output_path = local.lambda_output_path_s3reader
}

data "archive_file" "github_ingest_function" {
  type        = "zip"
  source_dir  = local.lambda_source_path_ingest
  output_path = local.lambda_output_path_ingest
}