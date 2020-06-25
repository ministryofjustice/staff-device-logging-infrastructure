resource "aws_api_gateway_integration" "sqs-integration" {
  http_method = aws_api_gateway_method.proxy.http_method
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.logging_gateway.id
  type = "AWS"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:eu-west-2:sqs:path/${aws_sqs_queue.custom_log_queue.name}"
  credentials = aws_iam_role.custom-logging-sqs-write-role.arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }
}

resource "aws_iam_role" "custom-logging-sqs-write-role" {
  assume_role_policy = data.aws_iam_policy_document.custom-logging-sqs-write-role-assume-policy.json
}

resource "aws_iam_role_policy_attachment" "sqs-send-message-custom-logging-attachment" {
  policy_arn = aws_iam_policy.api-gateway-sqs-send-msg-policy.arn
  role = aws_iam_role.custom-logging-sqs-write-role.name
}

data "aws_iam_policy_document" "custom-logging-sqs-write-role-assume-policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "apigateway.amazonaws.com"]
      type = "Service"
    }
  }
}