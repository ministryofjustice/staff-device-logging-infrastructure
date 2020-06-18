terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    key    = "terraform/v1/state"
    region = "eu-west-2"
  }
}

provider "aws" {
  version = "~> 2.52"
}

provider "tls" {
  version = "> 2.1"
}

data "aws_region" "current_region" {}

module "palo-alto-roles" {
  source                      = "./modules/palo-alto-roles"
  shared_services_account_arn = var.shared_services_account_arn
}

module "made-tech-roles" {
  source                      = "./modules/made-tech"
  shared_services_account_arn = var.shared_services_account_arn
}
