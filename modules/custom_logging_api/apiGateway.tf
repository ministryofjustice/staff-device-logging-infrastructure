resource "aws_api_gateway_domain_name" "custom_logging_api" {
  domain_name = var.api_gateway_custom_domain

  regional_certificate_arn = aws_acm_certificate.api_gateway_logging.arn

  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

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
  rest_api_id      = aws_api_gateway_rest_api.logging_gateway.id
  resource_id      = aws_api_gateway_resource.proxy.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method_response" "http200" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  status_code = 200
}

resource "aws_api_gateway_integration_response" "http200" {
  rest_api_id       = aws_api_gateway_rest_api.logging_gateway.id
  resource_id       = aws_api_gateway_resource.proxy.id
  http_method       = aws_api_gateway_method.proxy.http_method
  status_code       = aws_api_gateway_method_response.http200.status_code
  selection_pattern = "^2[0-9][0-9]" // regex pattern for any 200 message that comes back from SQS

  depends_on = [
    aws_api_gateway_integration.sqs-integration
  ]
}

resource "aws_api_gateway_deployment" "custom_log_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.sqs-integration),
    )))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.sqs-integration,
  ]
}

resource "aws_api_gateway_stage" "custom_log_api_stage" {
  deployment_id = aws_api_gateway_deployment.custom_log_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.logging_gateway.id
  stage_name    = var.stage_name
  depends_on    = [aws_cloudwatch_log_group.custom_log_group]

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.custom_log_group.arn
    format          = file("${path.module}/logFormat.json")
  }
}

resource "aws_api_gateway_api_key" "custom_log_api_key" {
  name = "${var.prefix}-custom_log_api_key"
}

resource "aws_api_gateway_usage_plan" "custom_log_api_usage_plan" {
  name = "${var.prefix}-custom_log_api_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.logging_gateway.id
    stage  = aws_api_gateway_stage.custom_log_api_stage.stage_name
  }

  depends_on = [
    aws_api_gateway_stage.custom_log_api_stage
  ]
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.custom_log_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.custom_log_api_usage_plan.id
}

resource "aws_api_gateway_account" "account_wide_settings" {
  count               = var.enable_api_gateway_logs ? 1 : 0
  cloudwatch_role_arn = "${aws_iam_role.custom-logging-api-gateway-role.arn}"
}

resource "aws_api_gateway_method_settings" "api_settings" {
  rest_api_id = "${aws_api_gateway_rest_api.logging_gateway.id}"
  stage_name  = "${aws_api_gateway_stage.custom_log_api_stage.stage_name}"
  method_path = "*/*"

  depends_on = [aws_api_gateway_account.account_wide_settings, aws_cloudwatch_log_group.custom_log_group]

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
  }
}

resource "aws_cloudwatch_log_group" "custom_log_group" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.logging_gateway.id}/${var.stage_name}"
  retention_in_days = 7
}
