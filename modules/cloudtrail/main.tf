data "aws_caller_identity" "current" {}

locals {
  s3_bucket_log_prefix                        = "cloudtrail_logs"
  cloud_trail_bucket_name                     = "${var.prefix}-cloudtrail-bucket"
}

resource "aws_kms_key" "cloudtrail_kms_key" {
  description             = "${var.prefix}-cloudtrail-kms-key"
  deletion_window_in_days = 10
  policy                  = data.template_file.cloud_trail_kms_key_policies.rendered

  tags = var.tags
}

resource "aws_kms_alias" "cloudtrail_kms_key_alias" {
  name          = "alias/${var.prefix}-cloudtrail-kms-key-alias"
  target_key_id = aws_kms_key.cloudtrail_kms_key.key_id
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "${var.prefix}-cloudtrail-log-group"
  kms_key_id        = aws_kms_key.cloudtrail_kms_key.arn
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudtrail" "pttp_cloudtrail" {
  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  s3_key_prefix                 = local.s3_bucket_log_prefix
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail_kms_key.arn

  tags = var.tags
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = local.cloud_trail_bucket_name
  force_destroy = true
  policy        = data.template_file.s3_bucket_policies.rendered

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.cloudtrail_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 7
    }
  }

  tags = var.tags
}
