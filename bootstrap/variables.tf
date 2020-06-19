variable "is-production" {
  type    = bool
  default = "true"
}

variable "owner-email" {
  type    = string
  default = "emile.swarts@digital.justice.gov.uk"
}

variable "environment" {
  type = string
}

variable "shared_services_account_arn" {
  type = string
}