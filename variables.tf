variable "is-production" {
  type    = string
  default = true
}

variable "owner-email" {
  type = string
}

variable "assume_role" {
  type = string
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