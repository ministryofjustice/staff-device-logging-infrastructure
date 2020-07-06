data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "pttp_cloudtrail" {
  name           = "${var.prefix}-pttp-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id
  // TODO: do we need this? If so, what value should we use?
  s3_key_prefix = "prefix"

  include_global_service_events = true
}

// TODO: do we need versioning?
resource "aws_s3_bucket" "cloudtrail_bucket" {
  # To do: add environment to bucket name
  bucket        = "${var.prefix}-pttp-cloudtrail-bucket"
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
            "Resource": "arn:aws:s3:::${var.prefix}-pttp-cloudtrail-bucket"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.prefix}-pttp-cloudtrail-bucket/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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
