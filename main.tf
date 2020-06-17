terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    key        = "terraform/v1/state"
    region     = "eu-west-2"
  }
}

provider "aws" {
  version = "~> 2.52"
  region  = "eu-west-2"
}

provider "tls" {
  version = "> 2.1"
}

data "aws_region" "current_region" {}

module "iam" {
  source = "./modules/iam"
}
