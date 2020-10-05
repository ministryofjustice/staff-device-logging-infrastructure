output "log_group_name" {
  value = element(aws_cloudwatch_log_group.cloudtrail_log_group.*.name, 0)
}

output "aws_account_number" {
  value = data.aws_caller_identity.current.account_id
}
