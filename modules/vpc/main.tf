module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.28.0"

  name = var.prefix

  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  cidr                   = var.cidr_block

  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 1),
    cidrsubnet(var.cidr_block, 8, 2)
  ]

  private_subnets = [
    cidrsubnet(var.cidr_block, 8, 3),
    cidrsubnet(var.cidr_block, 8, 4)
  ]

  map_public_ip_on_launch = false
}
