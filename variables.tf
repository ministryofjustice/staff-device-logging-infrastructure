variable "is-production" {
  type    = string
  default = true
}

variable "owner_email" {
  type = string
}

variable "assume_role" {
  type = string
}

variable "logging_cidr_block" {
  type        = string
  description = "the block to uses in the logging vpc" // WARNING! changing this in a applied workspace will cause an error! https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/467""
}

variable "enable_peering" {
  type = bool
}

variable "enable_critical_notifications" {
  type = bool
}

variable "ost_vpc_id" {
  type = string
}

variable "ost_aws_account_id" {
  type = string
}

variable "ost_vpc_cidr_block" {
  type = string
}

variable "ost_username" {
  type = string
}

variable "ost_password" {
  type = string
}

variable "ost_url" {
  type = string
}

variable "critical_notification_recipients" {
  type = list(string)
}

variable "enable_cloudtrail_log_shipping_to_cloudwatch" {
  type    = bool
  default = false
}

variable "enable_shared_services_log_destination" {
  type = bool
}

variable "enable_load_testing" {
  type    = bool
  default = false
}

variable "enable_api_gateway_custom_domain" {
  type    = bool
  default = false
}

variable "enable_api_gateway_logs" {
  type    = bool
  default = false
}

variable "env" {
  type    = string
  default = "development"
}

variable "syslog_receiver_cidr_block" {
  type = string
}

variable "syslog_load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "syslog_load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "syslog_load_balancer_private_ip_eu_west_2c" {
  type = string
}

