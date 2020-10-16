variable "topic-name" {
  type = string
}

variable "emails" {
  type    = list
  default = []
}

variable "prefix" {
  type = string
}

variable "custom_log_queue_name" {
  type = string
}

variable "custom_log_api_gateway_name" {
  type = string
}

variable "beats_dead_letter_queue_name" {
  type = string
}

variable "cloudwatch_function_name" {
  type = string
}

variable "sqs_function_name" {
  type = string
}

variable "kinesis_function_name" {
  type = string
}

variable "kinesis_stream_name" {
  type = string
}

variable "syslog_service_name" {
  type = string
}
