variable "is_production" {
  type    = bool
  default = "true"
}

variable "owner_email" {
  type    = string
  default = "emile.swarts@digital.justice.gov.uk"
}

variable "shared_services_account_arn" {
  type = string
}
