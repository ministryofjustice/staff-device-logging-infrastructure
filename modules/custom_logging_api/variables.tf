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
