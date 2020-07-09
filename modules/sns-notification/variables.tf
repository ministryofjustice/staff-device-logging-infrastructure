variable "topic-name" {
  type = "string"
}

variable "emails" {
  type    = "list"
  default = []
}

variable "prefix" {
  type    = "string"
}

variable "enable_critical_notifications" {
  type = number
}