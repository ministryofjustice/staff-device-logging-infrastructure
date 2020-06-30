variable "aws_lambda_arn" {
  type = string
}

variable "aws_lambda_alias_name" {
  type        = string
  description = "This alias will define what version to use. This is to allow indpendent deploys of the lambda from this subscription"
}

variable "log_groups" {
  type        = set(string)
  description = "The name of the log group to moniter"
}

variable "prefix" {
  type = string
}
