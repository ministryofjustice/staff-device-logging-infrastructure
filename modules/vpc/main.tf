module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"
  name = var.prefix

  cidr = var.cidr_block


  # azs = [
  #   "${var.region}a",
  #   "${var.region}b",
  #   "${var.region}c"
  # ]

  # private_subnets = [
  #   cidrsubnet(var.cidr_block, 8, 1), # 10.193.1.0/24
  #   cidrsubnet(var.cidr_block, 8, 2), # 10.193.2.0/24
  #   cidrsubnet(var.cidr_block, 8, 3)  # 10.193.3.0/24
  # ]

  # public_subnets = [
  #   cidrsubnet(var.cidr_block, 8, 4), # 10.193.4.0/24
  #   cidrsubnet(var.cidr_block, 8, 5), # 10.193.5.0/24
  #   cidrsubnet(var.cidr_block, 8, 6)  # 10.193.6.0/24
  # ]

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.193.1.0/24", "10.193.2.0/24", "10.193.3.0/24"]
  public_subnets  = ["10.193.4.0/24", "10.193.5.0/24", "10.193.6.0/24"]

  enable_nat_gateway = true
}
