output "beats_role_arn" {
  value = aws_iam_role.beats-lambda-role.arn
}
output "beats_security_group_id" {
  value = aws_security_group.functionbeats.id
}
