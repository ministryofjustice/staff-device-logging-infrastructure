resource "aws_iam_policy" "api-gateway-sqs-send-msg-policy" {
//  policy = data.aws_iam_policy_document.api-gateway-sqs-send-msg-policy-doc.json
  policy = data.template_file.gateway_policy.rendered
}

data "template_file" "gateway_policy" {
  template = file("modules/logging/policies.json")

  vars = {
    sqs_arn   = aws_sqs_queue.custom_log_queue.arn
  }
}

//data "aws_iam_policy_document" "api-gateway-sqs-send-msg-policy-doc" {
//  statement {
//    effect = "Allow"
//    actions = [
//      "sqs:SendMessage"
//    ]
//    resources = [
//      aws_sqs_queue.custom_log_queue.arn
//    ]
//  }
//}