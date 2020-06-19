resource "aws_iam_role" "codebuild" {
  name = var.iam-name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : var.shared_services_account_arn }
        Condition = {}
    }]
  })
}

resource "aws_iam_policy" "codebuild" {
  name        = var.iam-name
  path        = "/"
  description = "Codebuild Palo Alto"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}
