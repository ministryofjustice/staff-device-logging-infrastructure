variable "is-production" {
  type    = string
  default = true
}

variable "owner_email" {
  type = string
}

variable "assume_role" {
  type = string
}

variable "logging_cidr_block" {
  type        = string
  description = "the block to uses in the logging vpc" // WARNING! changing this in a applied workspace will cause an error! https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/467""
}

variable "enable_peering" {
  type = bool
}

variable "ost_vpc_id" {
  type = string
}

variable "ost_aws_account_id" {
  type = string
}

variable "ost_vpc_cidr_block" {
  type = string
}
