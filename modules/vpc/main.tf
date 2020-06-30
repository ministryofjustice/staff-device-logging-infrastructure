module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.28.0"
  name = var.prefix

  cidr = var.cidr_block
  one_nat_gateway_per_az = true

   azs = [
     "${var.region}a",
     "${var.region}b",
     "${var.region}c"
   ]
  private_subnets = [
    cidrsubnet(var.cidr_block, 8, 1), # 10.193.1.0/24
    cidrsubnet(var.cidr_block, 8, 2), # 10.193.2.0/24
    cidrsubnet(var.cidr_block, 8, 3)  # 10.193.3.0/24
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 5), # 10.193.5.0/24
    cidrsubnet(var.cidr_block, 8, 6)  # 10.193.6.0/24
  ]

  enable_nat_gateway = true
}
