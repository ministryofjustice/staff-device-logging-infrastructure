module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.28.0"
  name = var.prefix

  cidr = var.cidr_block

   azs = [
     "${var.region}a",
     "${var.region}b",
     "${var.region}c"
   ]
  private_subnets = [
    cidrsubnet(var.cidr_block, 8, 1), # 10.0.1.0/24
    cidrsubnet(var.cidr_block, 8, 2), # 10.0.2.0/24
    cidrsubnet(var.cidr_block, 8, 3)  # 10.0.3.0/24
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 5),
    cidrsubnet(var.cidr_block, 8, 6),
    cidrsubnet(var.cidr_block, 8, 7) 
  ]

  enable_nat_gateway = true
}
