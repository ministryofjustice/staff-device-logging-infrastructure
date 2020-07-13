resource "aws_kinesis_stream" "shared_services_destination_stream" {
  name             = "${var.prefix}-shared-services-log-destinion-stream"
  shard_count      = 1
  encryption_type  = "KMS"
  kms_key_id       = aws_kms_key.kinesis_stream_key.id
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

resource "aws_kms_key" "kinesis_stream_key" {
  description             = "${var.prefix}-shared-services-kinesis-stream-key"
  deletion_window_in_days = 10
}

# resource "aws_cloudwatch_log_destination" "log-forward-to-kinesis" {
#   name       = "${var.prefix}-log-forward-to-kinesis"
#   role_arn   = "${aws_iam_role.kinesis-cloudwatch-subscription-role.arn}"
#   target_arn = "${aws_kinesis_stream.shared_services_destination_stream.arn}"
# }

# resource "aws_iam_policy" "kinesis-cloudwatch-subscription-destination-policy" {
#   name = "${var.prefix}-kinesis-cloudwatch-subscription-destination-policy"
#   path = "/"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         "Sid" : "",
#         "Effect" : "Allow",
#         "Principal" : {
#             "AWS" : var.shared_services_account_arn
#         },
#         "Action" : "logs:PutSubscriptionFilter",
#         "Resource" : "${aws_cloudwatch_log_destination.log-forward-to-kinesis.arn}"
#       }
#     ]
#   })
# }
