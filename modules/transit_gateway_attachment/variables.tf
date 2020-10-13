variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "transit_gateway_id" {
  type = string
}

variable "transit_gateway_route_table_id" {
  type = string
}
