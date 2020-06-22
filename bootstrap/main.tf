terraform {
  required_version = "> 0.12.23"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 2.52"
  profile = terraform.workspace
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  namespace = terraform.workspace
  stage     = var.environment
  name      = "infra"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/pttp-infrastructure"
  }
}
