locals {
  critical_notifications_count = var.enable_critical_notifications ? 1 : 0
}

# sqs ApproximateNumberOfMessagesVisible > 1k / 1 min
resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-visible-count" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the number of visible messages"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-sent" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the minimum amount of message sent"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-count-empty-receives" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-custom-logs-sqs-empty-receives"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfEmptyReceives"
  namespace           = "AWS/SQS"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    QueueName = "${aws_sqs_queue.custom_log_queue.name}"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description  = "This alarm monitors the amount of empty receives"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-number-messages-received-count" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the minimum amount of expected received messages"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-400-error-count" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the any 400 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-500-error-count" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the any 500 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-request-count" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the the number of expected minimum requests to the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-integration-latency" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the integration latency for API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-latency" {
  count               = local.critical_notifications_count
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

  alarm_description  = "This alarm monitors the latency"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-invocations-cloudwatch" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-invocations-cloudwatch"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-cloudwatch"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda invocations for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-invocations-sqs" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-invocations-sqs"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-sqs"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda invocations for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-errors-cloudwatch" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-errors-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-cloudwatch"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda Errors for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-errors-sqs" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-errors-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-sqs"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda Errors for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-destination-delivery-failures-cloudwatch" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-destination-delivery-failures-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "DestinationDeliveryFailures"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-cloudwatch"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda destination delivery errors for Cloudwatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-destination-delivery-failures-sqs" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-destination-delivery-failures-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "DestinationDeliveryFailures"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-sqs"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda destination delivery errors for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-throttles-cloudwatch" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-throttle-count-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-cloudwatch"

  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda throttles for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-throttles-sqs" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-throttle-count-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-sqs"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda throttles for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-concurrency-spillover-invocations-cloudwatch" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-provisioned-concurrency-spillover-count-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "ProvisionedConcurrencySpilloverInvocations"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-cloudwatch"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda provisioned concurrency spillover invocations Cloud Watch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-concurrency-spillover-invocations-sqs" {
  alarm_name          = "${var.prefix}-custom-logs-lambda-provisioned-concurrency-spillover-count-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "ProvisionedConcurrencySpilloverInvocations"
  namespace           = "AWS/Lambda"
  statistic           = "Minimum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.prefix}-infra-sqs"
  }

  alarm_actions = [var.sns_topic_arn]

  alarm_description = "This alarm monitors the the number of Lambda provisioned concurrency spillover invocations SQS data source"
  treat_missing_data = "breaching"
}
