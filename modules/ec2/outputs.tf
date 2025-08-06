output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.capstone_app_sg.id
}

output "capstone_poc_public_ip" {
  description = "Public IP of CapstonePOC instance"
  value       = aws_instance.capstone_poc.public_ip
}

output "capstone_app_server_public_ip" {
  description = "Public IP of CapstoneAppServer instance"
  value       = aws_instance.capstone_app_server.public_ip
}

output "capstone_app_server_id" {
  description = "ID of CapstoneAppServer instance"
  value       = aws_instance.capstone_app_server.id
}