output "beats_role_arn" {
  value = module.logging.beats_role_arn
}

output "beats_security_group_id" {
  value = module.logging.beats_security_group_id
}

output "beats_subnet_ids" {
  value = join(",", module.logging_vpc.private_subnets)
}

output "beats_sqs_data_source_arn" {
  value = module.customLoggingApi.custom_log_queue_arn
}

output "logging_api_endpoint_path" {
  value = module.customLoggingApi.logging_endpoint_path
}

output "logging_api_key" {
  value     = module.customLoggingApi.custom_logging_api_key
  sensitive = true
}

output "logging_terraform_outputs" {
  value = {
    syslog = {
      ecr = module.syslog_endpoint.ecr
      health_check = module.syslog_endpoint.health_check_ecr
    }
  }
}
