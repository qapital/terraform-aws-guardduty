variable "aws_account_id" {
  description = "The ID of the AWS account to use"
}

variable "aws_region" {
  description = "Which region are we running the module against"
}

variable "users" {
  type        = "list"
  description = "A list, where you can specify your members"
}

variable "bucket_prefix" {
  default     = "security"
  description = "The prefix to use for the s3 bucket"
}

variable "group_name" {
  default     = "guardduty-admin"
  description = "The name of guardDuty admins"
}

variable "tags" {
  default = {
    "owner"   = "DevSecOps"
    "project" = "GuarDuty"
    "service" = "Core"
  }
}
