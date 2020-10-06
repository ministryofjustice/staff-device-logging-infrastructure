variable "prefix" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "critical_notifications_arn" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2c" {
  type = string
}

variable "container_name" {
  type = string
  default = "syslog-server"
}

variable "container_port" {
  type = string
  default = "514"
}
