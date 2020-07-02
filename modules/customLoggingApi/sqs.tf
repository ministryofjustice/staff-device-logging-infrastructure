resource "aws_sqs_queue" "custom_log_queue" {
  name = "${var.prefix}-custom-log-queue"

  kms_master_key_id                 = aws_kms_key.sqs_kms_master_key.key_id
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_kms_key" "sqs_kms_master_key" {
  description = "SQS KMS master key"
  deletion_window_in_days = 7
}