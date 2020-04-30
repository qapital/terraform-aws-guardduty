variable "aws_account_id" {
  description = "The ID of the AWS account to use"
  type = string
}

variable "region" {
  description = "Which region are we running the module against"
  type = string
}

variable "users" {
  type        = list(string)
  description = "A list, where you can specify your members"
}

variable "bucket_prefix" {
  default     = "security"
  description = "The prefix to use for the s3 bucket"
  type = string
}

variable "group_name" {
  default     = "guardduty-admin"
  description = "The name of guardDuty admins"
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    "owner"   = "DevSecOps"
    "project" = "GuarDuty"
    "service" = "Core"
  }
}
