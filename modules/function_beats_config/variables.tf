variable "prefix" {
  type = string
}
variable "deploy_bucket" {
  type = string
}
variable "deploy_role_arn" {
  type = string
}
variable "deploy_role_kinesis_arn" {
  type = string
}
variable "security_group_ids" {
  type = set(string)
}
variable "subnet_ids" {
  type = set(string)
}
variable "destination_url" {
  type = string
}
variable "destination_username" {
  type = string
}
variable "destination_password" {
  type = string
}
variable "log_groups" {
  type = set(string)
}

variable "syslog_log_groups" {
  type = set(string)
}

variable sqs_log_queue {
  type = string
}
variable beats_dead_letter_queue_arn {
  type = string
}

variable kinesis_stream_arn {
  type = string
}
