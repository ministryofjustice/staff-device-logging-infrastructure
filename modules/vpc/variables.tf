variable "cidr_block" {
  type = string
}

variable "region" {
  type = string
}

variable "prefix" {
  type = string
}

variable "propagate_private_route_tables_vgw" {
  type = bool
  default = false
}
