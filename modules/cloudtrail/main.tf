data "aws_caller_identity" "current" {}

// TODO: rename this resource
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${var.prefix}-cloudtrail-log-group"
}

/*
resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "${var.prefix}-cloudtrail-log-stream"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
}
*/

resource "aws_iam_policy" "cloudtrail_policy" {
  name   = "${var.prefix}-cloudtrail-policy"
  policy = data.template_file.cloud_trail_cloud_watch_policies.rendered
}

data "template_file" "cloud_trail_cloud_watch_policies" {
  template = file("${path.module}/policies/cloudTrailCloudwatchPolicies.json")

  vars = {
    log_group_arn = aws_cloudwatch_log_group.cloudwatch_log_group.arn
  }
}

resource "aws_iam_role" "cloudtrail_role" {
  name               = "${var.prefix}-cloudtrail-role"
  assume_role_policy = data.template_file.cloudtrail_assume_role_policy.rendered
}

data "template_file" "cloudtrail_assume_role_policy" {
  template = file("${path.module}/policies/cloudTrailAssumeRolePolicy.json")
}

// TODO: rename
resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_access_policy_attachment" {
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
  role       = aws_iam_role.cloudtrail_role.name
}

resource "aws_cloudtrail" "pttp_cloudtrail" {
  name           = "${var.prefix}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id
  // TODO: do we need this? If so, what value should we use?
  s3_key_prefix                 = "prefix"
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudwatch_log_group.arn
  include_global_service_events = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  // TODO (do we need this?):
  // include_management_events = true
}

// TODO: do we need versioning?
// TODO: encrypt this bucket
// TODO: how to test this?
resource "aws_s3_bucket" "cloudtrail_bucket" {
  # To do: add environment to bucket name
  bucket        = "${var.prefix}-cloudtrail-bucket"
  force_destroy = true

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
            "Resource": "arn:aws:s3:::${var.prefix}-cloudtrail-bucket"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.prefix}-cloudtrail-bucket/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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

