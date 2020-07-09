output "log_group_name" {
  value = aws_cloudwatch_log_group.cloudtrail_log_group.name
}

output "aws_account_number"{
    value = data.aws_caller_identity.current.account_id
}