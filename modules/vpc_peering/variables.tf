variable "enabled" {
  type = bool
}

variable "source_route_table_ids" {
  type = list(string)
}
variable "source_vpc_id" {
  type = string
}
variable "target_aws_account_id" {
  type = string
}
variable "target_vpc_id" {
  type = string
}
variable "target_vpc_cidr_block" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "internet_gateway_id" {
  type = string
}
