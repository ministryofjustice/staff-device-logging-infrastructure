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

resource "aws_sqs_queue_policy" "allowed_sqs_principals" {
  count = length(var.allowed_sqs_principals) > 0 ? 1 : 0

  queue_url = aws_sqs_queue.custom_log_queue.id
  policy = data.aws_iam_policy_document.sqs_policy.json
}

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"

    sid = "SqsReceiveMessage"

    actions = [
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:GetQueue*",
      "sqs:ReceiveMessage"
    ]

    principals {
      type        = "AWS"
      identifiers = var.allowed_sqs_principals
    }

    resources = [
      aws_sqs_queue.custom_log_queue.arn
    ]
  }
}
