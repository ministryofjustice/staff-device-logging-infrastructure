variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "shared_services_account_arn" {
  type = string
}

variable "enable_shared_services_log_destination" {
  type = bool
}

variable "tags" {
  type = map(string)
}
