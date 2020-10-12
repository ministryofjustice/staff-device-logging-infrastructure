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

variable "cidr_block_new_bits" {
  type    = number
  default = 8
}

variable "ecr_api_endpoint_private_dns_enabled" {
  type = bool
  default = false
}

variable "ecr_dkr_endpoint_private_dns_enabled" {
  type = bool
  default = false
}

variable "enable_ecr_api_endpoint" {
  type = bool
  default = false
}

variable "enable_ecr_dkr_endpoint" {
  type = bool
  default = false
}

variable "enable_dns_hostnames" {
  type = bool
  default = false
}

variable "enable_dns_support" {
  type = bool
  default = false
}

variable "enable_s3_endpoint" {
  type = bool
  default = false
}

variable "enable_logs_endpoint" {
  type = bool
  default = false
}
