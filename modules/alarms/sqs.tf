resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-sent" {
  alarm_name          = "${var.prefix}-sqs-messages-sent"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "600"

  dimensions = {
    QueueName = var.custom_log_queue_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the minimum amount of message sent"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "logging-sqs-number-messages-received-count" {
  alarm_name          = "${var.prefix}-sqs-number-of-messages-received"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    QueueName = var.custom_log_queue_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the minimum amount of expected received messages"
  treat_missing_data = "breaching"
}


