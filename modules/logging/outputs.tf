output "beats_role_arn" {
  value = aws_iam_role.beats-lambda-role.arn
}
output "beats_role_sqs_arn" {
  value = aws_iam_role.beats-lambda-role-sqs.arn
}
output "beats_role_kinesis_arn" {
  value = aws_iam_role.beats-lambda-role-kinesis.arn
}
output "beats_deploy_bucket" {
  value = aws_s3_bucket.functionbeat-deploy.bucket
}
output "beats_security_group_id" {
  value = aws_security_group.functionbeats.id
}
output "beats_public_security_group_id" {
  value = aws_security_group.functionbeats.id
}
