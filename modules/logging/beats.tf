resource "aws_kms_key" "functionbeat" {
  description             = "${var.prefix}-functionbeat"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}
resource "aws_s3_bucket" "functionbeat-deploy" {
  bucket = "${var.prefix}-functionbeat-artifacts"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.functionbeat.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "functionbeat-deploy_public_block" {
  bucket = aws_s3_bucket.functionbeat-deploy.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_s3_bucket_acl" "functionbeat-deploy" {
  bucket     = aws_s3_bucket.functionbeat-deploy.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
# AWS Reference https://aws.amazon.com/blogs/aws/heads-up-amazon-s3-security-changes-are-coming-in-april-of-2023/
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.functionbeat-deploy.id
  rule {
    object_ownership = "ObjectWriter"
  }
}



data "aws_iam_policy_document" "beats-lambda-policy" {
  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface",
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
      "lambda:CreateEventSourceMapping",
      "lambda:DeleteFunction",
      "lambda:DeleteEventSourceMapping",
      "lambda:GetEventSourceMapping",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:PutFunctionConcurrency",
      "lambda:RemovePermission",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "cloudwatch:PutMetricData",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:SetAlarmState",
      "logs:DescribeLogGroups",
      "logs:PutSubscriptionFilter",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "s3:CreateBucket", //TODO: To remove
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:SendMessage",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "beats-lambda-policy-kinesis" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "beats-lambda-policy" {
  name = "${var.prefix}-beats-lambda-policy"
  role = aws_iam_role.beats-lambda-role.id

  policy = data.aws_iam_policy_document.beats-lambda-policy.json
}

resource "aws_iam_role_policy" "beats-lambda-policy-kinesis" {
  name = "${var.prefix}-beats-lambda-policy-kinesis"
  role = aws_iam_role.beats-lambda-role-kinesis.id

  policy = data.aws_iam_policy_document.beats-lambda-policy-kinesis.json
}

resource "aws_iam_role_policy" "beats-lambda-policy-kinesis-deploy" {
  name = "${var.prefix}-beats-lambda-policy-kinesis-deploy"
  role = aws_iam_role.beats-lambda-role-kinesis.id

  policy = data.aws_iam_policy_document.beats-lambda-policy.json

}

resource "aws_iam_role" "beats-lambda-role" {
  name = "${var.prefix}-beats-lambda-execution-role"

  tags = var.tags

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

resource "aws_iam_role" "beats-lambda-role-kinesis" {
  name = "${var.prefix}-beats-kinesis-execution"

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
  tags               = var.tags
}

resource "aws_security_group" "functionbeats" {
  name   = "${var.prefix}-functionbeats"
  vpc_id = var.vpc_id
  tags   = var.tags

  egress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
