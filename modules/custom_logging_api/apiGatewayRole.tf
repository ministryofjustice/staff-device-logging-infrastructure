resource "aws_iam_role" "custom-logging-api-gateway-role" {
  name = "${var.prefix}-custom-logging-api-gateway-role"
  assume_role_policy = data.template_file.api_gateway_assume_role_policy.rendered
}

data "template_file" "api_gateway_assume_role_policy" {
  template = file("${path.module}/policies/apiGatewayAssumeRolePolicy.json")
}

resource "aws_iam_role_policy_attachment" "custom-logging-api-gateway-sqs-policy-attachment" {
  policy_arn = aws_iam_policy.api-gateway-sqs-policy.arn
  role = aws_iam_role.custom-logging-api-gateway-role.name
}

resource "aws_iam_role_policy_attachment" "custom-logging-api-gateway-kms-policy-attachment" {
  policy_arn = aws_iam_policy.api-gateway-kms-policy.arn
  role = aws_iam_role.custom-logging-api-gateway-role.name
}

resource "aws_iam_role_policy_attachment" "custom-logging-api-gateway-cloudwatch-policy-attachment" {
  policy_arn = aws_iam_policy.api-gateway-cloudwatch-policy.arn
  role = aws_iam_role.custom-logging-api-gateway-role.name
}