output "github_auditlog_s3bucket" {
  value = module.github-cloudtrail-auditlog.github_auditlog_s3bucket
}

output "github_s3_reader_function" {
  value = module.github-cloudtrail-auditlog.github_s3_reader_function
}