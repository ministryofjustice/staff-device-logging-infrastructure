resource "aws_cloudwatch_metric_alarm" "kinesis-oldest-message" {
  alarm_name          = "${var.prefix}-kinesis-oldest-message"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "72000000" # miliseconds 1000 * 60 * 60 * 2 = 2 hours
  evaluation_periods  = "2"
  metric_name         = "GetRecords.IteratorAgeMilliseconds"
  namespace           = "AWS/Kinesis"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    StreamName = var.kinesis_stream_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the age of the oldest record"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "kinesis-minimum-expected-records" {
  alarm_name          = "${var.prefix}-kinesis-minimum-expected-records"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  metric_name         = "IncomingRecords"
  namespace           = "AWS/Kinesis"
  statistic           = "Sum"
  period              = "60"

  dimensions = {
    StreamName = var.kinesis_stream_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description = "This alarm monitors the minimum number of incoming records on the Kinesis stream"
  treat_missing_data = "breaching"
}
