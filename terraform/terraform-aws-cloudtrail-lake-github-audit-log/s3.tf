resource "aws_s3_bucket" "github_audit_logs" {
  #checkov:skip=CKV_AWS_144:Can be enabled based on customer need
  #checkov:skip=CKV_AWS_18:Can be enabled based on customer need  
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = var.github_auditlog_s3bucket
}

resource "aws_s3_bucket_public_access_block" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs.0.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.github_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  name   = "Tier1"
  status = "Enabled"

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  rule {
    id = "IntelligentTier"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"

    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "github_audit_logs" {
  count  = var.create_github_auditlog_s3bucket ? 1 : 0
  bucket = aws_s3_bucket.github_audit_logs[count.index].bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.github_s3_reader.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json.log.gz"
  }
}
