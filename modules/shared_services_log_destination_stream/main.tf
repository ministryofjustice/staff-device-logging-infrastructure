locals {
  shared_service_log_destination_count = var.enable_shared_services_log_destination ? 1 : 0
}

resource "aws_kinesis_stream" "shared_services_destination_stream" {
  count            = local.shared_service_log_destination_count
  name             = "${var.prefix}-shared-services-log-destination-stream"
  shard_count      = 2
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.kinesis_stream_key.id
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes"
  ]
}

resource "aws_kms_key" "kinesis_stream_key" {
  description             = "${var.prefix}_shared_services_kinesis_stream_key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_iam_role" "cloudwatch_to_kinesis_role" {
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

resource "aws_iam_policy" "cloudwatch_to_kinesis_policy" {
  count = local.shared_service_log_destination_count
  name = "${var.prefix}-cloudwatch-to-kinesis-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect": "Allow",
        "Action": "kinesis:PutRecord",
        "Resource": "${element(aws_kinesis_stream.shared_services_destination_stream.*.arn, 0)}"
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
        "Resource": "${aws_iam_role.cloudwatch_to_kinesis_role.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_to_kinesis_attachment" {
  count      = local.shared_service_log_destination_count
  role       = element(aws_iam_role.cloudwatch_to_kinesis_role.*.name, 0)
  policy_arn = element(aws_iam_policy.cloudwatch_to_kinesis_policy.*.arn, 0)
}

resource "aws_cloudwatch_log_destination" "log_forward_to_kinesis" {
  count      = local.shared_service_log_destination_count
  name       = "${var.prefix}-log-forward-to-kinesis"
  role_arn   = aws_iam_role.cloudwatch_to_kinesis_role.arn
  target_arn = element(aws_kinesis_stream.shared_services_destination_stream.*.arn, 0)
}

data "aws_iam_policy_document" "log_forward_to_kinesis" {
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
      element(aws_cloudwatch_log_destination.log_forward_to_kinesis.*.arn, 0)
    ]
  }
}

resource "aws_cloudwatch_log_destination_policy" "cross_account_destination_policy" {
  count      = local.shared_service_log_destination_count
  destination_name = element(aws_cloudwatch_log_destination.log_forward_to_kinesis.*.name, 0)
  access_policy    = element(data.aws_iam_policy_document.log_forward_to_kinesis.*.json, 0)
}
