variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_1_id" {
  description = "ID of public subnet 1"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID of public subnet 2"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for ALB"
  type        = string
}