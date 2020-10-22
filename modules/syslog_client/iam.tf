resource "aws_iam_role" "syslog_client" {
  name               = "syslog_client"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "syslog_client" {
  role       = aws_iam_role.syslog_client.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

resource "aws_iam_instance_profile" "syslog_client" {
  name = "syslog_client"
  role = aws_iam_role.syslog_client.name
}
