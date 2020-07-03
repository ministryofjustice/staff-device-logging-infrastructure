resource "aws_api_gateway_rest_api" "logging_gateway" {
  name = "${var.prefix}-CustomLogGateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  parent_id   = aws_api_gateway_rest_api.logging_gateway.root_resource_id
  path_part   = "logs"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.logging_gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method_response" "http200" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = 200
}

resource "aws_api_gateway_integration_response" "http200" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code       = aws_api_gateway_method_response.http200.status_code
  selection_pattern = "^2[0-9][0-9]"                                       // regex pattern for any 200 message that comes back from SQS

  depends_on = [
    aws_api_gateway_integration.sqs-integration
  ]
}

resource "aws_api_gateway_deployment" "custom_log_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  stage_name = "production"

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.sqs-integration
  ]
}

resource "aws_api_gateway_api_key" "custom_log_api_key" {
  name = "${var.prefix}-custom_log_api_key"
}

resource "aws_api_gateway_usage_plan" "custom_log_api_usage_plan" {
  name         = "${var.prefix}-custom_log_api_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.logging_gateway.id
    stage  = aws_api_gateway_deployment.custom_log_api_deployment.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.custom_log_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.custom_log_api_usage_plan.id
}