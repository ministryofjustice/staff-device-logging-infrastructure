resource "aws_cloudwatch_metric_alarm" "invocations" {
  count               = length(var.lambda_function_names)
  alarm_name          = element(var.lambda_function_names, count.index)
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = element(var.lambda_function_names, count.index)
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "Minimum expected Lambda invocations the ${element(var.lambda_function_names, count.index)} function"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  count               = length(var.lambda_function_names)
  alarm_name          = element(var.lambda_function_names, count.index)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = element(var.lambda_function_names, count.index)
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "Lambda errors for the ${element(var.lambda_function_names, count.index)} function"
  treat_missing_data = "breaching"
}
