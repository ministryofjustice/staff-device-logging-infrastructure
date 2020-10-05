resource "aws_iam_policy" "cloudtrail_policy" {
  name   = "${var.prefix}-cloudtrail-policy"
  policy = element(data.template_file.cloud_trail_cloud_watch_policies.*.rendered, 0)
}

data "template_file" "cloud_trail_cloud_watch_policies" {
  template = file("${path.module}/policies/cloudTrailCloudwatchPolicies.json")

  vars = {
    log_group_arn = element(aws_cloudwatch_log_group.cloudtrail_log_group.*.arn, 0)
  }
}
