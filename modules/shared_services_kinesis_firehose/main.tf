resource "aws_kinesis_stream" "shared_services_destination_stream" {
  name             = "${var.prefix}-shared-services-log-destinion-stream"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}
