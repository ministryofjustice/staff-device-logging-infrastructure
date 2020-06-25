resource "aws_api_gateway_rest_api" "logging_gateway" {
  name = "CustomLogGateway"

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
}

resource "aws_api_gateway_integration" "sqs-integration" {
  http_method = aws_api_gateway_method.proxy.http_method
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  type = "AWS"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:eu-west-2:sqs:path/${aws_sqs_queue.custom_log_queue.name}"
  credentials = aws_iam_role.custom-logging-sqs-write-role.arn
}

resource "aws_iam_role" "custom-logging-sqs-write-role" {
  assume_role_policy = data.aws_iam_policy_document.custom-logging-sqs-write-role-assume-policy.json
  permissions_boundary = ""
}

resource "aws_iam_role_policy_attachment" "sqs-send-message-custom-logging-attachment" {
  policy_arn = aws_iam_policy.api-gateway-sqs-send-msg-policy.arn
  role = aws_iam_role.custom-logging-sqs-write-role.arn
}

data "aws_iam_policy_document" "custom-logging-sqs-write-role-assume-policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      aws_api_gateway_rest_api.logging_gateway.arn
    ]
  }
}

# following this blog post to create a queue which is written to by the api gateway
# https://medium.com/@pranaysankpal/aws-api-gateway-proxy-for-sqs-simple-queue-service-5b08fe18ce50
resource "aws_sqs_queue" "custom_log_queue" {
  name = "CustomLogQueue"
}

resource "aws_iam_policy" "api-gateway-sqs-send-msg-policy" {
  policy = data.aws_iam_policy_document.api-gateway-sqs-send-msg-policy-doc.json
}



data "aws_iam_policy_document" "api-gateway-sqs-send-msg-policy-doc" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.custom_log_queue.arn
    ]
  }
}
