variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 in us-east-1
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
  default     = "vockey"
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2 instances"
  type        = string
  default     = "LabInstanceProfile"
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