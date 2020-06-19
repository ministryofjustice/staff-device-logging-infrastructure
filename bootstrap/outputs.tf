output "s3_state_bucket_name" {
  value = aws_s3_bucket.s3_state.bucket
}

output "admin_role_arn" {
  value = aws_iam_role.shared_services_admin.arn
}
