variable "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "nodeapp"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "student12"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "STUDENTS"
}