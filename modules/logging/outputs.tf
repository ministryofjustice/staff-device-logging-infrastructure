resource "local_file" "ec2_private_key" {
  filename          = "ec2.pem"
  file_permission   = "0600"
  sensitive_content = tls_private_key.ec2.private_key_pem
}

output "beats_role_arn" {
  value = aws_iam_role_policy.beats-lambda-policy
}

output "beats_security_groups" {
  value = aws_security_group.pttp-logging-spike
}
