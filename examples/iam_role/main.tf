terraform {
  required_version = "> 0.12.0"
}

data "aws_caller_identity" "current" {}

resource "random_id" "name" {
  prefix      = "test-"
  byte_length = 8
}

module "role" {
  source                      = "../../modules/iam"
  iam-name                    = random_id.name.b64_url
  shared_services_account_arn = data.aws_caller_identity.current.arn
}

output "role_arn" {
  value = module.role.role_arn
}
