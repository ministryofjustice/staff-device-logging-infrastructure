data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "allow_cloudwatch_exec" {
  for_each = var.log_groups

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.aws_lambda_arn
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:${each.value}/:*"
  qualifier     = var.aws_lambda_alias_name
}

resource "aws_cloudwatch_log_subscription_filter" "test-app-cloudwatch-sumologic-lambda-subscription" {
  for_each   = var.log_groups
  depends_on = [aws_lambda_permission.allow_cloudwatch_exec]

  name            = "${var.prefix}-lambda-log-subscription"
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = var.aws_lambda_arn
}
