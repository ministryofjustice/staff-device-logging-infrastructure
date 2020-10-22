variable "instance_count" {
  type = number
}

variable "prefix" {
  type = string
}

variable "syslog_endpoint_vpc" {
  type = string
}

variable "subnet" {
  type = string
}

variable "load_balancer_ip" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_cidr_block" {
  type = string
}
