resource "aws_kinesis_stream" "shared_services_destination_stream" {
  name             = "${var.prefix}-shared-services-log-destinion-stream"
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.kinesis_stream_key.id
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kms_key" "kinesis_stream_key" {
  description             = "${var.prefix}-shared-services-kinesis-stream-key"
  deletion_window_in_days = 10
}
