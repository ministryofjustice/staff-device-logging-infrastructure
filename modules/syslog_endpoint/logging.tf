resource "aws_cloudwatch_log_group" "server_log_group" {
  name = "${var.prefix}-server-log-group"

  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "syslog_log_group" {
  name = "${var.prefix}-logs-log-group"

  retention_in_days = 7

  tags = var.tags
}

