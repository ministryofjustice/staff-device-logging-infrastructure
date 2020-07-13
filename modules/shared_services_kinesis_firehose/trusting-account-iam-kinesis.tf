resource "aws_iam_role" "kinesis-cloudwatch-subscription" {
  name = "${var.prefix}-kinesis-cloudwatch-subscription"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Statement": {
          "Effect": "Allow",
          "Principal": { "Service": "logs.${var.region}.amazonaws.com" },
          "Action": "sts:AssumeRole"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "kinesis-cloudwatch-subscription" {
  name = "${var.prefix}-kinesis-cloudwatch-subscription"
  path = "/"

  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "kinesis:PutRecord",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": ${aws_iam_role.kinesis-cloudwatch-subscription.arn}
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  role       = aws_iam_role.kinesis-cloudwatch-subscription.name
  policy_arn = aws_iam_policy.kinesis-cloudwatch-subscription.arn
}
