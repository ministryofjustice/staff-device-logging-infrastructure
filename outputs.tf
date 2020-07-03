output "beats_role_arn" {
  value = module.logging.beats_role_arn
}

output "beats_security_groups" {
  value = module.logging.beats_security_groups
}

output "beats_subnet_ids" {
  value = join(",", module.logging_vpc.private_subnets)
}

output "beats_sqs_data_source_arn" {
  value = module.customLoggingApi.custom_log_queue_arn
}
