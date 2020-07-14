locals {
  shared_service_log_destination_count = var.enable_shared_services_log_destination ? 1 : 0
}

resource "aws_kinesis_stream" "shared_services_destination_stream" {
  count            = local.shared_service_log_destination_count
  name             = "${var.prefix}-shared-services-log-destination-stream"
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.kinesis_stream_key.id
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes"
  ]
}

resource "aws_kms_key" "kinesis_stream_key" {
  description             = "${var.prefix}-shared-services-kinesis-stream-key"
  deletion_window_in_days = 10
}

resource "aws_iam_role" "cloudwatch-to-kinesis-role" {
  name = "${var.prefix}-cloudwatch-to-kinesis-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect": "Allow",
        "Principal": { "Service": "logs.${var.region}.amazonaws.com" },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch-to-kinesis-policy" {
  name = "${var.prefix}-cloudwatch-to-kinesis-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect": "Allow",
        "Action": "kinesis:PutRecord",
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "iam:PassRole",
        "Resource": "${aws_iam_role.cloudwatch-to-kinesis-role.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  count      = local.shared_service_log_destination_count
  role       = aws_iam_role.cloudwatch-to-kinesis-role.name
  policy_arn = aws_iam_policy.cloudwatch-to-kinesis-policy.arn
}

resource "aws_cloudwatch_log_destination" "log-forward-to-kinesis" {
  count      = local.shared_service_log_destination_count
  name       = "${var.prefix}-log-forward-to-kinesis"
  role_arn   = aws_iam_role.cloudwatch-to-kinesis-role.arn
  target_arn = element(aws_kinesis_stream.shared_services_destination_stream.*.arn, 0)
}

data "aws_iam_policy_document" "log-forward-to-kinesis" {
  count = local.shared_service_log_destination_count
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        var.shared_services_account_arn,
      ]
    }

    actions = [
      "logs:PutSubscriptionFilter",
    ]

    resources = [
      element(aws_cloudwatch_log_destination.log-forward-to-kinesis.*.arn, 0)
    ]
  }
}

resource "aws_cloudwatch_log_destination_policy" "cross_account_destination_policy" {
  count      = local.shared_service_log_destination_count
  destination_name = element(aws_cloudwatch_log_destination.log-forward-to-kinesis.*.name, 0)
  access_policy    = element(data.aws_iam_policy_document.log-forward-to-kinesis.*.json, 0)
}
