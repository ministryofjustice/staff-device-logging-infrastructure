terraform {
  required_version = "> 0.12.23"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 2.52"
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  namespace = "pttp"
  stage     = var.environment
  name      = "pttp-infrastructure"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "pttp-infrastructure",
    "is-production" = tostring(var.is-production),
    "owner"         = var.owner-email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/pttp-infrastructure"
  }
}
