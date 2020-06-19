variable "shared_services_account_arn" {
  type = string
}

variable "environment" {
  type = string
}

variable "is-production" {
  type = string
  default = true
}

variable "owner-email" {
  type = string
}
