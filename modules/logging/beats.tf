resource "aws_kms_key" "functionbeat" {
  description             = "${var.prefix}-functionbeat"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "functionbeat-deploy" {
  bucket = "${var.prefix}-functionbeat-artifacts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.functionbeat.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role_policy" "beats-lambda-policy" {
  name = "${var.prefix}-beats-lambda-policy"
  role = aws_iam_role.beats-lambda-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStackResources",
                "cloudformation:GetTemplate",
                "cloudformation:UpdateStack",
                "cloudformation:ValidateTemplate",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "lambda:AddPermission",
                "lambda:CreateFunction",
                "lambda:DeleteFunction",
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:PutFunctionConcurrency",
                "lambda:RemovePermission",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "logs:*",
                "cloudwatch:*",
                "s3:CreateBucket",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:PutObject",
                "ec2:*",
                "sqs:*",
                "s3:GetObject",
                "kms:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "beats-lambda-role" {
  name = "${var.prefix}-pttp-test-beats-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
