output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.capstone_db.address
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.capstone_db_sg.id
}