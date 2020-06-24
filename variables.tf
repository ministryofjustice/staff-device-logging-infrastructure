variable "environment" {
  type = string
}

variable "is-production" {
  type    = string
  default = true
}

variable "owner-email" {
  type = string
}

variable "assume_role" {
  type = string
}