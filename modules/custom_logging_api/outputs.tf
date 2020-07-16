output "logging_endpoint_path" {
  value = "${aws_api_gateway_deployment.custom_log_api_deployment.invoke_url}${aws_api_gateway_stage.custom_log_api_stage.stage_name}/${aws_api_gateway_resource.proxy.path_part}"
}

output "base_api_url" {
  value = "${aws_api_gateway_deployment.custom_log_api_deployment.invoke_url}${aws_api_gateway_stage.custom_log_api_stage.stage_name}"
}

output "custom_log_queue_url" {
  value = aws_sqs_queue.custom_log_queue.id
}

output "custom_logging_api_key" {
  value = aws_api_gateway_api_key.custom_log_api_key.value
}

output "custom_log_queue_arn" {
  value = aws_sqs_queue.custom_log_queue.arn
}

output "custom_log_queue_name" {
  value = aws_sqs_queue.custom_log_queue.name
}

output "dlq_custom_log_queue_url" {
  value = aws_sqs_queue.dlq_custom_log_queue.id
}

output "dlq_custom_log_queue_arn" {
  value = aws_sqs_queue.dlq_custom_log_queue.arn
}

output "dlq_custom_log_queue_name" {
  value = aws_sqs_queue.dlq_custom_log_queue.name
}

output "custom_log_api_gateway_name" {
  value = aws_api_gateway_rest_api.logging_gateway.name
}
