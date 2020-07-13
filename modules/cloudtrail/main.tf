data "aws_caller_identity" "current" {}

locals {
  s3_bucket_log_prefix                        = "cloudtrail_logs"
  cloud_trail_bucket_name                     = "${var.prefix}-cloudtrail-bucket"
  cloudtrail_log_shipping_to_cloudwatch_count = var.enable_cloudtrail_log_shipping_to_cloudwatch ? 1 : 0
}

resource "aws_kms_key" "cloudtrail_kms_key" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  description             = "${var.prefix}-cloudtrail-kms-key"
  deletion_window_in_days = 10

  tags = var.tags

  // TODO: put this policy into its own file
  policy = <<POLICY
{
 "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${var.region}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnEquals": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*"
                }
            }
        }    
    ]
}
POLICY
}

resource "aws_kms_alias" "cloudtrail_kms_key_alias" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name          = "alias/${var.prefix}-cloudtrail-kms-key-alias"
  target_key_id = element(aws_kms_key.cloudtrail_kms_key.*.key_id, 0)
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name              = "${var.prefix}-cloudtrail-log-group"
  kms_key_id        = element(aws_kms_key.cloudtrail_kms_key.*.arn, 0)
  retention_in_days = 1

  tags = var.tags
}

resource "aws_cloudtrail" "pttp_cloudtrail" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = element(aws_s3_bucket.cloudtrail_bucket.*.id, 0)
  s3_key_prefix                 = local.s3_bucket_log_prefix
  cloud_watch_logs_group_arn    = element(aws_cloudwatch_log_group.cloudtrail_log_group.*.arn, 0)
  cloud_watch_logs_role_arn     = element(aws_iam_role.cloudtrail_role.*.arn, 0)
  include_global_service_events = true
  is_multi_region_trail         = true

  tags = var.tags
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  count = local.cloudtrail_log_shipping_to_cloudwatch_count

  bucket        = local.cloud_trail_bucket_name
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = element(aws_kms_key.cloudtrail_kms_key.*.arn, 0)
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 1
    }
  }

  tags = var.tags

  // TODO: put this policy into its own file
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.cloud_trail_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.cloud_trail_bucket_name}/${local.s3_bucket_log_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
