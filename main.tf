# terraform {
#   required_version = "> 0.12.0"

#   backend "s3" {
#     key    = "terraform/v1/state"
#     region = "eu-west-2"
#   }
# }

# provider "aws" {
#   version = "~> 2.52"
#   profile = terraform.workspace
# }

provider "tls" {
  version = "> 2.1"
}

data "aws_region" "current_region" {}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  namespace = ""
  stage     = terraform.workspace
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

# module "bootstrap" {
#   source                      = "./modules/bootstrap"
#   shared_services_account_arn = var.shared_services_account_arn
#   prefix = ""
# }
provider "random" {
  version = "~> 2.2.1"
}

resource "random_string" "random" {
  length = 10
  upper = false
  special = false
}

module "logging" {
  source    = "./modules/logging"
  providers = {
    aws = "aws.env"
  }
}
