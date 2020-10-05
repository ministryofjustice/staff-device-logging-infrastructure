data "template_file" "cloud_trail_kms_key_policies" {
  template = file("${path.module}/policies/kmsKeyPolicies.json")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = var.region
  }
}
