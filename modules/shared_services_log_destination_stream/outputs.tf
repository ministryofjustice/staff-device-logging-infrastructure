output "kinesis_stream_arn" {
  value = var.enable_shared_services_log_destination ? element(aws_kinesis_stream.shared_services_destination_stream.*.arn, 0) : ""
}

output "kinesis_stream_name" {
  value = var.enable_shared_services_log_destination ? element(aws_kinesis_stream.shared_services_destination_stream.*.name, 0) : ""
}
