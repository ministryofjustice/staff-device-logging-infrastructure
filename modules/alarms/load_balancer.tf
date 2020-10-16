resource "aws_cloudwatch_metric_alarm" "network-load-balancer-healthy-host-count" {
  alarm_name          = "${var.prefix}-nlb-healthy-host-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "1"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  statistic           = "Average"
  period              = "60"

  dimensions = {
    TargetGroup = var.target_group_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "Number of unhealthy hosts in target group"
  treat_missing_data = "breaching"
}
