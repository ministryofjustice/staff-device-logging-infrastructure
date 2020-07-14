data "aws_caller_identity" "current" {}

resource "aws_flow_log" "pttp_flow_logs" {
  iam_role_arn             = aws_iam_role.flow_logs_role.arn
  log_destination          = aws_cloudwatch_log_group.vpc_flow_logs_log_group.arn
  traffic_type             = "ALL"
  max_aggregation_interval = 60 // 1 Minute
  vpc_id                   = var.vpc_id

  tags = var.tags
}

resource "aws_kms_key" "vpc_flow_logs_kms_key" {
  description             = "${var.prefix}-vpc-flow-logs-kms-key"
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

resource "aws_kms_alias" "vpc_flow_logs_kms_key_alias" {
  name          = "alias/${var.prefix}-vpc-flow-logs-kms-key-alias"
  target_key_id = aws_kms_key.vpc_flow_logs_kms_key.key_id
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs_log_group" {
  name              = "${var.prefix}-vpc-flow-logs-log-group"
  kms_key_id        = aws_kms_key.vpc_flow_logs_kms_key.arn
  retention_in_days = 1

  tags = var.tags
}

resource "aws_iam_role" "flow_logs_role" {
  name = "${var.prefix}-vpc-flow-logs-role"

  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// TODO: get this looking the same way it does for our CloudTrail policies
resource "aws_iam_role_policy" "flow_logs_role_policy" {
  name = "${var.prefix}-vpc-flow-logs-role-policy"
  role = aws_iam_role.flow_logs_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
