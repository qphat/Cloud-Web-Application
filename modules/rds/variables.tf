variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID of private subnet 1"
  type        = string
}

variable "private_subnet_2_id" {
  description = "ID of private subnet 2"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}