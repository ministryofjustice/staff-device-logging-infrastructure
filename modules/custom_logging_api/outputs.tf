output "logging_endpoint_path" {
  value = "${aws_api_gateway_deployment.custom_log_api_deployment.invoke_url}/${aws_api_gateway_resource.proxy.path_part}"
}

output "custom_log_queue_url" {
  value = aws_sqs_queue.custom_log_queue.id
}

output "custom_logging_api_key" {
  value = aws_api_gateway_api_key.custom_log_api_key.value
}