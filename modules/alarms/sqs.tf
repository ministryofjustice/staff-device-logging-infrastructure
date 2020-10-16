resource "aws_cloudwatch_metric_alarm" "logging-sqs-messages-visible-count" {
  alarm_name          = "${var.prefix}-sqs-messages-visible-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1000"

  dimensions = {
    QueueName = var.custom_log_queue_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the number of visible messages"
  treat_missing_data = "breaching"
}

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

resource "aws_cloudwatch_metric_alarm" "logging-dead-letter-queue-size" {
  alarm_name          = "${var.prefix}-dead-letter-queue-size"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    QueueName = var.beats_dead_letter_queue_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the number of messages in the dead letter queue"
  treat_missing_data = "breaching"
}
