resource "aws_api_gateway_integration" "sqs-integration" {
  http_method = aws_api_gateway_method.proxy.http_method
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  type = "AWS"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.custom_log_queue.name}"
  credentials = aws_iam_role.custom-logging-api-gateway-role.arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.json('$')"
  }
}

