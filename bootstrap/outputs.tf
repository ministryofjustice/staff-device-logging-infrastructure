output "s3_state_bucket_name" {
  value = aws_s3_bucket.s3_state.bucket
}

output "state_locking_table" {
  value = aws_dynamodb_table.dynamodb_terraform_state_lock.name
}

output "admin_role_arn" {
  value = aws_iam_role.shared_services_admin.arn
}
