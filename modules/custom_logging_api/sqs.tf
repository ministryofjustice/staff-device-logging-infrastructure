resource "aws_sqs_queue" "custom_log_queue" {
  name = "${var.prefix}-custom-log-queue"

  kms_master_key_id                 = aws_kms_key.sqs_kms_master_key.key_id
  kms_data_key_reuse_period_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_custom_log_queue.arn
    maxReceiveCount     = 5
  })
}

resource "aws_sqs_queue" "dlq_custom_log_queue"{
  name = "${var.prefix}-dlq-custom-log-queue"
  message_retention_seconds         = 604800
  kms_master_key_id                 = aws_kms_key.sqs_kms_master_key.key_id
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_kms_key" "sqs_kms_master_key" {
  description             = "${var.prefix} SQS KMS master key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
