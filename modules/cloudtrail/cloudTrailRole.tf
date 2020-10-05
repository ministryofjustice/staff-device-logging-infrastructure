resource "aws_iam_role" "cloudtrail_role" {
  name               = "${var.prefix}-cloudtrail-role"
  assume_role_policy = data.template_file.cloudtrail_assume_role_policy.rendered

  tags = var.tags
}

data "template_file" "cloudtrail_assume_role_policy" {
  template = file("${path.module}/policies/cloudTrailAssumeRolePolicy.json")
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_access_policy_attachment" {
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
  role       = aws_iam_role.cloudtrail_role.name
}
