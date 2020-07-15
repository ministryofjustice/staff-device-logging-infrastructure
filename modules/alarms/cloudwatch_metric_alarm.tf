resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-visible-count" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-sqs-messages-visible-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1000"

  dimensions = {
    QueueName = "${var.custom_log_queue_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the number of visible messages"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-sent" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-sqs-messages-sent"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "600"

  dimensions = {
    QueueName = "${var.custom_log_queue_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the minimum amount of message sent"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-number-messages-received-count" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-sqs-number-of-messages-received"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    QueueName = "${var.custom_log_queue_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the minimum amount of expected received messages"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-dead-letter-queue-size" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-dead-letter-queue-size"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    QueueName = "${var.beats_dead_letter_queue_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the the number of messages in the dead letter queue"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-400-error-count" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-api-gateway-number-of-400-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = "${var.custom_log_api_gateway_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the any 400 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-500-error-count" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-api-gateway-number-of-500-error-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = "${var.custom_log_api_gateway_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the any 500 errors on the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-request-count" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-api-gateway-request-count"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    ApiName = "${var.custom_log_api_gateway_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the the number of expected minimum requests to the API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-integration-latency" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-api-gateway-integration-latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "1"
  metric_name         = "IntegrationLatency"
  namespace           = "AWS/ApiGateway"
  statistic           = "Maximum"
  period              = "60"

  dimensions = {
   ApiName = "${var.custom_log_api_gateway_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the integration latency for API Gateway"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-gateway-latency" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-api-gateway-latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "1"
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  statistic           = "Maximum"
  period              = "60"

  dimensions = {
    ApiName = "${var.custom_log_api_gateway_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the latency"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-invocations-cloudwatch" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-invocations-cloudwatch"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.cloudwatch_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda invocations for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-invocations-kinesis" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-invocations-kinesis"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.kinesis_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda invocations for the Kinesis stream"
  treat_missing_data = "breaching"
}


resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-invocations-sqs" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-invocations-sqs"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.sqs_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda invocations for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-errors-cloudwatch" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-errors-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.cloudwatch_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda Errors for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-errors-kinesis" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-errors-kinesis"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.kinesis_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda Errors for the Shared Services Kinesis stream"
  treat_missing_data = "breaching"
}


resource "aws_cloudwatch_metric_alarm" "logging-api-lambda-errors-sqs" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-errors-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.sqs_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda Errors for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-throttles-cloudwatch" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-throttle-count-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.cloudwatch_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda throttles for CloudWatch data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-throttles-kinesis" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-throttle-count-kinesis"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.kinesis_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda throttles for the Kinesis stream"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-throttles-sqs" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-throttle-count-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.sqs_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda throttles for SQS data source"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-spillover-count-sqs" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-spillover-count-sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "ProvisionedConcurrencySpilloverInvocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.sqs_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda provisioned concurrency spillovers for SQS data source"
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-spillover-count-kinesis" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-spillover-count-kinesis"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "ProvisionedConcurrencySpilloverInvocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.kinesis_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda provisioned concurrency spillovers for the Kinesis stream"
  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-lambda-spillover-count-cloudwatch" {
  count               = local.critical_notifications_count
  alarm_name          = "${var.prefix}-lambda-spillover-count-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "ProvisionedConcurrencySpilloverInvocations"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    FunctionName = "${var.cloudwatch_function_name}"
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the the number of Lambda provisioned concurrency spillovers for CloudWatch data source"
  treat_missing_data = "notBreaching"
}

# Kinesis
