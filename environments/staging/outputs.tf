# -----------------------------------------------------
# Networking
# -----------------------------------------------------
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

# -----------------------------------------------------
# Compute
# -----------------------------------------------------
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.compute.alb_dns_name
}

output "key_pair_name" {
  description = "SSH key pair name"
  value       = module.compute.key_pair_name
}

output "private_key_pem" {
  description = "SSH private key"
  value       = module.compute.private_key_pem
  sensitive   = true
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.compute.asg_name
}

# -----------------------------------------------------
# Database
# -----------------------------------------------------
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.database.rds_endpoint
}

output "db_secret_arn" {
  description = "Secrets Manager ARN"
  value       = module.database.db_secret_arn
}
