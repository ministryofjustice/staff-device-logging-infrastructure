module "vpc" {
  source                               = "terraform-aws-modules/vpc/aws"
  version                              = "2.50.0"
  name                                 = var.prefix
  propagate_private_route_tables_vgw   = var.propagate_private_route_tables_vgw
  cidr                                 = var.cidr_block
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  enable_flow_log                      = true

  enable_ecr_api_endpoint = var.enable_ecr_api_endpoint
  enable_ecr_dkr_endpoint = var.enable_ecr_dkr_endpoint
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  enable_s3_endpoint = var.enable_s3_endpoint
  enable_logs_endpoint = var.enable_logs_endpoint
  ecr_api_endpoint_private_dns_enabled = var.ecr_api_endpoint_private_dns_enabled
  ecr_dkr_endpoint_private_dns_enabled = var.ecr_dkr_endpoint_private_dns_enabled

  logs_endpoint_security_group_ids = [aws_security_group.ecr.id]
  ecr_api_endpoint_security_group_ids  = [aws_security_group.ecr.id]
  ecr_dkr_endpoint_security_group_ids = [aws_security_group.ecr.id]

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  private_subnets = [
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 1),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 2),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 3)
  ]
}

resource "aws_security_group" "ecr" {
  name   = "${var.prefix}-ecr"
  vpc_id = module.vpc.vpc_id

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.cidr_block]
  }
}
