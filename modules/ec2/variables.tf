variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_1_id" {
  description = "ID of the public subnet 1"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for CapstoneAppServer"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}