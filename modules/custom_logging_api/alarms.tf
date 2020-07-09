# sqs ApproximateNumberOfMessagesVisible > 1k / 1 min
resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-visible-count" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-sqs-messages-visible-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1000"

  dimensions = {
    QueueName = "${aws_sqs_queue.custom_log_queue.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the number of visible messages"
  treat_missing_data = "breaching"
}

# sqs NumberOfMessagesSent < 1  / 10 min
resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-sent" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-sqs-messages-sent"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  statistic           = "Minimum"
  period              = "600"

  dimensions = {
    QueueName = "${aws_sqs_queue.custom_log_queue.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the minimum amount of message sent"
  treat_missing_data = "breaching"
}

# sqs NumberOfEmptyReceives > 1 / 1 min
resource "aws_cloudwatch_metric_alarm" "logging-sqs-count-empty-receives" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-sqs-empty-receives"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfEmptyReceives"
  namespace           = "AWS/SQS"
  statistic           = "Average"
  period              = "60"

  dimensions = {
    QueueName = "${aws_sqs_queue.custom_log_queue.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the amount of empty receives"
  treat_missing_data = "breaching"
}

# sqs NumberOfMessagesReceived < 100 / 1m
resource "aws_cloudwatch_metric_alarm" "logging-sqs-number-messages-received-count" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-sqs-number-of-messages-received"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "AWS/SQS"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    QueueName = "${aws_sqs_queue.custom_log_queue.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the minimum amount of expected received messages"
  treat_missing_data = "breaching"
}

# apigateway 4XXError > 0 / 1m
resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-400-error-count" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-api-gateway-number-of-400-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    ApiName = "${aws_api_gateway_rest_api.logging_gateway.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the any 400 errors on the API Gateway"
  treat_missing_data = "breaching"
}

# apigateway 5XXError > 0 / 1m
resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-500-error-count" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-api-gateway-number-of-500-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    ApiName = "${aws_api_gateway_rest_api.logging_gateway.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the any 500 errors on the API Gateway"
  treat_missing_data = "breaching"
}

# apigateway Count < 100 / 1m
resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-request-count" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-api-gateway-request-count"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    ApiName = "${aws_api_gateway_rest_api.logging_gateway.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of expected minimum requests to the API Gateway"
  treat_missing_data = "breaching"
}

# apigateway IntegrationLatency > 1000ms / 1m
resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-integration-latency" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-api-gateway-integration-latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    ApiName = "${aws_api_gateway_rest_api.logging_gateway.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the integration latency for API Gateway"
  treat_missing_data = "breaching"
}

# apigateway Latency > 1000ms / 1m
resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-latency" {
  count               = var.enable_critical_notifications
  alarm_name          = "${var.prefix}-custom-logs-api-gateway-latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    ApiName = "${aws_api_gateway_rest_api.logging_gateway.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the latency"
  treat_missing_data = "breaching"
}
