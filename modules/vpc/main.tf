module "vpc" {
  source                               = "terraform-aws-modules/vpc/aws"
  version                              = "2.50.0"
  name                                 = var.prefix
  propagate_private_route_tables_vgw   = var.propagate_private_route_tables_vgw
  cidr                                 = var.cidr_block
  single_nat_gateway                   = true
  enable_nat_gateway                   = true


  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  enable_flow_log                      = true
  create_igw = true

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

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 4)
  ]
}
