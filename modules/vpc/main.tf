module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.50.0"
  name    = var.prefix

  cidr               = var.cidr_block
  enable_nat_gateway = false

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  private_subnets = [
    cidrsubnet(var.cidr_block, 8, 1),
    cidrsubnet(var.cidr_block, 8, 2),
    cidrsubnet(var.cidr_block, 8, 3)
  ]
}
