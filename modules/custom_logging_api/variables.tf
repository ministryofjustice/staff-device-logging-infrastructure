variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "enable_api_gateway_logs" {
  type    = bool
  default = false
}

variable "stage_name" {
  type    = string
  default = "main"
}

variable "vpn_hosted_zone_id" {
  type = string
}

variable "api_gateway_custom_domain" {
  type = string
}

variable "tags" {
  type = map(string)
}
