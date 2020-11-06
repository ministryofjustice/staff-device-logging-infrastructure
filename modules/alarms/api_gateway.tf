resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-400-error-count" {
  alarm_name          = "${var.prefix}-api-gateway-number-of-400-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "10"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = var.custom_log_api_gateway_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the any 400 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-500-error-count" {
  alarm_name          = "${var.prefix}-api-gateway-number-of-500-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "10"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = var.custom_log_api_gateway_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the any 500 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-request-count" {
  alarm_name          = "${var.prefix}-api-gateway-request-count"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = var.custom_log_api_gateway_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the number of expected minimum requests to the API Gateway"
  treat_missing_data = "breaching"
}
