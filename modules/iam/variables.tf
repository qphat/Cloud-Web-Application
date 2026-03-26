variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret for IAM policy"
  type        = string
}
