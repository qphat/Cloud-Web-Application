variable "ami_id" {
  description = "AMI ID for EC2 instances in Auto Scaling Group"
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
  description = "IAM instance profile for EC2 instances"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for EC2 instances"
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

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}