resource "aws_cloudwatch_metric_alarm" "syslog-ecs-networkrxbytes" {
  alarm_name          = "${var.prefix}-syslog-ecs-networkrxbytes"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "5"
  metric_name         = "NetworkRxBytes"
  namespace           = "ECS/ContainerInsights"
  statistic           = "Average"
  period              = "60"

  dimensions = {
    ServiceName = var.syslog_service_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the received bytes of traffic for the Syslog service"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "syslog-ecs-networktxbytes" {
  alarm_name          = "${var.prefix}-syslog-ecs-networktxbytes"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "1000"
  evaluation_periods  = "5"
  metric_name         = "NetworkTxBytes"
  namespace           = "ECS/ContainerInsights"
  statistic           = "Average"
  period              = "60"

  dimensions = {
    ServiceName = var.syslog_service_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the sent bytes of traffic from the Syslog service"
  treat_missing_data = "breaching"
}
