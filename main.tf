terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    bucket = "logging-codebuild-target-terraform-state"
    region = "eu-west-2"
  }
}

provider "aws" {
  version = "~> 2.52"
  alias   = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

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

locals {
  cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.28.0"

  name = module.label.id

  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr                 = local.cidr_block

  azs = [
    "${data.aws_region.current_region.id}a",
    "${data.aws_region.current_region.id}b",
    "${data.aws_region.current_region.id}c"
  ]

  private_subnets = [
    cidrsubnet(local.cidr_block, 8, 1),
    cidrsubnet(local.cidr_block, 8, 2),
    cidrsubnet(local.cidr_block, 8, 3)
  ]

  map_public_ip_on_launch = false
}

module "logging" {
  source = "./modules/logging"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  prefix = module.label.id

  providers = {
    aws = aws.env
  }
}
