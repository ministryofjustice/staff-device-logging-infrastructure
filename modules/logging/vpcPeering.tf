resource "aws_vpc_peering_connection" "ost_logging_vpc" {
  peer_owner_id                   = var.ost_aws_account_id
  peer_vpc_id                     = var.ost_vpc_id
  vpc_id                          = var.vpc_id
  allow_remote_vpc_dns_resolution = true
}