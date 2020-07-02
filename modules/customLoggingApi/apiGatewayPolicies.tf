resource "aws_iam_policy" "api-gateway-sqs-policy" {
  name = "${var.prefix}-api-gateway-sqs-policy"
  policy = data.template_file.api_gateway_sqs_policy.rendered
}

data "template_file" "api_gateway_sqs_policy" {
  template = file("${path.module}/policies/apiGatewaySqsPolicies.json")

  vars = {
    sqs_arn   = aws_sqs_queue.custom_log_queue.arn
  }
}


resource "aws_iam_policy" "api-gateway-cloudwatch-policy" {
  name = "${var.prefix}-api-gateway-cloudwatch-policy"
  policy = data.template_file.api_gateway_cloudwatch_policy.rendered
}

data "template_file" "api_gateway_cloudwatch_policy" {
  template = file("${path.module}/policies/apiGatewayCloudwatchPolicies.json")
}


resource "aws_iam_policy" "api-gateway-kms-policy" {
  name = "${var.prefix}-api-gateway-kms-policy"
  policy = data.template_file.api_gateway_kms_policy.rendered
}

data "template_file" "api_gateway_kms_policy" {
  template = file("${path.module}/policies/apiGatewayKmsPolicies.json")
}
