variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  default = []
}

variable "prefix" {
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

variable "route_table_id" {
  type = list(string)
}
