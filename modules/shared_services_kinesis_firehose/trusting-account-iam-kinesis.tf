resource "aws_iam_role" "kinesis-cloudwatch-subscription-role" {
  name = "${var.prefix}-kinesis-cloudwatch-subscription-role"
  policy = jsonencode({
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

resource "aws_iam_policy" "kinesis-cloudwatch-subscription-policy" {
  name = "${var.prefix}-kinesis-cloudwatch-subscription-policy"
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
        "Action": "iam:PassRole",
        "Resource": "${aws_iam_role.kinesis-cloudwatch-subscription-role.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  role       = aws_iam_role.kinesis-cloudwatch-subscription-role.name
  policy_arn = aws_iam_policy.kinesis-cloudwatch-subscription-policy.arn
}
